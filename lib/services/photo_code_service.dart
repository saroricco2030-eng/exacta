/// Unique photo tracking code generator (EX-YYYYMMDD-HHMMSS-XXXX)
import 'dart:math';

/// 각 사진에 부여되는 고유 추적 코드
class PhotoCodeService {
  static final _random = Random.secure();

  /// 형식: EX-YYYYMMDD-HHMMSS-XXXX (16자리)
  static String generate(DateTime timestamp) {
    final d = '${timestamp.year}'
        '${timestamp.month.toString().padLeft(2, '0')}'
        '${timestamp.day.toString().padLeft(2, '0')}';
    final t = '${timestamp.hour.toString().padLeft(2, '0')}'
        '${timestamp.minute.toString().padLeft(2, '0')}'
        '${timestamp.second.toString().padLeft(2, '0')}';
    final rand = _random.nextInt(9999).toString().padLeft(4, '0');
    return 'EX-$d-$t-$rand';
  }
}
