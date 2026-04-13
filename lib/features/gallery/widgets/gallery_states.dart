/// Gallery loading/empty/error state widgets
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:exacta/core/extensions/build_context_ext.dart';
import 'package:exacta/l10n/generated/app_localizations.dart';

/// 스켈레톤 로딩 — 날짜 헤더 + 사진 그리드 골격 애니메이션
class GalleryLoading extends StatefulWidget {
  const GalleryLoading({super.key});

  @override
  State<GalleryLoading> createState() => _GalleryLoadingState();
}

class _GalleryLoadingState extends State<GalleryLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shimmerBase = context.isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.black.withValues(alpha: 0.04);
    final shimmerHi = context.isDark
        ? Colors.white.withValues(alpha: 0.12)
        : Colors.black.withValues(alpha: 0.08);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final color = Color.lerp(shimmerBase, shimmerHi, _animation.value)!;
        return CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            // 날짜 헤더 스켈레톤
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
              sliver: SliverToBoxAdapter(
                child: Container(
                  width: 100, height: 14,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            // 사진 그리드 스켈레톤
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                delegate: SliverChildBuilderDelegate(
                  (_, __) => Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  childCount: 9,
                ),
              ),
            ),
            // 두 번째 날짜 헤더
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              sliver: SliverToBoxAdapter(
                child: Container(
                  width: 80, height: 14,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                delegate: SliverChildBuilderDelegate(
                  (_, __) => Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  childCount: 6,
                ),
              ),
            ),
          ],
        );
      },
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
