/// Riverpod providers - DB streams + auto-refreshing stats
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exacta/core/enums.dart';
import 'package:exacta/data/database.dart';

/// 앱 전역 DB 인스턴스
final dbProvider = Provider<AppDatabase>((ref) => AppDatabase.instance);

/// ── 프로젝트 ──────────────────────────────────────────────────
final allProjectsProvider = StreamProvider<List<Project>>((ref) {
  return ref.watch(dbProvider).watchAllProjects();
});

final activeProjectsProvider = StreamProvider<List<Project>>((ref) {
  return ref.watch(dbProvider).watchProjectsByStatus(ProjectStatus.active.value);
});

/// ── 사진 ──────────────────────────────────────────────────────
/// projectId: null = 전체, -1 = 미지정(프로젝트 없음), 그 외 = 특정 프로젝트
final photosByProjectProvider =
    StreamProvider.family<List<Photo>, int?>((ref, projectId) {
  final db = ref.watch(dbProvider);
  if (projectId == -1) {
    return db.watchPhotosWithoutProject();
  }
  return db.watchPhotosByProject(projectId);
});

/// ── 설정 ──────────────────────────────────────────────────────
final stampConfigProvider = StreamProvider<StampConfig>((ref) {
  return ref.watch(dbProvider).watchStampConfig();
});

/// ── 홈 통계 — 사진 변경 시 자동 갱신 (단일 트랜잭션 통합 쿼리) ──
final weeklyStatsProvider = StreamProvider<HomeStats>((ref) {
  final db = ref.watch(dbProvider);
  return db.watchPhotoCount().asyncMap((_) async {
    final stats = await db.getWeeklyStatsAll();
    return HomeStats(
      weeklyPhotos: stats.weekly,
      securePhotos: stats.secure,
      activeProjects: stats.activeProjects,
    );
  });
});

class HomeStats {
  final int weeklyPhotos;
  final int securePhotos;
  final int activeProjects;

  const HomeStats({
    required this.weeklyPhotos,
    required this.securePhotos,
    required this.activeProjects,
  });
}

/// 마지막 촬영 사진 — 홈 히어로 카드
final latestPhotoProvider = StreamProvider<Photo?>((ref) {
  return ref.watch(dbProvider).watchLatestPhoto();
});
