/// Stamp settings - date format, font, color picker, logo, signature
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:exacta/core/extensions/build_context_ext.dart';
import 'package:exacta/l10n/generated/app_localizations.dart';
import 'package:exacta/data/database.dart';
import 'package:exacta/features/settings/signature_pad_screen.dart';
import 'package:exacta/features/settings/widgets/settings_tile.dart';
import 'package:exacta/core/transitions.dart';

typedef SettingsUpdateCallback = Future<void> Function({
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
});

class StampSettingsSection extends StatelessWidget {
  const StampSettingsSection({
    super.key,
    required this.config,
    required this.l,
    required this.onUpdate,
    required this.stampColorOptions,
  });

  final StampConfig config;
  final AppLocalizations l;
  final SettingsUpdateCallback onUpdate;
  final List<String> stampColorOptions;

  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.surface,
        content: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: stampColorOptions.map((hex) {
            final color = Color(int.parse(hex.replaceFirst('#', '0xFF')));
            final isActive = hex == config.stampColor;
            return GestureDetector(
              onTap: () {
                onUpdate(stampColor: hex);
                Navigator.pop(ctx);
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isActive
                        ? context.text1
                        : (color.computeLuminance() > 0.8
                            ? context.border
                            : Colors.transparent),
                    width: isActive ? 3 : 1.5,
                  ),
                ),
                child: isActive
                    ? Icon(LucideIcons.check,
                        size: 18,
                        color: color.computeLuminance() > 0.5
                            ? Colors.black87
                            : Colors.white)
                    : null,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _pickLogo(BuildContext context) async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.gallery, maxWidth: 512);
    if (xFile == null) return;

    final appDir = await getApplicationDocumentsDirectory();
    final logoDir = Directory(p.join(appDir.path, 'assets'));
    if (!await logoDir.exists()) await logoDir.create(recursive: true);
    final destPath = p.join(logoDir.path, 'logo.png');
    await File(xFile.path).copy(destPath);

    onUpdate(logoPath: destPath);
  }

  Future<void> _openSignaturePad(BuildContext context) async {
    final result = await Navigator.of(context).push<String>(
      SlideRightRoute(page: const SignaturePadScreen()),
    );
    if (result != null) {
      onUpdate(signaturePath: result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(icon: LucideIcons.clock, label: l.settingsTimestamp),
        const SizedBox(height: 12),

        SettingsTile(
          icon: LucideIcons.calendar,
          label: l.settingsDateFormat,
          trailing: DropdownValue(
            value: config.dateFormat,
            items: const ['YYYY.MM.DD', 'MM/DD/YYYY', 'DD-MM-YYYY'],
            onChanged: (v) => onUpdate(dateFormat: v),
          ),
        ),
        const SizedBox(height: 8),

        SettingsTile(
          icon: LucideIcons.type,
          label: l.settingsFont,
          trailing: DropdownValue(
            value: config.fontFamily,
            items: const ['mono', 'sans'],
            onChanged: (v) => onUpdate(fontFamily: v),
          ),
        ),
        const SizedBox(height: 8),

        SettingsTile(
          icon: LucideIcons.palette,
          label: l.settingsStampColor,
          trailing: ColorDot(hex: config.stampColor),
          onTap: () => _showColorPicker(context),
        ),
        const SizedBox(height: 8),

        SettingsTile(
          icon: LucideIcons.alignVerticalJustifyEnd,
          label: l.settingsStampPosition,
          trailing: DropdownValue(
            value: config.stampPosition,
            items: const ['bottom', 'top'],
            onChanged: (v) => onUpdate(stampPosition: v),
          ),
        ),
        const SizedBox(height: 8),

        SettingsTile(
          icon: LucideIcons.layoutTemplate,
          label: l.settingsStampLayout,
          trailing: DropdownValue(
            value: config.stampLayout,
            items: const ['card', 'bar', 'text'],
            itemLabels: {
              'card': l.stampLayoutCard,
              'bar': l.stampLayoutBar,
              'text': l.stampLayoutText,
            },
            onChanged: (v) => onUpdate(stampLayout: v),
          ),
        ),
        const SizedBox(height: 8),

        // 로고 선택
        SettingsTile(
          onTap: () => _pickLogo(context),
          icon: LucideIcons.image,
          label: l.stampLogo,
          trailing: config.logoPath != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.file(
                          File(config.logoPath!),
                          width: 32,
                          cacheWidth: 64,
                          height: 32,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, e, st) => Icon(
                              LucideIcons.imageOff,
                              size: 16, color: ctx.text3),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => onUpdate(logoPath: ''),
                        child: Icon(LucideIcons.x,
                            size: 16, color: context.text3),
                      ),
                    ],
                  )
                : Text(
                    l.stampLogoSelect,
                    style: TextStyle(
                      fontSize: 12,
                      color: context.accent,
                    ),
                  ),
        ),
        const SizedBox(height: 8),

        // 서명 등록
        SettingsTile(
          onTap: () => _openSignaturePad(context),
          icon: LucideIcons.penTool,
          label: l.stampSignature,
          trailing: config.signaturePath != null &&
                  config.signaturePath!.isNotEmpty
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.file(
                        File(config.signaturePath!),
                        width: 48,
                        cacheWidth: 96,
                        height: 24,
                        fit: BoxFit.contain,
                        errorBuilder: (ctx, e, st) => Icon(
                            LucideIcons.imageOff,
                            size: 16, color: ctx.text3),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => onUpdate(signaturePath: ''),
                      child: Icon(LucideIcons.x,
                          size: 16, color: context.text3),
                    ),
                  ],
                )
              : Text(
                  l.stampSignatureDraw,
                  style: TextStyle(
                    fontSize: 12,
                    color: context.accent,
                  ),
                ),
        ),
      ],
    );
  }
}
