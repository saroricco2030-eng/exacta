/// Empty state for projects list
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:exacta/core/extensions/build_context_ext.dart';
import 'package:exacta/l10n/generated/app_localizations.dart';

class ProjectsEmpty extends StatelessWidget {
  const ProjectsEmpty({super.key, required this.l, required this.onCreateTap});
  final AppLocalizations l;
  final VoidCallback onCreateTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: context.accentDim,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                LucideIcons.folderPlus,
                size: 36,
                color: context.accent,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l.emptyProjects,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: context.text1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l.emptyProjectsAction,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: context.text2,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: context.btnGradient,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: onCreateTap,
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(LucideIcons.plus,
                              size: 20, color: context.onAccent),
                          const SizedBox(width: 8),
                          Text(
                            l.projectsNew,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: context.onAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
