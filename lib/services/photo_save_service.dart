/// Photo save pipeline: capture -> NTP time -> photo code -> stamp burn -> save -> DB -> gallery
import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'package:exacta/core/enums.dart';
import 'package:exacta/data/database.dart';
import 'package:exacta/features/camera/camera_screen.dart';
import 'package:exacta/services/stamp_burn_service.dart';
import 'package:exacta/services/gallery_register_service.dart';
import 'package:exacta/services/photo_code_service.dart';
import 'package:exacta/services/ntp_service.dart';
import 'package:exacta/services/evidence_hash_service.dart';

class PhotoSaveService {
  final AppDatabase _db;
  final StampBurnService _stampService = StampBurnService();

  // 디렉토리 캐시 — 매 촬영마다 OS 호출 방지 (앱 라이프타임 고정 경로)
  static Directory? _cachedAppDir;

  PhotoSaveService(this._db);

  /// 저장된 파일 경로를 반환
  Future<String> savePhoto({
    required String tempFilePath,
    required CameraPreset preset,
    String? memo,
    String? tags,
    int? projectId,
    double? latitude,
    double? longitude,
    String? address,
    bool showTime = true,
    bool showDate = true,
    bool showAddress = true,
    bool showGps = true,
    bool showInNativeGallery = true,
    String dateFormat = 'YYYY.MM.DD',
    String stampColor = '#FFFFFF',
    String stampPosition = 'bottom',
    String stampLayout = 'text',
    String tamperBadgeText = '✓ Exacta · Tamper-Proof',
    String? logoPath,
    String? signaturePath,
    String? projectName,
    bool showCompass = false,
    bool showAltitude = false,
    bool showSpeed = false,
    double? compassHeading,
    double? altitude,
    double? speed,
    String? weatherText,
    List<String>? weekdayNames,
    // v12: 스탬프 커스터마이징 확장
    String stampSize = 'medium',
    double stampOpacity = 1.0,
    String stampBgColor = '#000000',
    String? customLine1,
    String? customLine2,
    // v13: 듀얼 저장 — 보안 모드는 강제 비활성
    bool saveOriginal = false,
    // v13: 스탬프 master toggle — false면 번인 스킵 (원본 그대로 저장)
    bool stampEnabled = true,
  }) async {
    final now = NtpService.now(); // NTP 보정 시간
    final isSecure = preset == CameraPreset.secure;
    final photoCode = PhotoCodeService.generate(now);
    // 보안 모드는 원본 저장 금지 (보안 무력화 방지)
    final shouldSaveOriginal = saveOriginal && !isSecure;
    // 보안 모드는 스탬프 토글 무시 — EXIF 제거 + 보안 배지 유지 목적으로 항상 번인
    final effectiveStampEnabled = stampEnabled || isSecure;

    // 1. 앱 내부 저장 디렉토리 (캐시 — 매번 OS 호출 방지)
    // create(recursive: true)는 idempotent — 존재 여부 체크 없이 호출 (TOCTOU 회피)
    _cachedAppDir ??= await getApplicationDocumentsDirectory();
    final photoDir = Directory(p.join(_cachedAppDir!.path, 'photos'));
    await photoDir.create(recursive: true);

    // 2. 파일명 생성
    final ds =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final ts =
        '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
    final ms = now.millisecond.toString().padLeft(3, '0');
    // 보안 모드: PNG (EXIF 없음), 일반 모드: JPEG (5~10배 빠른 인코딩)
    final ext = isSecure ? 'png' : 'jpg';
    final fileName = 'IMG_${ds}_${ts}_$ms.$ext';

    // 폴더 구조:
    //  - 보안: photos/secure/
    //  - 프로젝트 지정: photos/project_{id}/
    //  - 미지정: photos/
    final Directory targetDir;
    if (isSecure) {
      targetDir = Directory(p.join(photoDir.path, 'secure'));
    } else if (projectId != null) {
      targetDir = Directory(p.join(photoDir.path, 'project_$projectId'));
    } else {
      targetDir = photoDir;
    }
    await targetDir.create(recursive: true);

    final destPath = p.join(targetDir.path, fileName);

    // v13: 원본 복사 (보안 모드 제외) — photos/originals/IMG_...jpg
    String? originalDestPath;
    if (shouldSaveOriginal) {
      final originalsDir = Directory(p.join(photoDir.path, 'originals'));
      await originalsDir.create(recursive: true);
      // 원본은 항상 jpg (camera plugin이 jpg 출력)
      originalDestPath = p.join(originalsDir.path, 'IMG_${ds}_${ts}_$ms.jpg');
      try {
        await File(tempFilePath).copy(originalDestPath);
      } catch (e) {
        debugPrint('Original copy failed: $e');
        originalDestPath = null; // 실패 시 NULL로 처리, 스탬프 저장은 계속 진행
      }
    }

    // 3. 스탬프 번인 (effectiveStampEnabled=false면 원본 바이트 그대로 사용)
    final Uint8List burnedBytes;
    if (!effectiveStampEnabled) {
      burnedBytes = await File(tempFilePath).readAsBytes();
    } else {
      burnedBytes = await _stampService.burnStamp(
      imagePath: tempFilePath,
      timestamp: now,
      preset: preset,
      showTime: showTime,
      showDate: showDate,
      showAddress: showAddress && !isSecure,
      showGps: showGps && !isSecure,
      address: isSecure ? null : address,
      latitude: isSecure ? null : latitude,
      longitude: isSecure ? null : longitude,
      memo: memo,
      dateFormat: dateFormat,
      stampColorHex: stampColor,
      stampPosition: stampPosition,
      stampLayout: stampLayout,
      tamperBadgeText: tamperBadgeText,
      logoPath: logoPath,
      signaturePath: signaturePath,
      projectName: projectName,
      showCompass: showCompass,
      showAltitude: showAltitude,
      showSpeed: showSpeed,
      compassHeading: compassHeading,
      altitude: altitude,
      speed: speed,
      weatherText: weatherText,
      photoCode: photoCode,
      weekdayNames: weekdayNames ?? const ['월', '화', '수', '목', '금', '토', '일'],
      stampSize: stampSize,
      stampOpacity: stampOpacity,
      stampBgColor: stampBgColor,
      customLine1: customLine1,
      customLine2: customLine2,
    );
    }

    // 4. 파일 저장 + 해시 계산 병렬 실행 (I/O와 CPU를 동시에 활용)
    String? photoHash;
    String? prevHash;
    String? chainHash;

    final writeFileFuture = File(destPath).writeAsBytes(burnedBytes)
        .catchError((e) { throw Exception('Failed to write photo file: $e'); });

    // 해시 + 체인: 파일 쓰기와 병렬로 isolate에서 계산
    final hashFuture = Future(() async {
      try {
        final hash = await compute(_computeHashIsolate, burnedBytes);
        final prev = await _db.getLatestChainHash();
        final chain = EvidenceHashService.computeChainHash(
          photoHash: hash,
          prevHash: prev,
          timestampIso: now.toIso8601String(),
          latitude: isSecure ? null : latitude,
          longitude: isSecure ? null : longitude,
        );
        return (hash: hash, prev: prev, chain: chain);
      } catch (e) {
        debugPrint('Evidence hash failed: $e');
        return null;
      }
    });

    final results = await Future.wait([writeFileFuture, hashFuture]);
    final hashResult = results[1] as ({String hash, String? prev, String chain})?;
    if (hashResult != null) {
      photoHash = hashResult.hash;
      prevHash = hashResult.prev;
      chainHash = hashResult.chain;
    }

    // 5~7. 임시 파일 삭제 + DB 삽입 + 갤러리 등록 — 병렬 실행
    final dbFuture = _db.insertPhoto(
      PhotosCompanion.insert(
        filePath: destPath,
        presetType: isSecure ? StampPreset.secure.value : StampPreset.construction.value,
        memo: Value(memo?.isEmpty == true ? null : memo),
        tags: Value(tags?.isEmpty == true ? null : tags),
        timestamp: now.toIso8601String(),
        latitude: Value(isSecure ? null : latitude),
        longitude: Value(isSecure ? null : longitude),
        address: Value(isSecure ? null : address),
        isSecure: Value(isSecure),
        isVideo: const Value(false),
        photoCode: Value(photoCode),
        weatherInfo: Value(weatherText),
        projectId: Value(projectId),
        photoHash: Value(photoHash),
        prevHash: Value(prevHash),
        chainHash: Value(chainHash),
        ntpSynced: Value(NtpService.isSynced),
        originalPath: Value(originalDestPath),
        createdAt: now.toIso8601String(),
      ),
    ).catchError((e) {
      // C5: DB 삽입 실패 시 저장된 파일 정리 (고아 파일 방지)
      debugPrint('insertPhoto failed: $e');
      try {
        File(destPath).deleteSync();
      } catch (deleteErr) {
        debugPrint('Orphan file cleanup failed: $deleteErr');
      }
      throw Exception('Failed to insert photo into DB: $e');
    });

    // 임시 파일 삭제 — 실패해도 무시 (백그라운드)
    unawaited(File(tempFilePath).delete().catchError((e) {
      debugPrint('Temp file delete failed: $e');
      return File(tempFilePath);
    }));

    // M11: 갤러리 등록 실패 시 catch — DB 성공은 유지
    final galleryFuture = (!isSecure && showInNativeGallery)
        ? GalleryRegisterService.registerToGallery(destPath).catchError((e) {
            debugPrint('Gallery register failed: $e');
          })
        : Future<void>.value();

    await Future.wait([dbFuture, galleryFuture]);
    return destPath;
  }

  /// 기존 사진에 스탬프 재적용 — 현재 설정으로 덮어쓰기
  Future<void> restampPhoto({
    required Photo photo,
    required StampConfig config,
    required String tamperBadgeText,
    required List<String> weekdayNames,
  }) async {
    final isSecure = photo.isSecure;
    final preset = isSecure ? CameraPreset.secure : CameraPreset.construction;
    final ts = DateTime.tryParse(photo.timestamp) ?? DateTime.now();

    final burnedBytes = await _stampService.burnStamp(
      imagePath: photo.filePath,
      timestamp: ts,
      preset: preset,
      showTime: true,
      showDate: true,
      showAddress: !isSecure && photo.address != null,
      showGps: !isSecure && photo.latitude != null,
      address: photo.address,
      latitude: photo.latitude,
      longitude: photo.longitude,
      memo: photo.memo,
      dateFormat: config.dateFormat,
      stampColorHex: config.stampColor,
      stampPosition: config.stampPosition,
      stampLayout: config.stampLayout,
      tamperBadgeText: tamperBadgeText,
      logoPath: config.logoPath,
      signaturePath: config.signaturePath,
      stampSize: config.stampSize,
      stampOpacity: config.stampOpacity,
      stampBgColor: config.stampBgColor,
      customLine1: config.customLine1,
      customLine2: config.customLine2,
      weekdayNames: weekdayNames,
    );

    await File(photo.filePath).writeAsBytes(burnedBytes);

    // 해시 재계산
    try {
      final newHash = await compute(_computeHashIsolate, burnedBytes);
      await _db.updatePhoto(PhotosCompanion(
        id: Value(photo.id),
        filePath: Value(photo.filePath),
        photoHash: Value(newHash),
      ));
    } catch (e) {
      debugPrint('Restamp hash update failed: $e');
    }
  }

  /// 영상 저장 — 앱 내부 디렉토리로 복사 + DB 삽입
  Future<int> saveVideo({
    required String tempFilePath,
    required CameraPreset preset,
    String? memo,
    String? tags,
    int? projectId,
    double? latitude,
    double? longitude,
    String? address,
  }) async {
    final now = NtpService.now(); // NTP 보정 시간 (증거성)
    final isSecure = preset == CameraPreset.secure;

    final appDir = await getApplicationDocumentsDirectory();
    final videoDir = Directory(p.join(appDir.path, 'videos'));
    await videoDir.create(recursive: true);

    final ds =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final ts =
        '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
    final ms = now.millisecond.toString().padLeft(3, '0');
    final fileName = 'VID_${ds}_${ts}_$ms.mp4';

    // 영상도 동일 폴더 규칙 적용
    final Directory targetDir;
    if (isSecure) {
      targetDir = Directory(p.join(videoDir.path, 'secure'));
    } else if (projectId != null) {
      targetDir = Directory(p.join(videoDir.path, 'project_$projectId'));
    } else {
      targetDir = videoDir;
    }
    await targetDir.create(recursive: true);

    final destPath = p.join(targetDir.path, fileName);

    // 복사 — 실패 시 예외 전파
    final tempFile = File(tempFilePath);
    try {
      await tempFile.copy(destPath);
      if (await tempFile.exists()) {
        await tempFile.delete();
      }
    } catch (e) {
      throw Exception('Failed to copy video file: $e');
    }

    // 증거 해시 계산 (영상도 체인에 포함)
    String? photoHash;
    String? prevHash;
    String? chainHash;
    try {
      photoHash = await EvidenceHashService.computeFileHash(destPath);
      prevHash = await _db.getLatestChainHash();
      chainHash = EvidenceHashService.computeChainHash(
        photoHash: photoHash,
        prevHash: prevHash,
        timestampIso: now.toIso8601String(),
        latitude: isSecure ? null : latitude,
        longitude: isSecure ? null : longitude,
      );
    } catch (e) {
      debugPrint('Evidence hash (video) failed: $e');
    }

    // DB 삽입 — 실패 시 저장된 파일 정리
    try {
      final id = await _db.insertPhoto(
        PhotosCompanion.insert(
          filePath: destPath,
          presetType: isSecure ? StampPreset.secure.value : StampPreset.construction.value,
          memo: Value(memo?.isEmpty == true ? null : memo),
          tags: Value(tags?.isEmpty == true ? null : tags),
          timestamp: now.toIso8601String(),
          latitude: Value(isSecure ? null : latitude),
          longitude: Value(isSecure ? null : longitude),
          address: Value(isSecure ? null : address),
          isSecure: Value(isSecure),
          isVideo: const Value(true),
          projectId: Value(projectId),
          photoHash: Value(photoHash),
          prevHash: Value(prevHash),
          chainHash: Value(chainHash),
          ntpSynced: Value(NtpService.isSynced),
          createdAt: now.toIso8601String(),
        ),
      );
      return id;
    } catch (e) {
      debugPrint('insertPhoto (video) failed: $e');
      try {
        File(destPath).deleteSync();
      } catch (e) { debugPrint('Cleanup of orphaned video file failed ($destPath): $e'); }
      throw Exception('Failed to insert video into DB: $e');
    }
  }
}

/// SHA-256 해시를 별도 isolate에서 계산 (메인 스레드 블로킹 방지)
String _computeHashIsolate(List<int> bytes) {
  return EvidenceHashService.computeBytesHash(bytes);
}
