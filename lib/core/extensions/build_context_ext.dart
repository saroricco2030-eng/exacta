/// BuildContext extensions - l10n, isDark, theme-reactive colors
import 'package:flutter/material.dart';
import 'package:exacta/l10n/generated/app_localizations.dart';
import 'package:exacta/core/theme/app_colors.dart';

extension BuildContextExt on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  // ── 테마 반응형 컬�� ──
  // Light: Airbnb 화이트 + 레드 계열
  // Dark:  Apple Music 블랙 + 레드 계열
  Color get bg => isDark ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
  Color get surface => isDark ? const Color(0xFF1C1C1E) : const Color(0xFFFFFFFF);
  Color get surfaceHi => isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF7F7F7);
  Color get border => isDark ? const Color(0x1AFFFFFF) : const Color(0xFFDDDDDD);
  Color get borderHi => isDark ? const Color(0x26FFFFFF) : const Color(0xFFEBEBEB);
  Color get accent => isDark ? const Color(0xFFFA2D48) : const Color(0xFFFF385C);
  Color get accentDim => isDark ? const Color(0x26FA2D48) : const Color(0x1AFF385C);
  Color get accentGlow => isDark ? const Color(0x4DFA2D48) : const Color(0x4DFF385C);
  Color get onAccent => isDark ? const Color(0xFFFFFFFF) : const Color(0xFFFFFFFF);
  Color get danger => isDark ? AppColors.darkDanger : AppColors.lightDanger;
  Color get warning => isDark ? AppColors.darkWarning : AppColors.lightWarning;
  Color get success => isDark ? AppColors.darkSuccess : AppColors.lightSuccess;
  Color get info => isDark ? AppColors.darkInfo : AppColors.lightInfo;
  Color get text1 => isDark ? const Color(0xFFF5F5F7) : const Color(0xFF222222);
  Color get text2 => isDark ? const Color(0x99EBEBF5) : const Color(0xFF717171);
  Color get text3 => isDark ? const Color(0x4DEBEBF5) : const Color(0xFFB0B0B0);

  /// hex 문자열 → Color 변환 (프로젝트 컬러 등)
  Color parseHexColor(String? hex) {
    if (hex == null) return accent;
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (e) {
      return accent;
    }
  }

  // CTA 그라디언트
  List<Color> get btnGradient => isDark
    ? [const Color(0xFFFA2D48), const Color(0xFFE31C5F)]
    : [const Color(0xFFFF385C), const Color(0xFFE31C5F)];
}
