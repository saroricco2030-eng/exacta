/// Unified shell - preserves tab index across theme switches
/// Back button shows exit confirmation dialog
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:exacta/core/extensions/build_context_ext.dart';
import 'package:exacta/core/transitions.dart';
import 'package:exacta/providers/theme_notifier.dart';
import 'package:exacta/pages/listen_now_page.dart';
import 'package:exacta/pages/explore_tab.dart';
import 'package:exacta/features/camera/camera_screen.dart';
import 'package:exacta/features/gallery/gallery_screen.dart';
import 'package:exacta/features/projects/projects_screen.dart';
import 'package:exacta/features/settings/settings_screen.dart';

/// 통합 셸 — 테마 전환 시 탭 인덱스 유지
class DualShell extends ConsumerStatefulWidget {
  const DualShell({super.key});

  @override
  ConsumerState<DualShell> createState() => _DualShellState();
}

class _DualShellState extends ConsumerState<DualShell> {
  int _currentTab = 0;

  bool get _isDark {
    final mode = ref.watch(themeProvider);
    if (mode == ThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
    return mode == ThemeMode.dark;
  }

  void _openCamera() async {
    final result = await Navigator.of(context).push<String>(
      FadeRoute(page: const CameraScreen()),
    );
    if (result == 'gallery' && mounted) {
      setState(() => _currentTab = 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _isDark;
    final l = context.l10n;

    if (isDark) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFF141414),
        systemNavigationBarIconBrightness: Brightness.light,
      ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ));
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final exit = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(l.commonCancel),
            content: Text(_exitMessage(context)),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.commonCancel)),
              TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.commonSave.isNotEmpty ? 'OK' : 'OK')),
            ],
          ),
        );
        if (exit == true) SystemNavigator.pop();
      },
      child: Scaffold(
      backgroundColor: context.bg,
      body: SafeArea(
        bottom: false,
        child: RepaintBoundary(
          child: IndexedStack(
            index: _currentTab,
            children: [
              // 탭 0: 홈 — 테마별 다른 페이지
              isDark ? const ListenNowPage() : const ExploreTab(),
              const GalleryScreen(),
              const SizedBox(), // 카메라 (push)
              const ProjectsScreen(),
              // 탭 4: 설정 — SettingsScreen 직접 연결 (중간 단계 제거)
              const SettingsScreen(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: RepaintBoundary(child: _buildBottomNav(isDark, l)),
    ),
    );
  }

  String _exitMessage(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return switch (locale) {
      'ko' => '앱을 종료하시겠습니까?',
      'ja' => 'アプリを終了しますか？',
      _ => 'Exit the app?',
    };
  }

  Widget _buildBottomNav(bool isDark, dynamic l) {
    final navBg = isDark ? const Color(0xF2141414) : Colors.white;
    final borderColor = context.border;
    final activeColor = context.accent;
    final inactiveColor = context.text3;

    return Container(
      decoration: BoxDecoration(
        color: navBg,
        border: Border(top: BorderSide(color: borderColor, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _tab(LucideIcons.house, l.navHome, 0, activeColor, inactiveColor),
              _tab(LucideIcons.image, l.navGallery, 1, activeColor, inactiveColor),
              _cameraTab(l.navCamera, activeColor),
              _tab(LucideIcons.folderOpen, l.navProjects, 3, activeColor, inactiveColor),
              _tab(isDark ? LucideIcons.menu : LucideIcons.user, l.navSettings, 4, activeColor, inactiveColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tab(IconData icon, String label, int index, Color active, Color inactive) {
    final isActive = _currentTab == index;
    return Expanded(
      child: Semantics(
        button: true, label: label, selected: isActive,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (_currentTab == index) return;
              HapticFeedback.selectionClick();
              setState(() => _currentTab = index);
            },
            splashColor: active.withValues(alpha: 0.08),
            highlightColor: active.withValues(alpha: 0.04),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 아이콘: 선택 시 알약 배경 + 색상 전환
                AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutCubic,
                  width: 44,
                  height: 30,
                  decoration: BoxDecoration(
                    color: isActive
                        ? active.withValues(alpha: 0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 1.0, end: isActive ? 1.08 : 1.0),
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOutCubic,
                    builder: (_, scale, child) => Transform.scale(
                      scale: scale,
                      child: child,
                    ),
                    child: Icon(
                      icon,
                      color: isActive ? active : inactive,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive ? active : inactive,
                  ),
                  child: Text(label),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cameraTab(String label, Color active) {
    return Expanded(
      child: Semantics(
        button: true,
        label: label,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _openCamera,
            splashColor: active.withValues(alpha: 0.15),
            highlightColor: active.withValues(alpha: 0.08),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.94, end: 1.0),
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutBack,
                  builder: (_, scale, child) => Transform.scale(
                    scale: scale,
                    child: child,
                  ),
                  child: Container(
                    width: 44,
                    height: 30,
                    decoration: BoxDecoration(
                      color: active,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: active.withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      LucideIcons.camera,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: active,
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
