/// Theme/locale dropdown settings
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:exacta/l10n/generated/app_localizations.dart';
import 'package:exacta/data/database.dart';
import 'package:exacta/features/settings/widgets/settings_tile.dart';
import 'package:exacta/features/settings/widgets/stamp_settings_section.dart';

class ThemeLocaleSection extends StatelessWidget {
  const ThemeLocaleSection({
    super.key,
    required this.config,
    required this.l,
    required this.onUpdate,
  });

  final StampConfig config;
  final AppLocalizations l;
  final SettingsUpdateCallback onUpdate;

  @override
  Widget build(BuildContext context) {
    // 현지화 레이블 매핑 — 현재 locale 기준 즉시 반영
    final themeLabels = <String, String>{
      'system': l.themeSystem,
      'light': l.themeLight,
      'dark': l.themeDark,
    };
    final localeLabels = <String, String>{
      'system': l.localeSystem,
      'ko': l.localeKorean,
      'en': l.localeEnglish,
      'ja': l.localeJapanese,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(icon: LucideIcons.sun, label: l.settingsTheme),
        const SizedBox(height: 12),

        SettingsTile(
          icon: LucideIcons.palette,
          label: l.settingsTheme,
          trailing: DropdownValue(
            value: config.themeMode,
            items: const ['system', 'light', 'dark'],
            itemLabels: themeLabels,
            onChanged: (v) => onUpdate(themeMode: v),
          ),
        ),
        const SizedBox(height: 8),

        SettingsTile(
          icon: LucideIcons.languages,
          label: l.settingsLanguage,
          trailing: DropdownValue(
            value: config.locale,
            items: const ['system', 'ko', 'en', 'ja'],
            itemLabels: localeLabels,
            onChanged: (v) => onUpdate(locale: v),
          ),
        ),
      ],
    );
  }
}
