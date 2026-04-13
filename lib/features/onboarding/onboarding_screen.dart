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

  static const _pages = [
    _PageData(
      icon: LucideIcons.camera,
      gradient: [Color(0xFFFF9B7B), Color(0xFFE880A0)],
      titleKey: 'onboarding1Title',
      descKey: 'onboarding1Desc',
    ),
    _PageData(
      icon: LucideIcons.folderOpen,
      gradient: [Color(0xFF059669), Color(0xFF7ECBB4)],
      titleKey: 'onboarding2Title',
      descKey: 'onboarding2Desc',
    ),
    _PageData(
      icon: LucideIcons.shieldCheck,
      gradient: [Color(0xFF7C3AED), Color(0xFFB8A0E8)],
      titleKey: 'onboarding3Title',
      descKey: 'onboarding3Desc',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    HapticFeedback.lightImpact();
    if (_currentPage < _pages.length - 1) {
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
                      context.l10n.commonSkip,
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
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return _OnboardingPage(
                      icon: page.icon,
                      gradient: page.gradient,
                      title: _getTitle(l, page.titleKey),
                      description: _getDesc(l, page.descKey),
                    );
                  },
                ),
              ),

              // Dots + Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Row(
                  children: [
                    // Page dots
                    Row(
                      children: List.generate(_pages.length, (i) {
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
                    // Next / Get Started
                    GestureDetector(
                      onTap: _next,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: _currentPage == _pages.length - 1 ? 140 : 56,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: context.btnGradient),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: _currentPage == _pages.length - 1
                              ? Text(
                                  _getStartText(l),
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

  String _getTitle(dynamic l, String key) {
    return switch (key) {
      'onboarding1Title' => l.onboarding1TitleFull,
      'onboarding2Title' => l.onboarding2TitleFull,
      'onboarding3Title' => l.onboarding3TitleFull,
      _ => '',
    };
  }

  String _getDesc(dynamic l, String key) {
    return switch (key) {
      'onboarding1Desc' => l.onboarding1DescFull,
      'onboarding2Desc' => l.onboarding2DescFull,
      'onboarding3Desc' => l.onboarding3DescFull,
      _ => '',
    };
  }

  String _getStartText(dynamic l) => l.commonStart;
}

class _PageData {
  final IconData icon;
  final List<Color> gradient;
  final String titleKey;
  final String descKey;
  const _PageData({required this.icon, required this.gradient, required this.titleKey, required this.descKey});
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.icon,
    required this.gradient,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final List<Color> gradient;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradient,
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: gradient[0].withValues(alpha: 0.3),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Icon(icon, size: 48, color: Colors.white),
          ),
          const SizedBox(height: 48),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: context.text1,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: context.text2,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
