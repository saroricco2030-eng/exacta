/// BuildContext extensions - l10n, isDark, Exacta design token reactive colors
import 'package:flutter/material.dart';
import 'package:exacta/l10n/generated/app_localizations.dart';
import 'package:exacta/core/theme/app_colors.dart';

extension BuildContextExt on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  // ── Exacta 디자인 토큰 기반 테마 반응형 컬러 ──
  Color get bg => isDark ? AppColors.darkBg : AppColors.lightBg;
  Color get surface => isDark ? AppColors.darkSurface : AppColors.lightSurface;
  Color get surfaceHi => isDark ? AppColors.darkSurfaceHi : AppColors.lightSurfaceHi;
  Color get border => isDark ? AppColors.darkBorder : AppColors.lightBorder;
  Color get borderHi => isDark ? AppColors.darkBorderHi : AppColors.lightBorderHi;
  Color get accent => isDark ? AppColors.darkAccent : AppColors.lightAccent;
  Color get accentDim => isDark ? AppColors.darkAccentDim : AppColors.lightAccentDim;
  Color get accentGlow => isDark ? AppColors.darkAccentGlow : AppColors.lightAccentGlow;
  Color get onAccent => isDark ? AppColors.darkOnAccent : AppColors.lightOnAccent;
  Color get danger => isDark ? AppColors.darkDanger : AppColors.lightDanger;
  Color get warning => isDark ? AppColors.darkWarning : AppColors.lightWarning;
  Color get success => isDark ? AppColors.darkSuccess : AppColors.lightSuccess;
  Color get info => isDark ? AppColors.darkInfo : AppColors.lightInfo;
  Color get text1 => isDark ? AppColors.darkText1 : AppColors.lightText1;
  Color get text2 => isDark ? AppColors.darkText2 : AppColors.lightText2;
  Color get text3 => isDark ? AppColors.darkText3 : AppColors.lightText3;

  /// hex 문자열 → Color 변환 (프로젝트 컬러 등)
  Color parseHexColor(String? hex) {
    if (hex == null) return accent;
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (e) {
      return accent;
    }
  }

  // CTA 그라디언트 — Exacta 피치→로즈
  List<Color> get btnGradient => isDark
    ? [AppColors.darkAccent, const Color(0xFFE8907A)]
    : [AppColors.lightBtnGradientStart, AppColors.lightBtnGradientEnd];
}
