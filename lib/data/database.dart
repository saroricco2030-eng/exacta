/// Drift ORM database - SQLite local storage
/// Tables: Projects, Photos, StampConfigs | Migration v1-v10
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:exacta/core/enums.dart';

part 'database.g.dart';

// ── 테이블 정의 (CLAUDE.md 데이터 구조 기준) ────────────────────

class Projects extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get color => text().nullable()(); // hex
  TextColumn get startDate => text().nullable()(); // ISO 8601
  TextColumn get endDate => text().nullable()(); // 완료 시
  TextColumn get status => text().withDefault(const Constant('active'))(); // 'active' | 'done'
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
}

class Photos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get projectId => integer().nullable().references(Projects, #id)();
  TextColumn get filePath => text()();
  TextColumn get thumbnailPath => text().nullable()();
  TextColumn get presetType => text()(); // 'construction' | 'secure'
  TextColumn get memo => text().nullable()();
  TextColumn get tags => text().nullable()(); // 쉼표 구분 태그 목록
  TextColumn get timestamp => text()(); // ISO 8601
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  TextColumn get address => text().nullable()();
  BoolColumn get isSecure => boolean().withDefault(const Constant(false))();
  BoolColumn get isVideo => boolean().withDefault(const Constant(false))();
  TextColumn get photoCode => text().nullable()(); // 고유 추적 코드 EX-YYYYMMDD-HHMMSS-XXXX
  TextColumn get weatherInfo => text().nullable()(); // 촬영 시 날씨 정보
  // ── 법적 증거 팩 (v10) ──
  TextColumn get photoHash => text().nullable()(); // 파일 바이트 SHA-256 (hex)
  TextColumn get prevHash => text().nullable()(); // 직전 사진의 chainHash — 체인 연결
  TextColumn get chainHash => text().nullable()(); // SHA-256(photoHash|prevHash|timestamp|lat|lng)
  BoolColumn get ntpSynced => boolean().withDefault(const Constant(false))(); // 촬영 시 NTP 동기화 상태
  TextColumn get createdAt => text()();
}

class StampConfigs extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get dateFormat => text().withDefault(const Constant('YYYY.MM.DD'))();
  TextColumn get fontFamily => text().withDefault(const Constant('mono'))();
  TextColumn get stampColor => text().withDefault(const Constant('#FFFFFF'))();
  TextColumn get stampPosition => text().withDefault(const Constant('bottom'))(); // 'bottom' | 'top'
  BoolColumn get showInNativeGallery => boolean().withDefault(const Constant(true))();
  TextColumn get resolution => text().withDefault(const Constant('4k'))(); // '1080p' | '4k'
  BoolColumn get shutterSound => boolean().withDefault(const Constant(false))();
  BoolColumn get batterySaver => boolean().withDefault(const Constant(false))();
  BoolColumn get exifStrip => boolean().withDefault(const Constant(true))();
  BoolColumn get secureShareLimit => boolean().withDefault(const Constant(true))();
  TextColumn get logoPath => text().nullable()();
  TextColumn get signaturePath => text().nullable()();
  TextColumn get themeMode => text().withDefault(const Constant('system'))(); // 'system' | 'light' | 'dark'
  TextColumn get locale => text().withDefault(const Constant('system'))(); // 'system' | 'ko' | 'en' | 'ja'
  TextColumn get stampLayout => text().withDefault(const Constant('text'))(); // 'bar' | 'card' | 'text'

  @override
  Set<Column> get primaryKey => {id};
}

// ── 데이터베이스 ─────────────────────────────────────────────

@DriftDatabase(tables: [Projects, Photos, StampConfigs])
class AppDatabase extends _$AppDatabase {
  AppDatabase._() : super(_openConnection());

  static AppDatabase? _instance;
  static AppDatabase get instance => _instance ??= AppDatabase._();

  @override
  int get schemaVersion => 11;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await into(stampConfigs).insert(
            StampConfigsCompanion.insert(),
          );
          // 검색 인덱스 (신규 설치 포함)
          await _createIndexes();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(photos, photos.tags);
          }
          if (from < 3) {
            await m.addColumn(stampConfigs, stampConfigs.logoPath);
            await m.addColumn(stampConfigs, stampConfigs.signaturePath);
          }
          if (from < 4) {
            await m.addColumn(stampConfigs, stampConfigs.themeMode);
            await m.addColumn(stampConfigs, stampConfigs.locale);
          }
          if (from < 5) {
            await m.addColumn(photos, photos.photoCode);
            await m.addColumn(photos, photos.weatherInfo);
          }
          if (from < 6) {
            // 기존 피치색(#FF9B7B) → 흰색(#FFFFFF) 디폴트 변경
            await customStatement(
              "UPDATE stamp_configs SET stamp_color = '#FFFFFF' WHERE stamp_color = '#FF9B7B'",
            );
          }
          if (from < 7) {
            // photoCode 유니크 인덱스 — 중복 방지, 고유 추적 설계 보장
            // 이미 NULL인 기존 레코드에 생성 값 부여
            await customStatement(
              "UPDATE photos SET photo_code = 'EX-LEGACY-' || id || '-' || substr(created_at, 1, 10) WHERE photo_code IS NULL OR photo_code = ''",
            );
            await customStatement(
              "CREATE UNIQUE INDEX IF NOT EXISTS idx_photos_photo_code ON photos(photo_code)",
            );
          }
          if (from < 8) {
            await _createIndexes();
          }
          if (from < 9) {
            await m.addColumn(stampConfigs, stampConfigs.stampLayout);
          }
          if (from < 10) {
            // 법적 증거 팩: photoHash/prevHash/chainHash/ntpSynced 컬럼 추가
            await m.addColumn(photos, photos.photoHash);
            await m.addColumn(photos, photos.prevHash);
            await m.addColumn(photos, photos.chainHash);
            await m.addColumn(photos, photos.ntpSynced);
          }
          if (from < 11) {
            // 기본 스탬프 레이아웃을 'text'로 변경
            // (카드/풀바 → 배경 없는 텍스트만 = Timemark 스타일)
            await customStatement(
              "UPDATE stamp_configs SET stamp_layout = 'text' WHERE stamp_layout = 'card' OR stamp_layout = 'bar'",
            );
          }
        },
      );

  /// 검색/필터 성능 인덱스 — migration v8 및 신규 설치에서 사용
  Future<void> _createIndexes() async {
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_photos_project_id ON photos(project_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_photos_timestamp ON photos(timestamp DESC)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_photos_is_secure ON photos(is_secure)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_projects_status ON projects(status)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_projects_created_at ON projects(created_at DESC)',
    );
  }

  // ── Project DAO ─────────────────────────────────────────────

  Future<List<Project>> getAllProjects() =>
      (select(projects)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();

  Stream<List<Project>> watchAllProjects() =>
      (select(projects)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();

  Future<List<Project>> getProjectsByStatus(String status) =>
      (select(projects)..where((t) => t.status.equals(status))).get();

  Stream<List<Project>> watchProjectsByStatus(String status) =>
      (select(projects)..where((t) => t.status.equals(status))).watch();

  Future<Project?> getProjectById(int id) =>
      (select(projects)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertProject(ProjectsCompanion entry) =>
      into(projects).insert(entry);

  Future<bool> updateProject(ProjectsCompanion entry) =>
      update(projects).replace(entry);

  Future<int> deleteProject(int id) async {
    // 관련 사진의 projectId를 null로 설정 (orphan 방지 - 사진 유지)
    await (update(photos)..where((t) => t.projectId.equals(id)))
        .write(const PhotosCompanion(projectId: Value(null)));
    return (delete(projects)..where((t) => t.id.equals(id))).go();
  }

  /// Cascade 삭제 — 프로젝트 + 연결된 사진 레코드 모두 삭제.
  /// 트랜잭션으로 원자성 보장 — 중단 시 부분 삭제 방지.
  /// 주의: 실제 파일 시스템의 사진 파일은 호출자(UI 레이어)가 사전에 삭제해야 함.
  Future<void> deleteProjectCascade(int projectId) async {
    await transaction(() async {
      await (delete(photos)..where((t) => t.projectId.equals(projectId))).go();
      await (delete(projects)..where((t) => t.id.equals(projectId))).go();
    });
  }

  /// 특정 프로젝트에 연결된 사진 수 — COUNT(*) 쿼리로 최적화
  Future<int> getPhotoCountByProject(int projectId) async {
    final countExp = photos.id.count();
    final query = selectOnly(photos)
      ..addColumns([countExp])
      ..where(photos.projectId.equals(projectId));
    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }

  /// 이름으로 프로젝트 조회 (중복 검사 용도, 대소문자 구분 안 함)
  Future<Project?> getProjectByName(String name, {int? excludeId}) async {
    final q = select(projects)..where((t) => t.name.lower().equals(name.toLowerCase()));
    if (excludeId != null) {
      q.where((t) => t.id.equals(excludeId).not());
    }
    return q.getSingleOrNull();
  }

  // ── Photo DAO ───────────────────────────────────────────────

  Future<List<Photo>> getAllPhotos() =>
      (select(photos)..orderBy([(t) => OrderingTerm.desc(t.timestamp)])).get();

  Stream<List<Photo>> watchAllPhotos() =>
      (select(photos)..orderBy([(t) => OrderingTerm.desc(t.timestamp)])).watch();

  Future<List<Photo>> getPhotosByProject(int projectId) =>
      (select(photos)
            ..where((t) => t.projectId.equals(projectId))
            ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
          .get();

  Stream<List<Photo>> watchPhotosByProject(int? projectId) {
    if (projectId == null) {
      return watchAllPhotos();
    }
    return (select(photos)
          ..where((t) => t.projectId.equals(projectId))
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
        .watch();
  }

  Future<Photo?> getPhotoById(int id) =>
      (select(photos)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// 메모/태그/주소/프로젝트명으로 사진 검색
  Future<List<Photo>> searchPhotos(String query) async {
    final q = '%$query%';
    // 1. 이름이 매칭되는 프로젝트 ID 수집
    final matchedProjects = await (select(projects)..where((t) => t.name.like(q))).get();
    final matchedProjectIds = matchedProjects.map((p) => p.id).toList();

    // 2. 사진 검색 — 메모/태그/주소 OR 매칭 프로젝트 소속
    return (select(photos)
          ..where((t) {
            var cond = t.memo.like(q) | t.tags.like(q) | t.address.like(q);
            if (matchedProjectIds.isNotEmpty) {
              cond = cond | t.projectId.isIn(matchedProjectIds);
            }
            return cond;
          })
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
        .get();
  }

  /// 프로젝트가 지정되지 않은 사진만 조회 (필터 "미지정" 용)
  Stream<List<Photo>> watchPhotosWithoutProject() {
    return (select(photos)
          ..where((t) => t.projectId.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
        .watch();
  }

  Future<int> insertPhoto(PhotosCompanion entry) =>
      into(photos).insert(entry);

  Future<bool> updatePhoto(PhotosCompanion entry) =>
      update(photos).replace(entry);

  Future<int> deletePhoto(int id) =>
      (delete(photos)..where((t) => t.id.equals(id))).go();

  /// 여러 사진을 ID 목록으로 한 번에 조회 (일괄 삭제 등 배치 작업용)
  Future<List<Photo>> getPhotosByIds(List<int> ids) {
    if (ids.isEmpty) return Future.value(const []);
    return (select(photos)..where((t) => t.id.isIn(ids))).get();
  }

  /// 여러 사진을 한 번의 SQL DELETE로 삭제 (N개 → 단일 쿼리)
  Future<int> deletePhotosByIds(List<int> ids) {
    if (ids.isEmpty) return Future.value(0);
    return (delete(photos)..where((t) => t.id.isIn(ids))).go();
  }

  // ── 통계 ────────────────────────────────────────────────────

  Future<int> getWeeklyPhotoCount() async {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final startStr = DateTime(weekStart.year, weekStart.month, weekStart.day)
        .toIso8601String();

    final countExp = photos.id.count();
    final query = selectOnly(photos)
      ..addColumns([countExp])
      ..where(photos.timestamp.isBiggerOrEqualValue(startStr));
    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }

  Future<int> getWeeklySecureCount() async {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final startStr = DateTime(weekStart.year, weekStart.month, weekStart.day)
        .toIso8601String();

    final countExp = photos.id.count();
    final query = selectOnly(photos)
      ..addColumns([countExp])
      ..where(photos.timestamp.isBiggerOrEqualValue(startStr) &
          photos.isSecure.equals(true));
    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }

  Future<int> getActiveProjectCount() async {
    final countExp = projects.id.count();
    final query = selectOnly(projects)
      ..addColumns([countExp])
      ..where(projects.status.equals(ProjectStatus.active.value));
    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }

  /// 사진 테이블 변경 감지용 가벼운 스트림 (count만)
  Stream<int> watchPhotoCount() {
    return (select(photos)).watch().map((list) => list.length);
  }

  /// 가장 최근 촬영 사진 1장
  Future<Photo?> getLatestPhoto() async {
    return (select(photos)
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// 증거 체인: 가장 최근 chainHash 반환 (없으면 null — 제네시스 블록)
  /// createdAt 기준 DESC 로 정렬하여 "가장 마지막으로 추가된 사진"의 체인 해시를 가져온다.
  /// timestamp 기반이 아니라 createdAt 기반인 이유: NTP 시간이 밀려있을 수 있지만
  /// 물리적 삽입 순서는 createdAt이 권위 있음.
  Future<String?> getLatestChainHash() async {
    final result = await (select(photos)
          ..where((t) => t.chainHash.isNotNull())
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(1))
        .getSingleOrNull();
    return result?.chainHash;
  }

  /// 증거 체인 전체 검증용: chainHash가 있는 모든 사진을 createdAt 순으로 조회
  Future<List<Photo>> getAllPhotosForChain() =>
      (select(photos)
            ..where((t) => t.chainHash.isNotNull())
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

  Stream<Photo?> watchLatestPhoto() {
    return (select(photos)
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
          ..limit(1))
        .watchSingleOrNull();
  }

  /// 오늘 촬영 통계
  Future<({int total, int secure, int projects})> getTodayStats() async {
    final now = DateTime.now();
    final todayStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final all = await (select(photos)
          ..where((t) => t.timestamp.isBiggerOrEqualValue('${todayStr}T00:00:00')))
        .get();
    final secureCount = all.where((p) => p.isSecure).length;
    final projectIds = all.map((p) => p.projectId).whereType<int>().toSet();
    return (total: all.length, secure: secureCount, projects: projectIds.length);
  }

  /// 특정 월의 일별 촬영 수 (캘린더용)
  Future<Map<int, int>> getDailyPhotoCounts(int year, int month) async {
    final monthStr = '$year-${month.toString().padLeft(2, '0')}';
    final all = await (select(photos)
          ..where((t) => t.timestamp.like('$monthStr%')))
        .get();

    final counts = <int, int>{};
    for (final photo in all) {
      final day = int.tryParse(photo.timestamp.substring(8, 10)) ?? 0;
      counts[day] = (counts[day] ?? 0) + 1;
    }
    return counts;
  }

  /// 프로젝트별 최근 사진 N장 (썸네일용)
  Future<List<Photo>> getProjectThumbnails(int projectId, {int limit = 3}) {
    return (select(photos)
          ..where((t) => t.projectId.equals(projectId) & t.isVideo.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
          ..limit(limit))
        .get();
  }

  /// 전체 사진/영상 수 + 파일 경로 목록 (저장 공간 계산용)
  Future<List<String>> getAllFilePaths() async {
    final all = await (select(photos)).get();
    return all.map((p) => p.filePath).toList();
  }

  // ── StampConfig DAO ─────────────────────────────────────────

  Future<StampConfig> getStampConfig() async {
    final result = await (select(stampConfigs)
          ..where((t) => t.id.equals(1)))
        .getSingleOrNull();
    if (result != null) return result;
    // 없으면 기본값 삽입 후 반환
    await into(stampConfigs).insert(StampConfigsCompanion.insert());
    return (select(stampConfigs)..where((t) => t.id.equals(1))).getSingle();
  }

  Stream<StampConfig> watchStampConfig() =>
      (select(stampConfigs)..where((t) => t.id.equals(1))).watchSingle();

  Future<bool> updateStampConfig(StampConfigsCompanion entry) =>
      update(stampConfigs).replace(entry);
}

// ── DB 연결 ────────────────────────────────────────────────────

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'exacta.db'));
    return NativeDatabase.createInBackground(file);
  });
}
