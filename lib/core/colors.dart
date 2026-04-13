/// 페이지 전용 솔리드 컬러 — const 위젯 최적화용
/// ★ 디자인 토큰 원본: core/theme/app_colors.dart
/// ★ 동적 테마 반응: core/extensions/build_context_ext.dart
import 'package:flutter/material.dart';

class DarkModeColors {
  DarkModeColors._();

  static const Color background = Color(0xFF0D1118);
  static const Color surface1 = Color(0xFF151B24);
  static const Color surface2 = Color(0xFF1C2430);
  static const Color surface3 = Color(0xFF252D3A);
  static const Color accent = Color(0xFFFFB49A);
  static const Color accentDim = Color(0x1FFFB49A);
  static const Color text1 = Color(0xFFF5F5F7);
  static const Color text2 = Color(0xCCEBEBF5);
  static const Color text3 = Color(0x61EBEBF5);
  static const Color glassBorder = Color(0x1AFFFFFF);
  static const Color glass = Color(0x12FFFFFF);
  static const Color miniPlayerBg = Color(0xFF151B24);

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

// ── Exacta Light 홈 페이지 전용 (const 최적화용 솔리드 컬러) ──
class LightPageColors {
  LightPageColors._();

  static const Color primary = Color(0xFFFF9B7B);
  static const Color primaryLight = Color(0xFFFFF0E6);
  static const Color bg = Color(0xFFFFF8F2);
  static const Color bg2 = Color(0xFFFFF0E6);
  static const Color bg3 = Color(0xFFE8DCD0);
  static const Color border = Color(0xFFE8D8CC);
  static const Color text1 = Color(0xFF3D2E22);
  static const Color text2 = Color(0xFF9E8E80);
  static const Color text3 = Color(0xFFC5BBB4);
}
