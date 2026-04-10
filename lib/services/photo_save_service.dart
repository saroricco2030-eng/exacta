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
  }) async {
    final now = NtpService.now(); // NTP 보정 시간
    final isSecure = preset == CameraPreset.secure;
    final photoCode = PhotoCodeService.generate(now);

    // 1. 앱 내부 저장 디렉토리 생성
    final appDir = await getApplicationDocumentsDirectory();
    final photoDir = Directory(p.join(appDir.path, 'photos'));
    if (!await photoDir.exists()) {
      await photoDir.create(recursive: true);
    }

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
    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }

    final destPath = p.join(targetDir.path, fileName);

    // 3. 스탬프 번인
    final burnedBytes = await _stampService.burnStamp(
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
    );

    // 4. 번인된 이미지 저장 — 실패 시 명시적 throw
    try {
      await File(destPath).writeAsBytes(burnedBytes);
    } catch (e) {
      // C5: writeAsBytes 실패 시 명시적 예외 전파
      throw Exception('Failed to write photo file: $e');
    }

    // 4.5. 증거 해시 계산 (체인 오브 커스터디)
    //   - photoHash: 번인된 파일 바이트의 SHA-256
    //   - prevHash: DB에 이미 있는 가장 최근 chainHash
    //   - chainHash: SHA-256(photoHash|prevHash|timestamp|lat|lng)
    //   실패 시 null로 저장하고 진행 — 저장 자체는 실패시키지 않음.
    String? photoHash;
    String? prevHash;
    String? chainHash;
    try {
      photoHash = EvidenceHashService.computeBytesHash(burnedBytes);
      prevHash = await _db.getLatestChainHash();
      chainHash = EvidenceHashService.computeChainHash(
        photoHash: photoHash,
        prevHash: prevHash,
        timestampIso: now.toIso8601String(),
        latitude: isSecure ? null : latitude,
        longitude: isSecure ? null : longitude,
      );
    } catch (e) {
      debugPrint('Evidence hash failed: $e');
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
        createdAt: now.toIso8601String(),
      ),
    ).catchError((e) {
      // C5: DB 삽입 실패 시 저장된 파일 정리 (고아 파일 방지)
      debugPrint('insertPhoto failed: $e');
      try {
        File(destPath).deleteSync();
      } catch (_) {}
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
    if (!await videoDir.exists()) {
      await videoDir.create(recursive: true);
    }

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
    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }

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
      } catch (_) {}
      throw Exception('Failed to insert video into DB: $e');
    }
  }
}
