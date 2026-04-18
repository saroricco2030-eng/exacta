/// Onboarding - 3 pages, shown once via SharedPreferences
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:exacta/core/extensions/build_context_ext.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onComplete});
  final VoidCallback onComplete;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    HapticFeedback.lightImpact();
    if (_currentPage < 2) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      _complete();
    }
  }

  void _complete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final isDark = context.isDark;

    final pages = [
      _PageData(
        icon: LucideIcons.camera,
        gradient: const [Color(0xFFFF9B7B), Color(0xFFE880A0)], // 피치 → 로즈
        title: l.onboarding1TitleFull,
        description: l.onboarding1DescFull,
        bullets: [l.onboarding1Bullet1, l.onboarding1Bullet2, l.onboarding1Bullet3],
        bulletIcons: const [LucideIcons.clock, LucideIcons.satellite, LucideIcons.mapPin],
      ),
      _PageData(
        icon: LucideIcons.shieldCheck,
        gradient: const [Color(0xFF7C9EE8), Color(0xFFB8A0E8)], // 블루 → 라벤더 (증거)
        title: l.onboarding2TitleFull,
        description: l.onboarding2DescFull,
        bullets: [l.onboarding2Bullet1, l.onboarding2Bullet2, l.onboarding2Bullet3],
        bulletIcons: const [LucideIcons.link, LucideIcons.timer, LucideIcons.fileText],
      ),
      _PageData(
        icon: LucideIcons.eyeOff,
        gradient: const [Color(0xFF34D399), Color(0xFF7ECBB4)], // 민트 → 세이지 (보안)
        title: l.onboarding3TitleFull,
        description: l.onboarding3DescFull,
        bullets: [l.onboarding3Bullet1, l.onboarding3Bullet2, l.onboarding3Bullet3],
        bulletIcons: const [LucideIcons.satelliteDish, LucideIcons.fileX, LucideIcons.lock],
      ),
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: context.bg,
        body: SafeArea(
          child: Column(
            children: [
              // Skip
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 24, top: 16),
                  child: GestureDetector(
                    onTap: _complete,
                    child: Text(
                      l.commonSkip,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: context.text3,
                      ),
                    ),
                  ),
                ),
              ),

              // Pages
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemCount: pages.length,
                  itemBuilder: (context, index) => _OnboardingPage(data: pages[index]),
                ),
              ),

              // Dots + Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Row(
                  children: [
                    Row(
                      children: List.generate(pages.length, (i) {
                        final isActive = i == _currentPage;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                          width: isActive ? 24 : 8,
                          height: 8,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: isActive ? context.accent : context.text3.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: _next,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: _currentPage == pages.length - 1 ? 140 : 56,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: context.btnGradient),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: _currentPage == pages.length - 1
                              ? Text(
                                  l.commonStart,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: context.onAccent,
                                  ),
                                )
                              : Icon(LucideIcons.arrowRight, size: 22, color: context.onAccent),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageData {
  final IconData icon;
  final List<Color> gradient;
  final String title;
  final String description;
  final List<String> bullets;
  final List<IconData> bulletIcons;
  const _PageData({
    required this.icon,
    required this.gradient,
    required this.title,
    required this.description,
    required this.bullets,
    required this.bulletIcons,
  });
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data});
  final _PageData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── 큰 아이콘 (그라디언트 카드) ──
          Container(
            width: 124,
            height: 124,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: data.gradient,
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: data.gradient[0].withValues(alpha: 0.32),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Icon(data.icon, size: 52, color: Colors.white),
          ),
          const SizedBox(height: 40),

          // ── 타이틀 ──
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: context.text1,
              letterSpacing: -0.5,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 14),

          // ── 설명 ──
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: context.text2,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 28),

          // ── 체크 배지 3개 ──
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: List.generate(data.bullets.length, (i) {
              return _OnboardingBadge(
                icon: data.bulletIcons[i],
                label: data.bullets[i],
                accentColor: data.gradient[0],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _OnboardingBadge extends StatelessWidget {
  const _OnboardingBadge({
    required this.icon,
    required this.label,
    required this.accentColor,
  });
  final IconData icon;
  final String label;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: accentColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: accentColor,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
