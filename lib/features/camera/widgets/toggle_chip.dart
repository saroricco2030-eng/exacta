/// Animated toggle chip for stamp edit options
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:exacta/core/theme/app_colors.dart';

class ToggleChip extends StatelessWidget {
  const ToggleChip({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.isLocked = false,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final bool isLocked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color fg;
    final Color bg;
    final Color borderColor;

    if (isLocked) {
      fg = AppColors.darkText3;
      bg = Colors.transparent;
      borderColor = AppColors.darkBorder;
    } else if (isActive) {
      fg = AppColors.darkAccent;
      bg = AppColors.darkAccentDim;
      borderColor = AppColors.darkAccent.withValues(alpha: 0.3);
    } else {
      fg = AppColors.darkText3;
      bg = Colors.transparent;
      borderColor = AppColors.darkBorder;
    }

    return Semantics(
      button: true,
      label: label,
      toggled: isActive,
      enabled: !isLocked,
      child: GestureDetector(
        onTap: isLocked ? null : () { HapticFeedback.selectionClick(); onTap(); },
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLocked) ...[
                Icon(LucideIcons.lock, size: 12, color: fg),
                const SizedBox(width: 8),
              ],
              Icon(icon, size: 14, color: fg),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
