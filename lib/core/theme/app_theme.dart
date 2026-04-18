/// AppTheme — 폰트 패밀리 캐시 (ThemeData는 main.dart에서 직접 정의)
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  /// Mono 폰트 패밀리명 — 캐시하여 매 빌드 재생성 방지
  /// 스탬프, 수치, 증거 해시, 코드 표시용
  static final String monoFontFamily =
      GoogleFonts.jetBrainsMono().fontFamily ?? 'monospace';
}
