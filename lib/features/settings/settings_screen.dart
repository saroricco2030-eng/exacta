/// Settings screen - stamp/camera/security/theme/locale/export/about/storage
import 'dart:io';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:exacta/core/extensions/build_context_ext.dart';
import 'package:exacta/l10n/generated/app_localizations.dart';
import 'package:exacta/data/database.dart';
import 'package:exacta/data/providers.dart';
import 'package:exacta/features/export/export_screen.dart';
import 'package:exacta/providers/theme_notifier.dart';

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

  /// 설정 변경 후 로컬 state만 갱신 (StreamProvider 리빌드 없음)
  void _refreshConfig() async {
    final config = await AppDatabase.instance.getStampConfig();
    if (mounted) setState(() => _config = config);
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

    return Scaffold(
      body: SafeArea(
        child: _SettingsBody(
          config: _config!,
          l: l,
          ref: ref,
          onConfigChanged: _refreshConfig,
        ),
      ),
    );
  }
}

class _SettingsBody extends StatelessWidget {
  const _SettingsBody({
    required this.config,
    required this.l,
    required this.ref,
    required this.onConfigChanged,
  });

  final StampConfig config;
  final AppLocalizations l;
  final WidgetRef ref;
  final VoidCallback onConfigChanged;

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
  }) async {
    // M22: DB write 실패 catch
    try {
      await ref.read(dbProvider).updateStampConfig(
            StampConfigsCompanion(
              id: const Value(1),
              dateFormat: Value(dateFormat ?? config.dateFormat),
              fontFamily: Value(fontFamily ?? config.fontFamily),
              stampColor: Value(stampColor ?? config.stampColor),
              stampPosition: Value(stampPosition ?? config.stampPosition),
              stampLayout: Value(stampLayout ?? config.stampLayout),
              showInNativeGallery:
                  Value(showInNativeGallery ?? config.showInNativeGallery),
              resolution: Value(resolution ?? config.resolution),
              shutterSound: Value(shutterSound ?? config.shutterSound),
              batterySaver: Value(batterySaver ?? config.batterySaver),
              exifStrip: Value(exifStrip ?? config.exifStrip),
              secureShareLimit:
                  Value(secureShareLimit ?? config.secureShareLimit),
              logoPath: Value(logoPath ?? config.logoPath),
              signaturePath: Value(signaturePath ?? config.signaturePath),
              themeMode: Value(themeMode ?? config.themeMode),
              locale: Value(locale ?? config.locale),
            ),
          );
      onConfigChanged();
    } catch (e) {
      debugPrint('updateStampConfig failed: $e');
      rethrow;
    }
  }

  /// build()에서 context를 캡쳐하여 Notifier 동기화하는 래퍼
  SettingsUpdateCallback _updateWithNotifiers(BuildContext ctx) {
    return ({
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
    }) async {
      await _update(
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
        logoPath: logoPath,
        signaturePath: signaturePath,
        themeMode: themeMode,
        locale: locale,
      );
      if (themeMode != null) {
        ref.read(themeProvider.notifier).applyFromDb(themeMode);
      }
      if (locale != null) {
        ref.read(localeProvider.notifier).applyFromDb(locale);
      }
    };
  }

  static const _stampColorOptions = [
    '#FFFFFF', '#FF9B7B', '#B8A0E8', '#7ECBB4',
    '#F0C078', '#FFD700', '#42A5F5', '#EF5350',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      children: [
        Text(
          l.settingsTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 24),

        // ── 타임스탬프 ──
        StampSettingsSection(
          config: config,
          l: l,
          onUpdate: _update,
          stampColorOptions: _stampColorOptions,
        ),
        const SizedBox(height: 24),

        // ── 카메라 + 저장 ──
        CameraSettingsSection(
          config: config,
          l: l,
          onUpdate: _update,
        ),
        const SizedBox(height: 24),

        // ── 보안 ──
        SecuritySettingsSection(
          config: config,
          l: l,
          onUpdate: _update,
        ),
        const SizedBox(height: 24),

        // ── 테마/언어 ──
        ThemeLocaleSection(
          config: config,
          l: l,
          onUpdate: _updateWithNotifiers(context),
        ),
        const SizedBox(height: 24),

        // ── 내보내기 ──
        SizedBox(
          width: double.infinity,
          height: 56,
          child: Material(
            color: context.surfaceHi,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.of(context).push(
                  SlideUpRoute(page: const ExportScreen(),
                  ),
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

        // ── 저장 공간 ──
        _StorageSection(l: l),
        const SizedBox(height: 24),

        // ── 앱 정보 ──
        AboutSection(l: l),
        const SizedBox(height: 32),
      ],
    );
  }
}

// ── 저장 공간 섹션 ──
class _StorageSection extends StatefulWidget {
  const _StorageSection({required this.l});
  final AppLocalizations l;

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
        } catch (_) {}
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(icon: LucideIcons.hardDrive, label: widget.l.storageUsed),
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
                child: _loaded
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.l.storagePhotos(_photoCount),
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.text1),
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
                        widget.l.storageCalculating,
                        style: TextStyle(fontSize: 13, color: context.text3),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
