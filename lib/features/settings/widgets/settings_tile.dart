/// Reusable settings UI components - tile, toggle, dropdown, color dot
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:exacta/core/extensions/build_context_ext.dart';
import 'package:exacta/core/theme/app_theme.dart';

// ── 공통 모션 상수 ────────────────────────────────────────────
const _kTileAnimDuration = Duration(milliseconds: 220);
const _kTileAnimCurve = Curves.easeOutCubic;

// ── 섹션 헤더 ──────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: context.accent),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: context.accent,
          ),
        ),
      ],
    );
  }
}

// ── 설정 타일 ──────────────────────────────────────────────────
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.label,
    required this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: context.text2),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: context.text1,
              ),
            ),
          ),
          trailing,
        ],
      ),
    );

    return Material(
      color: context.surface,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.border),
        ),
        child: onTap != null
            ? InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onTap!();
                },
                splashColor: context.accent.withValues(alpha: 0.08),
                highlightColor: context.accent.withValues(alpha: 0.04),
                child: content,
              )
            : content,
      ),
    );
  }
}

// ── 토글 타일 ──────────────────────────────────────────────────
class ToggleTile extends StatelessWidget {
  const ToggleTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final activeBg = context.accent.withValues(alpha: 0.06);
    final activeBorder = context.accent.withValues(alpha: 0.35);

    return Semantics(
      toggled: value,
      label: label,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            onChanged(!value);
          },
          splashColor: context.accent.withValues(alpha: 0.08),
          highlightColor: context.accent.withValues(alpha: 0.04),
          child: AnimatedContainer(
            duration: _kTileAnimDuration,
            curve: _kTileAnimCurve,
            constraints: const BoxConstraints(minHeight: 56),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: value ? activeBg : context.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: value ? activeBorder : context.border,
              ),
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: _kTileAnimDuration,
                  curve: _kTileAnimCurve,
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: value
                        ? context.accent.withValues(alpha: 0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: value ? context.accent : context.text2,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      color: context.text1,
                    ),
                  ),
                ),
                Switch.adaptive(
                  value: value,
                  onChanged: (v) {
                    HapticFeedback.selectionClick();
                    onChanged(v);
                  },
                  activeTrackColor: context.accent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── 드롭다운 값 표시 ──────────────────────────────────────────
class DropdownValue extends StatelessWidget {
  const DropdownValue({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.itemLabels,
    this.useMonoFont = true,
  });

  /// 현재 선택된 값 (내부 키)
  final String value;

  /// 선택지 내부 키 목록
  final List<String> items;
  final ValueChanged<String> onChanged;

  /// 키 → 표시 레이블 매핑 (현지화 지원). null이면 키를 그대로 표시.
  final Map<String, String>? itemLabels;

  /// 값 텍스트에 모노스페이스 폰트 사용 여부 (현지화 레이블은 기본 폰트 사용 권장)
  final bool useMonoFont;

  String _labelFor(String key) => itemLabels?[key] ?? key;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      initialValue: value,
      onSelected: (v) {
        HapticFeedback.selectionClick();
        onChanged(v);
      },
      color: context.surface,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: context.border),
      ),
      itemBuilder: (ctx) => items
          .map((item) => PopupMenuItem(
                value: item,
                child: Text(
                  _labelFor(item),
                  style: TextStyle(
                    color: context.text1,
                    fontWeight: item == value
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              ))
          .toList(),
      child: AnimatedContainer(
        duration: _kTileAnimDuration,
        curve: _kTileAnimCurve,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: context.surfaceHi,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: _kTileAnimDuration,
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SizeTransition(
                  sizeFactor: anim,
                  axis: Axis.horizontal,
                  child: child,
                ),
              ),
              child: Text(
                _labelFor(value),
                key: ValueKey(value),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: context.text1,
                  fontFamily: (useMonoFont && itemLabels == null)
                      ? AppTheme.monoFontFamily
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Icon(LucideIcons.chevronDown,
                size: 14, color: context.text3),
          ],
        ),
      ),
    );
  }
}

// ── 컬러 닷 ────────────────────────────────────────────────────
class ColorDot extends StatelessWidget {
  const ColorDot({super.key, required this.hex});
  final String hex;

  @override
  Widget build(BuildContext context) {
    Color color;
    try {
      color = Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (e) {
      color = context.accent;
    }
    return AnimatedContainer(
      duration: _kTileAnimDuration,
      curve: _kTileAnimCurve,
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: context.border, width: 2),
      ),
    );
  }
}
