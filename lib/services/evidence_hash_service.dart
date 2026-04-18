/// Evidence hash service — SHA-256 file hashing + chain-of-custody hash chain.
///
/// 설계 원칙:
/// - 파일 해시: 실제 디스크의 번인된 이미지 바이트에 대한 SHA-256.
/// - 체인 해시: 파일 해시 + 직전 사진의 chainHash + 타임스탬프 + GPS를
///   하나의 canonical 문자열로 합친 뒤 SHA-256.
/// - 체인 특성: 사진 1장을 조작하면 photoHash가 달라지고, 그 결과로
///   chainHash가 달라지며, 이후 모든 사진의 prevHash가 맞지 않게 되어
///   전체 체인이 깨진다 (변조 탐지).
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

import 'package:exacta/core/safe_parse.dart';

class EvidenceHashService {
  EvidenceHashService._();

  /// 파일의 SHA-256 해시를 hex 문자열로 반환.
  /// 큰 파일(4K 사진 ~10MB)도 스트리밍 처리로 메모리 사용량 최소.
  static Future<String> computeFileHash(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw FileSystemException('File not found for hashing', filePath);
    }
    final digest = await file.openRead().transform(sha256).single;
    return digest.toString(); // 64 hex chars
  }

  /// 파일 해시를 바이트 배열 입력으로도 계산 (이미 메모리에 있을 때)
  static String computeBytesHash(List<int> bytes) {
    return sha256.convert(bytes).toString();
  }

  /// 체인 해시 계산 — canonical 직렬화 순서는 절대 바꾸지 말 것
  /// (형식이 바뀌면 기존 사진의 체인이 모두 깨진다)
  ///
  /// Format: "{photoHash}|{prevHash or 'GENESIS'}|{timestampIso}|{lat}|{lng}"
  static String computeChainHash({
    required String photoHash,
    required String? prevHash,
    required String timestampIso,
    required double? latitude,
    required double? longitude,
  }) {
    final prev = prevHash ?? 'GENESIS';
    final lat = latitude?.toStringAsFixed(7) ?? 'NULL';
    final lng = longitude?.toStringAsFixed(7) ?? 'NULL';
    final canonical = '$photoHash|$prev|$timestampIso|$lat|$lng';
    final digest = sha256.convert(utf8.encode(canonical));
    return digest.toString();
  }

  /// 파일 무결성 검증 — 파일을 재해싱하여 저장된 해시와 비교.
  ///
  /// Returns:
  /// - true: 파일이 변조되지 않음
  /// - false: 파일 해시 불일치 (변조 또는 손상)
  static Future<bool> verifyFile({
    required String filePath,
    required String expectedHash,
  }) async {
    try {
      final actualHash = await computeFileHash(filePath);
      return actualHash == expectedHash;
    } catch (_) {
      return false;
    }
  }

  /// 짧은 해시 미리보기 (UI 표시용)
  /// 예: "3f4a9b...2e8c"
  static String shortPreview(String fullHash) {
    if (fullHash.length < 12) return fullHash;
    final head = SafeParse.substringOr(fullHash, 0, 6);
    final tail = SafeParse.substringOr(fullHash, fullHash.length - 4, null);
    return '$head...$tail';
  }
}
