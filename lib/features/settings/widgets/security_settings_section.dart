/// Security settings - EXIF strip, secure share limit
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:exacta/l10n/generated/app_localizations.dart';
import 'package:exacta/data/database.dart';
import 'package:exacta/features/settings/widgets/settings_tile.dart';
import 'package:exacta/features/settings/widgets/stamp_settings_section.dart';

class SecuritySettingsSection extends StatelessWidget {
  const SecuritySettingsSection({
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
            icon: LucideIcons.shieldCheck, label: l.settingsSecurity),
        const SizedBox(height: 12),

        ToggleTile(
          icon: LucideIcons.mapPinOff,
          label: l.settingsExifStrip,
          value: config.exifStrip,
          onChanged: (v) => onUpdate(exifStrip: v),
        ),
        const SizedBox(height: 8),

        ToggleTile(
          icon: LucideIcons.lock,
          label: l.settingsSecureShareLimit,
          value: config.secureShareLimit,
          onChanged: (v) => onUpdate(secureShareLimit: v),
        ),
      ],
    );
  }
}
