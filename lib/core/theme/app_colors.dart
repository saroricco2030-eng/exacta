/// Exacta design tokens from CLAUDE.md - Dark(camera) + Light(UI)
// lib/core/theme/app_colors.dart
// ★ 색상 값은 CLAUDE.md "디자인 시스템" 섹션의 토큰을 그대로 사용
// ★ 프로젝트: Exacta — 현장 카메라 앱
// ★ 스타일: 라이트 파스텔 (Peach + Cream) / 카메라는 다크

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Dark Mode (카메라 뷰파인더 + Phase 3 전체 다크) ─────────
  static const darkBg          = Color(0xFF0D1118); // --bg
  static const darkSurface     = Color(0x0FFFFFFF); // --surface rgba(white, 0.06)
  static const darkSurfaceHi   = Color(0x1AFFFFFF); // --surface-hi rgba(white, 0.10)
  static const darkBorder      = Color(0x14FFFFFF); // --border rgba(white, 0.08)
  static const darkBorderHi    = Color(0x26FFFFFF); // --border-hi rgba(white, 0.15)

  static const darkAccent      = Color(0xFFFFB49A); // --accent (라이트 피치)
  static const darkAccentDim   = Color(0x1FFFB49A); // --accent-dim rgba(255,180,154, 0.12)
  static const darkAccentGlow  = Color(0x4DFFB49A); // --accent-glow rgba(255,180,154, 0.30)
  static const darkOnAccent    = Color(0xFF0D1118); // --on-accent (다크 배경색)

  static const darkDanger      = Color(0xFFEF5350); // --danger
  static const darkWarning     = Color(0xFFFBBF24); // --warning
  static const darkSuccess     = Color(0xFF34D399); // --success
  static const darkInfo        = Color(0xFFB8A0E8); // --info (라벤더)

  static const darkText1       = Color(0xEBFFFFFF); // --text-primary rgba(white, 0.92)
  static const darkText2       = Color(0x73FFFFFF); // --text-secondary rgba(white, 0.45)
  static const darkText3       = Color(0x33FFFFFF); // --text-muted rgba(white, 0.20)

  // ── Light Mode (앱 메인 UI) ─────────────────────────────────
  static const lightBg         = Color(0xFFFFF8F2); // --bg (웜 크림)
  static const lightSurface    = Color(0xFFFFFFFF); // --surface
  static const lightSurfaceHi  = Color(0xFFFFF0E6); // --surface-hi (피치 틴트)
  static const lightBorder     = Color(0x14FF9B7B); // --border rgba(255,155,123, 0.08)
  static const lightBorderHi   = Color(0xE6FFFFFF); // --border-hi rgba(white, 0.90)

  static const lightAccent     = Color(0xFFFF9B7B); // --accent (피치)
  static const lightAccentDark = Color(0xFFD4715A); // --accent-dark (텍스트용)
  static const lightAccentDim  = Color(0x1FFF9B7B); // --accent-dim rgba(255,155,123, 0.12)
  static const lightAccentGlow = Color(0x4DFF9B7B); // --accent-glow rgba(255,155,123, 0.30)
  static const lightOnAccent   = Color(0xFFFFFFFF); // --on-accent (화이트)

  static const lightDanger     = Color(0xFFDC2626); // --danger
  static const lightWarning    = Color(0xFFF59E0B); // --warning
  static const lightSuccess    = Color(0xFF059669); // --success
  static const lightInfo       = Color(0xFFB8A0E8); // --info (라벤더)

  static const lightText1      = Color(0xFF3D2E22); // --text-primary (웜 다크 브라운)
  static const lightText2      = Color(0x803D2E22); // --text-secondary rgba(61,46,34, 0.50)
  static const lightText3      = Color(0x4D3D2E22); // --text-muted rgba(61,46,34, 0.30)

  // ── Exacta 전용 토큰 ───────────────────────────────────────
  static const stampConstruction = Color(0xFFFFB49A); // 시공기록 스탬프
  static const stampSecure       = Color(0xFFFCA5A5); // 보안촬영 스탬프
  static const secureBg          = Color(0xFF2A1520); // 보안모드 뷰파인더 틴트
  static const lavender          = Color(0xFFB8A0E8); // 보조 카테고리
  static const mint              = Color(0xFF7ECBB4); // 성공/오버레이 보조
  static const sand              = Color(0xFFF0C078); // 경고/포인트 보조

  // ── CTA 버튼 그라디언트 (Light) ─────────────────────────────
  static const lightBtnGradientStart = Color(0xFFFF9B7B); // 피치
  static const lightBtnGradientEnd   = Color(0xFFE880A0); // 로즈

  // ── 뷰파인더 스탬프 배경 ────────────────────────────────────
  static const stampBg = Color(0xB3000000); // rgba(0,0,0,0.70)

  // 스탬프 메모 amber 색상
  static const stampMemo = Color(0x80FFC88C); // rgba(255,200,140, 0.50)
  static const stampMemoIcon = Color(0x73FFC88C); // rgba(255,200,140, 0.45)

  // ── 그라디언트/오버레이 공통 ────────────────────────────────
  static const gradientBlack80 = Color(0xCC000000); // 카메라/상세화면 그라디언트
  static const amoledBlack = Color(0xF0000000);      // 배터리 세이버 AMOLED
  static const transparent = Color(0x00000000);       // 서명 패드 투명 배경
}
