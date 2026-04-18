/// 신규 유저용 웰컴 히어로 — 라이트/다크 홈 공통 위젯
/// 첫 촬영을 유도하고 앱의 본질(시간·위치·증거)을 한눈에 전달
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:exacta/core/colors.dart';
import 'package:exacta/core/extensions/build_context_ext.dart';
import 'package:exacta/core/transitions.dart';
import 'package:exacta/features/camera/camera_screen.dart';

class WelcomeHero extends StatelessWidget {
  const WelcomeHero({super.key, required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;

    // 라이트: 피치 그라디언트 배경 + 흰 배지/CTA
    // 다크: 반투명 액센트 배경 + 액센트 테두리/CTA
    final iconBg = isDark
        ? DarkModeColors.accent.withValues(alpha: 0.15)
        : Colors.white.withValues(alpha: 0.22);
    final iconBorder = isDark
        ? DarkModeColors.accent.withValues(alpha: 0.3)
        : null;
    final iconColor = isDark ? DarkModeColors.accent : Colors.white;
    final titleColor = isDark ? DarkModeColors.text1 : Colors.white;
    final subtitleColor = isDark
        ? DarkModeColors.text2
        : Colors.white.withValues(alpha: 0.88);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: isDark
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  DarkModeColors.accent.withValues(alpha: 0.18),
                  DarkModeColors.accent.withValues(alpha: 0.06),
                ],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFF9B7B), Color(0xFFE880A0)],
              ),
        border: isDark
            ? Border.all(color: DarkModeColors.accent.withValues(alpha: 0.2))
            : null,
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: const Color(0xFFFF9B7B).withValues(alpha: 0.3),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(16),
              border: iconBorder != null ? Border.all(color: iconBorder) : null,
            ),
            child: Icon(LucideIcons.camera, size: 28, color: iconColor),
          ),
          const SizedBox(height: 20),
          Text(
            l.homeWelcomeTitle,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: titleColor,
              letterSpacing: -0.3,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l.homeWelcomeSubtitle,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: subtitleColor,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _ValueBadge(icon: LucideIcons.clock, label: l.homeWelcomeBadgeTime, isDark: isDark),
              _ValueBadge(icon: LucideIcons.mapPin, label: l.homeWelcomeBadgeGps, isDark: isDark),
              _ValueBadge(icon: LucideIcons.shieldCheck, label: l.homeWelcomeBadgeTamper, isDark: isDark),
            ],
          ),
          const SizedBox(height: 24),
          _CtaButton(isDark: isDark, label: l.homeWelcomeStartButton),
        ],
      ),
    );
  }
}

class _ValueBadge extends StatelessWidget {
  const _ValueBadge({required this.icon, required this.label, required this.isDark});
  final IconData icon;
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? DarkModeColors.surface2 : Colors.white.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(10),
        border: isDark ? Border.all(color: DarkModeColors.glassBorder) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: isDark ? DarkModeColors.accent : Colors.white),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDark ? DarkModeColors.text1 : Colors.white,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _CtaButton extends StatelessWidget {
  const _CtaButton({required this.isDark, required this.label});
  final bool isDark;
  final String label;

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? DarkModeColors.accent : Colors.white;
    final fg = isDark ? DarkModeColors.background : const Color(0xFFD4715A);

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            HapticFeedback.mediumImpact();
            Navigator.of(context).push(FadeRoute(page: const CameraScreen()));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.camera, size: 18, color: fg),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: fg,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
