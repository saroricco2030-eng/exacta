/// Settings screen - stamp/camera/security/theme/locale/export/about/storage
/// 낙관적 업데이트 — 토글/변경 시 로컬 state 즉시 반영, DB write는 백그라운드.
import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:exacta/core/extensions/build_context_ext.dart';
import 'package:exacta/data/database.dart';
import 'package:exacta/data/providers.dart';
import 'package:exacta/features/export/export_screen.dart';
import 'package:exacta/providers/theme_notifier.dart';
import 'package:exacta/services/gallery_register_service.dart';

import 'package:exacta/features/settings/widgets/stamp_settings_section.dart';
import 'package:exacta/features/settings/widgets/camera_settings_section.dart';
import 'package:exacta/features/settings/widgets/security_settings_section.dart';
import 'package:exacta/features/settings/widgets/theme_locale_section.dart';
import 'package:exacta/features/settings/widgets/about_section.dart';
import 'package:exacta/features/settings/widgets/settings_tile.dart';
import 'package:exacta/core/theme/app_theme.dart';
import 'package:exacta/core/transitions.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  StampConfig? _config;
  bool _hasError = false;

  static const _stampColorOptions = [
    '#FFFFFF', '#FF9B7B', '#B8A0E8', '#7ECBB4',
    '#F0C078', '#FFD700', '#42A5F5', '#EF5350',
  ];

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    try {
      final config = await AppDatabase.instance.getStampConfig();
      if (mounted) setState(() => _config = config);
    } catch (e) {
      if (mounted) setState(() => _hasError = true);
    }
  }

  /// 낙관적 업데이트 — 로컬 state 즉시 갱신 후 DB write는 백그라운드.
  /// DB 실패 시 직전 값으로 롤백하고 스낵바 표시.
  Future<void> _update({
    String? dateFormat,
    String? fontFamily,
    String? stampColor,
    String? stampPosition,
    String? stampLayout,
    bool? showInNativeGallery,
    String? resolution,
    bool? shutterSound,
    bool? batterySaver,
    bool? exifStrip,
    bool? secureShareLimit,
    String? logoPath,
    String? signaturePath,
    String? themeMode,
    String? locale,
    // v12: 스탬프 커스터마이징 확장
    double? stampOpacity,
    String? stampSize,
    String? customLine1,
    String? customLine2,
    String? stampBgColor,
    // v13: 듀얼 저장
    bool? saveOriginal,
  }) async {
    final current = _config;
    if (current == null) return;

    // 1. 로컬 state 즉시 갱신 (낙관적) — copyWith는 null 파라미터를 무시.
    //    logoPath/signaturePath는 빈 문자열("")로 "삭제" 의미이므로 별도 처리.
    //    customLine1/customLine2는 빈 문자열("")로 "삭제" 의미이므로 별도 처리.
    final updated = current.copyWith(
      dateFormat: dateFormat,
      fontFamily: fontFamily,
      stampColor: stampColor,
      stampPosition: stampPosition,
      stampLayout: stampLayout,
      showInNativeGallery: showInNativeGallery,
      resolution: resolution,
      shutterSound: shutterSound,
      batterySaver: batterySaver,
      exifStrip: exifStrip,
      secureShareLimit: secureShareLimit,
      themeMode: themeMode,
      locale: locale,
      logoPath: logoPath != null
          ? Value(logoPath.isEmpty ? null : logoPath)
          : const Value.absent(),
      signaturePath: signaturePath != null
          ? Value(signaturePath.isEmpty ? null : signaturePath)
          : const Value.absent(),
      stampOpacity: stampOpacity,
      stampSize: stampSize,
      stampBgColor: stampBgColor,
      customLine1: customLine1 != null
          ? Value(customLine1.isEmpty ? null : customLine1)
          : const Value.absent(),
      customLine2: customLine2 != null
          ? Value(customLine2.isEmpty ? null : customLine2)
          : const Value.absent(),
      saveOriginal: saveOriginal,
    );

    setState(() => _config = updated);

    // 2. 테마/언어 notifier 즉시 동기화
    if (themeMode != null) {
      ref.read(themeProvider.notifier).applyFromDb(themeMode);
    }
    if (locale != null) {
      ref.read(localeProvider.notifier).applyFromDb(locale);
    }

    // 3. DB write는 백그라운드 — 실패 시 롤백
    try {
      await ref.read(dbProvider).updateStampConfig(
            StampConfigsCompanion(
              id: const Value(1),
              dateFormat: Value(updated.dateFormat),
              fontFamily: Value(updated.fontFamily),
              stampColor: Value(updated.stampColor),
              stampPosition: Value(updated.stampPosition),
              stampLayout: Value(updated.stampLayout),
              showInNativeGallery: Value(updated.showInNativeGallery),
              resolution: Value(updated.resolution),
              shutterSound: Value(updated.shutterSound),
              batterySaver: Value(updated.batterySaver),
              exifStrip: Value(updated.exifStrip),
              secureShareLimit: Value(updated.secureShareLimit),
              logoPath: Value(updated.logoPath),
              signaturePath: Value(updated.signaturePath),
              themeMode: Value(updated.themeMode),
              locale: Value(updated.locale),
              stampOpacity: Value(updated.stampOpacity),
              stampSize: Value(updated.stampSize),
              customLine1: Value(updated.customLine1),
              customLine2: Value(updated.customLine2),
              stampBgColor: Value(updated.stampBgColor),
              saveOriginal: Value(updated.saveOriginal),
            ),
          );

      // 순정 갤러리 토글 변경 시 양방향 동기화 (비차단)
      if (showInNativeGallery != null &&
          showInNativeGallery != current.showInNativeGallery) {
        unawaited(_syncNativeGallery(showInNativeGallery));
      }
    } catch (e) {
      debugPrint('updateStampConfig failed: $e');
      // 롤백
      if (mounted) {
        setState(() => _config = current);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.commonError),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  /// 순정 갤러리 토글 양방향 동기화
  Future<void> _syncNativeGallery(bool enabled) async {
    try {
      if (!enabled) {
        await GalleryRegisterService.removeAllFromGallery();
      } else {
        final all = await ref.read(dbProvider).getAllPhotos();
        for (final photo in all) {
          if (photo.isSecure || photo.isVideo) continue;
          await GalleryRegisterService.registerToGallery(photo.filePath);
        }
      }
    } catch (e) {
      debugPrint('syncNativeGallery failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;

    if (_hasError) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.triangleAlert, size: 48, color: context.danger),
                const SizedBox(height: 16),
                Text(l.commonError, style: TextStyle(color: context.text2)),
                const SizedBox(height: 16),
                SizedBox(
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() => _hasError = false);
                      _loadConfig();
                    },
                    icon: const Icon(LucideIcons.refreshCw, size: 18),
                    label: Text(l.commonRetry),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.accent,
                      side: BorderSide(color: context.accent),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_config == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: context.accent, strokeWidth: 2),
        ),
      );
    }

    final config = _config!;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          children: [
            Text(
              l.settingsTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),

            RepaintBoundary(
              child: StampSettingsSection(
                config: config,
                l: l,
                onUpdate: _update,
                stampColorOptions: _stampColorOptions,
              ),
            ),
            const SizedBox(height: 24),

            RepaintBoundary(
              child: CameraSettingsSection(
                config: config,
                l: l,
                onUpdate: _update,
              ),
            ),
            const SizedBox(height: 24),

            RepaintBoundary(
              child: SecuritySettingsSection(
                config: config,
                l: l,
                onUpdate: _update,
              ),
            ),
            const SizedBox(height: 24),

            ThemeLocaleSection(
              config: config,
              l: l,
              onUpdate: _update,
            ),
            const SizedBox(height: 24),

            // ── 내보내기 ──
            SizedBox(
              width: double.infinity,
              height: 56,
              child: Material(
                color: context.surfaceHi,
                borderRadius: BorderRadius.circular(16),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      SlideUpRoute(page: const ExportScreen()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(LucideIcons.download,
                            size: 18, color: context.accent),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l.exportTitle,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: context.text1,
                            ),
                          ),
                        ),
                        Icon(LucideIcons.chevronRight,
                            size: 18, color: context.text3),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            const _StorageSection(),
            const SizedBox(height: 24),

            AboutSection(l: l),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ── 저장 공간 섹션 ──
class _StorageSection extends StatefulWidget {
  const _StorageSection();

  @override
  State<_StorageSection> createState() => _StorageSectionState();
}

class _StorageSectionState extends State<_StorageSection> {
  int _photoCount = 0;
  int _totalBytes = 0;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  Future<void> _calculate() async {
    try {
      final paths = await AppDatabase.instance.getAllFilePaths();
      int total = 0;
      for (final path in paths) {
        try {
          final stat = await File(path).stat();
          total += stat.size;
        } catch (e) { debugPrint('Storage stat failed for $path: $e'); }
      }
      if (mounted) {
        setState(() {
          _photoCount = paths.length;
          _totalBytes = total;
          _loaded = true;
        });
      }
    } catch (e) {
      debugPrint('Storage calc failed: $e');
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(icon: LucideIcons.hardDrive, label: l.storageUsed),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.border),
          ),
          child: Row(
            children: [
              Icon(LucideIcons.database, size: 18, color: context.text2),
              const SizedBox(width: 12),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 240),
                  child: _loaded
                      ? Column(
                          key: const ValueKey('loaded'),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l.storagePhotos(_photoCount),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: context.text1,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _formatBytes(_totalBytes),
                              style: TextStyle(
                                fontFamily: AppTheme.monoFontFamily,
                                fontSize: 12,
                                color: context.text3,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          l.storageCalculating,
                          key: const ValueKey('loading'),
                          style: TextStyle(fontSize: 13, color: context.text3),
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
