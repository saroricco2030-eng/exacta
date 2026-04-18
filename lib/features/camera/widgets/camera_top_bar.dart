/// Camera top bar - preset toggle/flash/close
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:exacta/l10n/generated/app_localizations.dart';
import 'package:exacta/core/theme/app_colors.dart';
import 'package:exacta/features/camera/camera_screen.dart';

// ── 상단 바 ────────────────────────────────────────────────────
class CameraTopBar extends StatelessWidget {
  const CameraTopBar({
    super.key,
    required this.preset,
    required this.flashIcon,
    required this.flashMode,
    required this.onPresetChanged,
    required this.onFlashTap,
    required this.onClose,
    required this.l,
    required this.stampEnabled,
    required this.onStampToggle,
    this.stampColor,
  });

  final CameraPreset preset;
  final IconData flashIcon;
  final FlashMode flashMode;
  final ValueChanged<CameraPreset> onPresetChanged;
  final VoidCallback onFlashTap;
  final VoidCallback onClose;
  final AppLocalizations l;
  final bool stampEnabled;
  final VoidCallback onStampToggle;
  final Color? stampColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top + 8,
        left: 16,
        right: 16,
        bottom: 12,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.gradientBlack80, AppColors.transparent],
        ),
      ),
      child: Row(
        children: [
          // 닫기 버튼
          _CircleButton(
            icon: LucideIcons.x,
            onTap: onClose,
          ),
          const SizedBox(width: 12),

          // 프리셋 토글
          Expanded(child: PresetToggle(
            preset: preset,
            onChanged: onPresetChanged,
            l: l,
            stampColor: stampColor,
          )),
          const SizedBox(width: 12),

          // 스탬프 on/off 토글
          Semantics(
            button: true,
            label: l.cameraStampToggleLabel,
            toggled: stampEnabled,
            child: _CircleButton(
              icon: stampEnabled ? LucideIcons.stamp : LucideIcons.eyeOff,
              onTap: onStampToggle,
              isActive: stampEnabled,
            ),
          ),
          const SizedBox(width: 8),

          // 플래시
          _CircleButton(
            icon: flashIcon,
            onTap: onFlashTap,
            isActive: flashMode != FlashMode.off,
          ),
        ],
      ),
    );
  }
}

// ── 프리셋 토글 ────────────────────────────────────────────────
class PresetToggle extends StatelessWidget {
  const PresetToggle({
    super.key,
    required this.preset,
    required this.onChanged,
    required this.l,
    this.stampColor,
  });

  final CameraPreset preset;
  final ValueChanged<CameraPreset> onChanged;
  final AppLocalizations l;
  final Color? stampColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: _PresetTab(
              label: l.cameraConstruction,
              icon: LucideIcons.hardHat,
              isActive: preset == CameraPreset.construction,
              color: this.stampColor ?? Colors.white,
              onTap: () => onChanged(CameraPreset.construction),
            ),
          ),
          Expanded(
            child: _PresetTab(
              label: l.cameraSecure,
              icon: LucideIcons.shieldCheck,
              isActive: preset == CameraPreset.secure,
              color: this.stampColor ?? Colors.white,
              onTap: () => onChanged(CameraPreset.secure),
            ),
          ),
        ],
      ),
    );
  }
}

class _PresetTab extends StatelessWidget {
  const _PresetTab({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isActive;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      selected: isActive,
      child: GestureDetector(
      onTap: () { HapticFeedback.selectionClick(); onTap(); },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 44,
        decoration: BoxDecoration(
          color: isActive ? color.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 14,
              color: isActive ? color : AppColors.darkText3,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? color : AppColors.darkText3,
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

// ── 원형 버튼 (상단 바) ────────────────────────────────────────
class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
    this.isActive = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 48,
        height: 48,
        child: Center(
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: Icon(
              icon,
              size: 18,
              color: isActive ? AppColors.darkAccent : AppColors.darkText2,
            ),
          ),
        ),
      ),
    );
  }
}
