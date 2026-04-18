/// Shared date formatter for stamp overlay (preview) and burn service (final image).
/// Single source of truth — 두 곳에서 동일한 결과를 보장.
class StampDateFormatter {
  StampDateFormatter._();

  /// 지원하는 모든 날짜 포맷 키 목록 (설정 드롭다운용)
  static const List<String> allFormats = [
    // ── ISO / 국제 ──
    'YYYY.MM.DD',
    'YYYY-MM-DD',
    'YYYY/MM/DD',
    // ── 미국식 ──
    'MM/DD/YYYY',
    'MM-DD-YYYY',
    'MM.DD.YYYY',
    // ── 유럽식 ──
    'DD/MM/YYYY',
    'DD-MM-YYYY',
    'DD.MM.YYYY',
    // ── 영문 약어 ──
    'MMM DD, YYYY',
    'DD MMM YYYY',
    'YYYY MMM DD',
    // ── 아시아 ──
    'YYYY년 MM월 DD일',
    'MM月DD日YYYY年',
    // ── 축약형 ──
    'DD/MM/YY',
    'MM/DD/YY',
    'YY.MM.DD',
    // ── 숫자 연속 ──
    'YYYYMMDD',
    'DDMMYYYY',
    // ── 기술용 ──
    'UNIX',
  ];

  static const _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  /// 날짜를 지정 포맷으로 변환
  static String format(DateTime ts, String fmt) {
    final y = ts.year.toString();
    final yy = y.length >= 2 ? y.substring(y.length - 2) : y;
    final mo = ts.month.toString().padLeft(2, '0');
    final d = ts.day.toString().padLeft(2, '0');
    final mmm = _monthNames[ts.month - 1];

    return switch (fmt) {
      'YYYY.MM.DD'       => '$y.$mo.$d',
      'YYYY-MM-DD'       => '$y-$mo-$d',
      'YYYY/MM/DD'       => '$y/$mo/$d',
      'MM/DD/YYYY'       => '$mo/$d/$y',
      'MM-DD-YYYY'       => '$mo-$d-$y',
      'MM.DD.YYYY'       => '$mo.$d.$y',
      'DD/MM/YYYY'       => '$d/$mo/$y',
      'DD-MM-YYYY'       => '$d-$mo-$y',
      'DD.MM.YYYY'       => '$d.$mo.$y',
      'MMM DD, YYYY'     => '$mmm $d, $y',
      'DD MMM YYYY'      => '$d $mmm $y',
      'YYYY MMM DD'      => '$y $mmm $d',
      'YYYY년 MM월 DD일'  => '${y}년 ${mo}월 ${d}일',
      'MM月DD日YYYY年'    => '${mo}月${d}日${y}年',
      'DD/MM/YY'         => '$d/$mo/$yy',
      'MM/DD/YY'         => '$mo/$d/$yy',
      'YY.MM.DD'         => '$yy.$mo.$d',
      'YYYYMMDD'         => '$y$mo$d',
      'DDMMYYYY'         => '$d$mo$y',
      'UNIX'             => '${ts.millisecondsSinceEpoch ~/ 1000}',
      _                  => '$y.$mo.$d',
    };
  }

  /// 예시 날짜로 포맷 미리보기 — 정적 캐시 (매 빌드 22회 호출 방지)
  static final Map<String, String> previewCache = {
    for (final f in allFormats) f: format(DateTime(2026, 4, 13, 14, 30), f),
  };

  static String preview(String fmt) => previewCache[fmt] ?? fmt;
}
