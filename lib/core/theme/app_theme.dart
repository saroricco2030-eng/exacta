/// ThemeData factory - Sora(UI) + JetBrains Mono(stamps/data)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBg,
    canvasColor: AppColors.darkBg,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    colorScheme: const ColorScheme.dark(
      primary:   AppColors.darkAccent,
      secondary: AppColors.darkInfo,
      surface:   AppColors.darkSurface,
      error:     AppColors.darkDanger,
      onPrimary: AppColors.darkOnAccent,
      onSurface: AppColors.darkText1,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBg,
      foregroundColor: AppColors.darkText1,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.darkBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: const Color(0xFF1C1C1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.darkBorder, width: 1),
      ),
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurfaceHi,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.darkAccent, width: 1.5),
      ),
      hintStyle: const TextStyle(color: AppColors.darkText3),
    ),
    textTheme: _buildTextTheme(AppColors.darkText1, AppColors.darkText2),
    iconTheme: const IconThemeData(color: AppColors.darkText2, size: 22),
    dividerColor: AppColors.darkBorder,
  );

  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBg,
    canvasColor: AppColors.lightBg,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    colorScheme: const ColorScheme.light(
      primary:   AppColors.lightAccent,
      secondary: AppColors.lightInfo,
      surface:   AppColors.lightSurface,
      error:     AppColors.lightDanger,
      onPrimary: AppColors.lightOnAccent,
      onSurface: AppColors.lightText1,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBg,
      foregroundColor: AppColors.lightText1,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.lightSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.lightBorder, width: 1),
      ),
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightSurfaceHi,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.lightBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.lightAccent, width: 1.5),
      ),
      hintStyle: const TextStyle(color: AppColors.lightText3),
    ),
    textTheme: _buildTextTheme(AppColors.lightText1, AppColors.lightText2),
    iconTheme: const IconThemeData(color: AppColors.lightText2, size: 22),
    dividerColor: AppColors.lightBorder,
  );

  static TextTheme _buildTextTheme(Color primary, Color secondary) {
    final sora = GoogleFonts.soraTextTheme();
    return sora.copyWith(
      headlineMedium: GoogleFonts.sora(
        fontSize: 22, fontWeight: FontWeight.w700,
        letterSpacing: -0.3, color: primary,
      ),
      titleMedium: GoogleFonts.sora(
        fontSize: 15, fontWeight: FontWeight.w600, color: primary,
      ),
      labelSmall: GoogleFonts.sora(
        fontSize: 11, fontWeight: FontWeight.w500,
        letterSpacing: 0.3, color: secondary,
      ),
      bodyMedium: GoogleFonts.sora(
        fontSize: 14, color: primary, height: 1.6,
      ),
      bodySmall: GoogleFonts.sora(
        fontSize: 10, fontWeight: FontWeight.w700,
        letterSpacing: 0.5, color: secondary,
      ),
    );
  }

  /// Mono 폰트 패밀리명 — 캐시하여 매 빌드 재생성 방지
  static final String monoFontFamily = GoogleFonts.jetBrainsMono().fontFamily ?? 'monospace';

  /// JetBrains Mono 스타일 (스탬프, 수치, 코드용)
  static TextStyle monoStyle({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.lightText1,
    double letterSpacing = 0,
    double height = 1.2,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }
}
