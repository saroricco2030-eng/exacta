/// Camera settings - resolution, shutter sound, battery saver
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:exacta/core/extensions/build_context_ext.dart';
import 'package:exacta/l10n/generated/app_localizations.dart';
import 'package:exacta/data/database.dart';
import 'package:exacta/features/settings/widgets/settings_tile.dart';
import 'package:exacta/features/settings/widgets/stamp_settings_section.dart';

class CameraSettingsSection extends StatelessWidget {
  const CameraSettingsSection({
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
        // ── 카메라 ──
        SectionHeader(icon: LucideIcons.camera, label: l.settingsCamera),
        const SizedBox(height: 12),

        SettingsTile(
          icon: LucideIcons.maximize,
          label: l.settingsResolution,
          trailing: DropdownValue(
            value: config.resolution,
            items: const ['1080p', '4k'],
            onChanged: (v) => onUpdate(resolution: v),
          ),
        ),
        const SizedBox(height: 8),

        ToggleTile(
          icon: LucideIcons.volumeOff,
          label: l.settingsShutterSound,
          value: config.shutterSound,
          onChanged: (v) => onUpdate(shutterSound: v),
        ),
        const SizedBox(height: 8),

        ToggleTile(
          icon: LucideIcons.batteryLow,
          label: l.settingsBatterySaver,
          value: config.batterySaver,
          onChanged: (v) => onUpdate(batterySaver: v),
        ),
        const SizedBox(height: 24),

        // ── 저장 ──
        SectionHeader(icon: LucideIcons.hardDrive, label: l.settingsStorage),
        const SizedBox(height: 12),

        ToggleTile(
          icon: LucideIcons.image,
          label: l.settingsShowInGallery,
          value: config.showInNativeGallery,
          onChanged: (v) => onUpdate(showInNativeGallery: v),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 56, top: 4),
          child: Text(
            '${l.settingsSecureAlwaysHidden} (${l.settingsForced})',
            style: TextStyle(
              fontSize: 11,
              color: context.text3,
            ),
          ),
        ),
        const SizedBox(height: 8),

        // v13: 듀얼 저장 — 원본도 별도 보관
        ToggleTile(
          icon: LucideIcons.copy,
          label: l.settingsSaveOriginal,
          value: config.saveOriginal,
          onChanged: (v) => onUpdate(saveOriginal: v),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 56, top: 4),
          child: Text(
            l.settingsSaveOriginalDesc,
            style: TextStyle(
              fontSize: 11,
              color: context.text3,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
