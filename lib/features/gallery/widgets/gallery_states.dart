/// Gallery loading/empty/error state widgets
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:exacta/core/extensions/build_context_ext.dart';
import 'package:exacta/l10n/generated/app_localizations.dart';

class GalleryLoading extends StatelessWidget {
  const GalleryLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: context.accent,
        strokeWidth: 2,
      ),
    );
  }
}

class GalleryEmpty extends StatelessWidget {
  const GalleryEmpty({super.key, required this.l});
  final AppLocalizations l;

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
                LucideIcons.image,
                size: 36,
                color: context.accent,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l.emptyGallery,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: context.text1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l.emptyGalleryAction,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: context.text2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GalleryError extends StatelessWidget {
  const GalleryError({super.key, required this.l, required this.onRetry});
  final AppLocalizations l;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.triangleAlert,
              size: 48, color: context.danger),
          const SizedBox(height: 16),
          Text(l.commonError,
              style: TextStyle(color: context.text2)),
          const SizedBox(height: 16),
          SizedBox(
            height: 56,
            child: OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(LucideIcons.refreshCw, size: 18),
              label: Text(l.commonRetry),
              style: OutlinedButton.styleFrom(
                foregroundColor: context.accent,
                side: BorderSide(color: context.accent),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(horizontal: 32),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
