/// Stamp settings - date format, font, color picker, logo, signature, size, opacity, bg color, custom lines
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:exacta/core/extensions/build_context_ext.dart';
import 'package:exacta/core/safe_parse.dart';
import 'package:exacta/core/stamp_date_formatter.dart';
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
  // v12: 스탬프 커스터마이징 확장
  double? stampOpacity,
  String? stampSize,
  String? customLine1,
  String? customLine2,
  String? stampBgColor,
  // v13: 듀얼 저장
  bool? saveOriginal,
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

  static const _bgColorOptions = [
    '#000000', '#1A1A2E', '#0D1118', '#2A1520',
    '#1B2838', '#2D2D2D', '#3D2E22', '#0A2647',
  ];

  void _showBgColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.surface,
        content: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _bgColorOptions.map((hex) {
            final color = SafeParse.color(hex);
            final isActive = hex == config.stampBgColor;
            return GestureDetector(
              onTap: () {
                onUpdate(stampBgColor: hex);
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
                        ? context.accent
                        : context.border,
                    width: isActive ? 3 : 1.5,
                  ),
                ),
                child: isActive
                    ? const Icon(LucideIcons.check, size: 18, color: Color(0xFFFFFFFF))
                    : null,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.surface,
        content: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: stampColorOptions.map((hex) {
            final color = SafeParse.color(hex);
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
            items: StampDateFormatter.allFormats,
            itemLabels: StampDateFormatter.previewCache,
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
            items: const ['topLeft', 'topCenter', 'topRight', 'center', 'bottomLeft', 'bottomCenter', 'bottomRight'],
            itemLabels: {
              'topLeft': l.stampPositionTopLeft,
              'topCenter': l.stampPositionTopCenter,
              'topRight': l.stampPositionTopRight,
              'center': l.stampPositionCenter,
              'bottomLeft': l.stampPositionBottomLeft,
              'bottomCenter': l.stampPositionBottomCenter,
              'bottomRight': l.stampPositionBottomRight,
            },
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

        // v12: 스탬프 크기
        SettingsTile(
          icon: LucideIcons.maximize,
          label: l.settingsStampSize,
          trailing: DropdownValue(
            value: config.stampSize,
            items: const ['small', 'medium', 'large'],
            itemLabels: {
              'small': l.stampSizeSmall,
              'medium': l.stampSizeMedium,
              'large': l.stampSizeLarge,
            },
            onChanged: (v) => onUpdate(stampSize: v),
          ),
        ),
        const SizedBox(height: 8),

        // v12: 스탬프 투명도
        _StampOpacityTile(
          value: config.stampOpacity,
          label: l.settingsStampOpacity,
          onChanged: (v) => onUpdate(stampOpacity: v),
        ),
        const SizedBox(height: 8),

        // v12: 스탬프 배경색
        SettingsTile(
          icon: LucideIcons.paintBucket,
          label: l.settingsStampBgColor,
          trailing: ColorDot(hex: config.stampBgColor),
          onTap: () => _showBgColorPicker(context),
        ),
        const SizedBox(height: 8),

        // v12: 커스텀 텍스트 줄 1
        _CustomLineTextField(
          icon: LucideIcons.building2,
          label: l.settingsCustomLine1,
          hint: l.settingsCustomLine1Hint,
          value: config.customLine1 ?? '',
          onChanged: (v) => onUpdate(customLine1: v),
        ),
        const SizedBox(height: 8),

        // v12: 커스텀 텍스트 줄 2
        _CustomLineTextField(
          icon: LucideIcons.user,
          label: l.settingsCustomLine2,
          hint: l.settingsCustomLine2Hint,
          value: config.customLine2 ?? '',
          onChanged: (v) => onUpdate(customLine2: v),
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
                          cacheWidth: 64, cacheHeight: 64,
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
                        cacheWidth: 96, cacheHeight: 48,
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

// ── v12: 스탬프 투명도 슬라이더 타일 ──────────────────────────────
class _StampOpacityTile extends StatelessWidget {
  const _StampOpacityTile({
    required this.value,
    required this.label,
    required this.onChanged,
  });

  final double value;
  final String label;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final pct = (value * 100).round();
    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(LucideIcons.eye, size: 18, color: context.text2),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(fontSize: 14, color: context.text1),
                ),
              ),
              Text(
                '$pct%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: context.text2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Slider(
            value: value,
            min: 0.1,
            max: 1.0,
            divisions: 9,
            activeColor: context.accent,
            inactiveColor: context.border,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

// ── v12: 커스텀 텍스트 입력 타일 ──────────────────────────────────
class _CustomLineTextField extends StatefulWidget {
  const _CustomLineTextField({
    required this.icon,
    required this.label,
    required this.hint,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final String hint;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  State<_CustomLineTextField> createState() => _CustomLineTextFieldState();
}

class _CustomLineTextFieldState extends State<_CustomLineTextField> {
  late final TextEditingController _ctrl;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(_CustomLineTextField old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value && _ctrl.text != widget.value) {
      _ctrl.text = widget.value;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  void _onChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onChanged(v);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.border),
      ),
      child: Row(
        children: [
          Icon(widget.icon, size: 18, color: context.text2),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _ctrl,
              style: TextStyle(fontSize: 14, color: context.text1),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                hintText: widget.hint,
                hintStyle: TextStyle(fontSize: 13, color: context.text3),
                labelText: widget.label,
                labelStyle: TextStyle(fontSize: 12, color: context.text2),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              maxLength: 30,
              buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
              onChanged: _onChanged,
            ),
          ),
          if (_ctrl.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _ctrl.clear();
                widget.onChanged('');
              },
              child: Icon(LucideIcons.x, size: 16, color: context.text3),
            ),
        ],
      ),
    );
  }
}
