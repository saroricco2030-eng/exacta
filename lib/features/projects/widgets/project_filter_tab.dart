/// Project filter tab (Active/Done) with Semantics + haptic
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:exacta/core/extensions/build_context_ext.dart';

class ProjectFilterTab extends StatelessWidget {
  const ProjectFilterTab({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      selected: isActive,
      child: Material(
        color: isActive ? context.accent : Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () {
            HapticFeedback.selectionClick();
            onTap();
          },
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            decoration: isActive ? null : BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: context.border),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive ? context.onAccent : context.text2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
