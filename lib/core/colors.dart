/// Static theme color tokens — ThemeData 정의 및 화면별 직접 참조용
/// Airbnb Light Mode (라이트) + Apple Music Dark Mode (다크)
/// 동적 context 기반 참조는 build_context_ext.dart 확장 사용 권장
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color background = Color(0xFF000000);
  static const Color surface1 = Color(0xFF0F0F0F);
  static const Color surface2 = Color(0xFF1C1C1E);
  static const Color surface3 = Color(0xFF2C2C2E);
  static const Color accent = Color(0xFFFA2D48);
  static const Color accentDim = Color(0x26FA2D48);
  static const Color text1 = Color(0xFFF5F5F7);
  static const Color text2 = Color(0xCCEBEBF5);
  static const Color text3 = Color(0x61EBEBF5);
  static const Color glassBorder = Color(0x1AFFFFFF);
  static const Color glass = Color(0x12FFFFFF);
  static const Color miniPlayerBg = Color(0xFF1E1E1E);

  static const List<LinearGradient> albumGradients = [
    LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFF0F0C29), Color(0xFF302B63), Color(0xFF24243E)],
    ),
    LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460), Color(0xFFE94560)],
    ),
    LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFF2D1B69), Color(0xFF11998E), Color(0xFF38EF7D)],
    ),
    LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFFFC4A1A), Color(0xFFF7B733)],
    ),
    LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
    ),
    LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
    ),
    LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFFF7971E), Color(0xFFFFD200)],
    ),
    LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
    ),
    LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFFC94B4B), Color(0xFF4B134F)],
    ),
    LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFFF953C6), Color(0xFFB91D73)],
    ),
    LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFF1F4037), Color(0xFF99F2C8)],
    ),
    LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFF373B44), Color(0xFF4286F4)],
    ),
    LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFFD53369), Color(0xFFCBAD6D)],
    ),
    LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFF00B09B), Color(0xFF96C93D)],
    ),
    LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFFFF5F6D), Color(0xFFFFC371)],
    ),
    LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFF3A1C71), Color(0xFFD76D77), Color(0xFFFFAF7B)],
    ),
    LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFF005C97), Color(0xFF363795)],
    ),
    LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFF2B5876), Color(0xFF4E4376)],
    ),
    LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFFDE6161), Color(0xFF2657EB)],
    ),
    LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFFA8C0FF), Color(0xFF3F2B96)],
    ),
  ];
}

// ── Airbnb Light Theme Colors ──
class AirbnbColors {
  AirbnbColors._();

  static const Color primary = Color(0xFFFF385C);
  static const Color primaryLight = Color(0xFFFFE6EA);
  static const Color bg = Color(0xFFFFFFFF);
  static const Color bg2 = Color(0xFFF7F7F7);
  static const Color bg3 = Color(0xFFEBEBEB);
  static const Color border = Color(0xFFDDDDDD);
  static const Color text1 = Color(0xFF222222);
  static const Color text2 = Color(0xFF717171);
  static const Color text3 = Color(0xFFB0B0B0);

  static const List<LinearGradient> placeholders = [
    LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFFE8D5B7), Color(0xFFA0522D)]),
    LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFFB7D5E8), Color(0xFF2A6496)]),
    LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFFD5E8B7), Color(0xFF3A7A3A)]),
    LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFFE8B7D5), Color(0xFFA02A6A)]),
    LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFFF5DEB3), Color(0xFFC8A44A)]),
    LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFFB7C5E8), Color(0xFF2A3A8C)]),
    LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFFE8C8B7), Color(0xFF8C4A2A)]),
    LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFFC8E8B7), Color(0xFF2A8C3A)]),
    LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFFE8E0B7), Color(0xFF8C7A2A)]),
    LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFFD4B7E8), Color(0xFF6A2A8C)]),
    LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFFB7E8E4), Color(0xFF2A7A76)]),
    LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFFE8B7B7), Color(0xFF8C2A2A)]),
  ];
}
