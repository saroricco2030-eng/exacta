/// Gallery loading/empty/error state widgets
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:exacta/core/extensions/build_context_ext.dart';
import 'package:exacta/core/theme/app_theme.dart';
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── 샘플 사진 미리보기 카드 (스탬프가 어떻게 보이는지 시각화) ──
            _SampleStampCard(l: l, isDark: context.isDark),
            const SizedBox(height: 28),

            Text(
              l.emptyGallery,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: context.text1,
              ),
            ),
            const SizedBox(height: 6),
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

/// 빈 갤러리에 표시되는 샘플 스탬프 미리보기 카드
/// 실제 사진처럼 보이지 않게 그라디언트 + "예시" 라벨 명시 → 정직한 시각화
class _SampleStampCard extends StatefulWidget {
  const _SampleStampCard({required this.l, required this.isDark});
  final AppLocalizations l;
  final bool isDark;

  @override
  State<_SampleStampCard> createState() => _SampleStampCardState();
}

class _SampleStampCardState extends State<_SampleStampCard> {
  // 빈 갤러리는 자주 리빌드될 수 있음 — 샘플 시간은 첫 렌더 때 1회만 계산
  late final String _hhmm;
  late final String _dateStr;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _hhmm = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    _dateStr = '${now.year}.${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l = widget.l;
    final isDark = widget.isDark;

    return Container(
      width: 280,
      height: 280 * 4 / 3, // 4:3 사진 비율
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF2A3340), const Color(0xFF1A2030)]
              : [const Color(0xFFE8DCD0), const Color(0xFFC5B8AC)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            // 배경 텍스처 — 풍경 느낌의 부드러운 광원
            Positioned(
              top: -40, right: -40,
              child: Container(
                width: 160, height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withValues(alpha: isDark ? 0.08 : 0.4),
                      Colors.white.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),

            // "예시" 라벨 (좌상단)
            Positioned(
              top: 14, left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  l.emptyGalleryExampleLabel,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ),

            // ── 하단 스탬프 (실제 스탬프와 동일한 디자인) ──
            Positioned(
              left: 16, right: 16, bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 시간 — 큰 글씨
                  Text(
                    _hhmm,
                    style: TextStyle(
                      fontFamily: AppTheme.monoFontFamily,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.0,
                      shadows: const [
                        Shadow(offset: Offset(0, 1), blurRadius: 4, color: Color(0xCC000000)),
                        Shadow(offset: Offset(0, 0), blurRadius: 12, color: Color(0x99000000)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  // 날짜
                  Text(
                    _dateStr,
                    style: TextStyle(
                      fontFamily: AppTheme.monoFontFamily,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.9),
                      shadows: const [
                        Shadow(offset: Offset(0, 1), blurRadius: 4, color: Color(0xCC000000)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  // 주소
                  Row(
                    children: [
                      const Icon(LucideIcons.mapPin, size: 11, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        l.emptyGalleryStampPreviewAddress,
                        style: TextStyle(
                          fontFamily: AppTheme.monoFontFamily,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.85),
                          shadows: const [
                            Shadow(offset: Offset(0, 1), blurRadius: 4, color: Color(0xCC000000)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
