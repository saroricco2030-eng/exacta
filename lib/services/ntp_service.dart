/// NTP network time sync for tamper-proof timestamps
import 'package:flutter/foundation.dart';
import 'package:ntp/ntp.dart';

/// 네트워크 시간 동기화 — 위변조 방지
class NtpService {
  static Duration _offset = Duration.zero;
  static bool _synced = false;

  /// NTP 서버와 시간 동기화 (앱 시작 시 1회)
  static Future<void> sync() async {
    try {
      final offsetMs = await NTP.getNtpOffset().timeout(const Duration(seconds: 5));
      _offset = Duration(milliseconds: offsetMs);
      _synced = true;
    } catch (e) {
      _offset = Duration.zero;
      _synced = false;
      debugPrint('NTP sync failed: $e');
    }
  }

  /// NTP 보정된 현재 시간 반환
  static DateTime now() => DateTime.now().add(_offset);

  /// NTP 동기화 완료 여부
  static bool get isSynced => _synced;
}
