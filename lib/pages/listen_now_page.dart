/// Apple Music-style home tab - photo history first, stats + quick actions at bottom
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../core/colors.dart';
import '../core/extensions/build_context_ext.dart';
import '../core/theme/app_theme.dart';
import '../data/database.dart';
import '../data/providers.dart';
import '../features/camera/camera_screen.dart';
import '../features/gallery/gallery_screen.dart';
import '../features/gallery/photo_detail_screen.dart';
import '../features/projects/projects_screen.dart';
import '../features/export/export_screen.dart';
import 'package:exacta/core/transitions.dart';

class ListenNowPage extends ConsumerWidget {
  const ListenNowPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final statsAsync = ref.watch(weeklyStatsProvider);
    final projectsAsync = ref.watch(activeProjectsProvider);
    final photosAsync = ref.watch(photosByProjectProvider(null));

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.paddingOf(context).top + 16),
        ),

        // ── 헤더: 브랜드 + 날짜 ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFA2D48), Color(0xFFE31C5F)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(LucideIcons.aperture, size: 20, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Text(l.homeTitle,
                  style: TextStyle(
                    fontFamily: AppTheme.monoFontFamily,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text1,
                    letterSpacing: -0.5,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surface2,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: Text(
                    _formattedDate(context),
                    style: TextStyle(
                      fontFamily: AppTheme.monoFontFamily,
                      fontSize: 12, color: AppColors.text2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),

        // ── 사진 히스토리 (최상단 — 핵심 콘텐츠 먼저) ──
        ...photosAsync.when(
          loading: () => [
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator(color: AppColors.accent, strokeWidth: 2)),
              ),
            ),
          ],
          error: (_, _) => [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                child: Center(child: Text(l.commonError, style: TextStyle(color: AppColors.text2))),
              ),
            ),
          ],
          data: (photos) {
            if (photos.isEmpty) {
              return [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 80, height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.surface2,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: AppColors.glassBorder),
                            ),
                            child: const Icon(LucideIcons.camera, size: 36, color: AppColors.accent),
                          ),
                          const SizedBox(height: 20),
                          Text(l.emptyGallery, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.text1)),
                          const SizedBox(height: 8),
                          Text(l.emptyGalleryAction, style: TextStyle(fontSize: 13, color: AppColors.text2)),
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            }

            // 날짜별 그룹핑
            final groups = <String, List<Photo>>{};
            for (final photo in photos) {
              final date = photo.timestamp.substring(0, 10);
              groups.putIfAbsent(date, () => []).add(photo);
            }
            final sortedDates = groups.keys.toList()..sort((a, b) => b.compareTo(a));

            return [
              for (final dateStr in sortedDates) ...[
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Text(_dateLabel(dateStr, l),
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.text1)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.surface2,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(l.galleryPhotos(groups[dateStr]!.length),
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.text2)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, crossAxisSpacing: 4, mainAxisSpacing: 4,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        final photo = groups[dateStr]![i];
                        return GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            SlideRightRoute(page: PhotoDetailScreen(photo: photo)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: photo.isVideo
                              ? Container(
                                  color: AppColors.surface2,
                                  child: const Center(child: Icon(LucideIcons.play, size: 24, color: AppColors.text3)))
                              : Image.file(
                                  File(photo.filePath),
                                  fit: BoxFit.cover,
                                  cacheWidth: 400,
                                  errorBuilder: (_, _, _) => Container(color: AppColors.surface2),
                                ),
                          ),
                        );
                      },
                      childCount: groups[dateStr]!.length,
                    ),
                  ),
                ),
                const SliverPadding(padding: EdgeInsets.only(top: 24)),
              ],
            ];
          },
        ),

        // ── 하단: 히어로 카드 ──
        SliverToBoxAdapter(child: const SizedBox(height: 8)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: statsAsync.when(
              loading: () => const _HeroCardShimmer(),
              error: (_, _) => _HeroCard(photos: 0, secure: 0, projects: 0, l: l),
              data: (stats) => _HeroCard(
                photos: stats.weeklyPhotos,
                secure: stats.securePhotos,
                projects: stats.activeProjects,
                l: l,
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),

        // ── 빠른 실행 ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Text(l.homeQuickActions,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.text1)),
                const Spacer(),
                Icon(LucideIcons.sparkles, size: 14, color: AppColors.text3),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                _QuickAction(
                  icon: LucideIcons.camera, label: l.navCamera,
                  gradient: const [Color(0xFFFA2D48), Color(0xFFE31C5F)],
                  onTap: () => Navigator.of(context).push(FadeRoute(page: const CameraScreen())),
                ),
                const SizedBox(width: 12),
                _QuickAction(
                  icon: LucideIcons.image, label: l.navGallery,
                  gradient: const [Color(0xFF7C3AED), Color(0xFFB8A0E8)],
                  onTap: () => Navigator.of(context).push(SlideUpRoute(page: const GalleryScreen())),
                ),
                const SizedBox(width: 12),
                _QuickAction(
                  icon: LucideIcons.folderOpen, label: l.navProjects,
                  gradient: const [Color(0xFF059669), Color(0xFF7ECBB4)],
                  onTap: () => Navigator.of(context).push(SlideUpRoute(page: const ProjectsScreen())),
                ),
                const SizedBox(width: 12),
                _QuickAction(
                  icon: LucideIcons.share2, label: l.exportTitle,
                  gradient: const [Color(0xFFF59E0B), Color(0xFFF0C078)],
                  onTap: () => Navigator.of(context).push(SlideUpRoute(page: const ExportScreen())),
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),

        // ── 진행중 프로젝트 ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Text(l.homeActiveProject,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.text1)),
                const Spacer(),
                Icon(LucideIcons.chevronRight, size: 16, color: AppColors.text3),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverToBoxAdapter(
          child: projectsAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator(color: AppColors.accent, strokeWidth: 2)),
            ),
            error: (_, _) => _emptyProjects(l),
            data: (projects) {
              if (projects.isEmpty) return _emptyProjects(l);
              return SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: min(projects.length, 5),
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final project = projects[index];
                    final gradients = AppColors.albumGradients;
                    final gradient = gradients[index % gradients.length];
                    return GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        FadeRoute(page: CameraScreen(initialProjectId: project.id)),
                      ),
                      child: Container(
                        width: 180,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: gradient,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 32, height: 32,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(LucideIcons.folderOpen, size: 16, color: Colors.white),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(project.name,
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                                const SizedBox(height: 2),
                                Text(l.homeContinueShooting,
                                  style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.6))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  static Widget _emptyProjects(dynamic l) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Column(
          children: [
            Icon(LucideIcons.folderPlus, size: 32, color: AppColors.text3),
            const SizedBox(height: 12),
            Text(l.emptyProjects, style: TextStyle(color: AppColors.text3, fontSize: 14)),
            const SizedBox(height: 4),
            Text(l.emptyProjectsAction, style: TextStyle(color: AppColors.text3.withValues(alpha: 0.5), fontSize: 12)),
          ],
        ),
      ),
    );
  }

  String _formattedDate(BuildContext context) {
    final now = DateTime.now();
    final locale = Localizations.localeOf(context).languageCode;
    if (locale == 'ja') return '${now.month}月${now.day}日';
    if (locale == 'en') return '${_monthName(now.month)} ${now.day}';
    return '${now.month}월 ${now.day}일';
  }

  String _monthName(int m) => const ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][m - 1];

  String _dateLabel(String dateStr, dynamic l) {
    final now = DateTime.now();
    final today = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final yesterday = now.subtract(const Duration(days: 1));
    final yesterdayStr = '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
    if (dateStr == today) return l.galleryToday;
    if (dateStr == yesterdayStr) return l.galleryYesterday;
    return dateStr;
  }
}

// ── 히어로 카드 — 글래스모피즘 + 3열 통계 ──
class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.photos, required this.secure, required this.projects, required this.l});
  final int photos;
  final int secure;
  final int projects;
  final dynamic l;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(color: const Color(0xFFFA2D48).withValues(alpha: 0.15), blurRadius: 32, offset: const Offset(0, 12)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(l.homeThisWeek,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white.withValues(alpha: 0.6), letterSpacing: 0.3)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(LucideIcons.trendingUp, size: 12, color: Color(0xFF34D399)),
                    const SizedBox(width: 4),
                    Text('$photos', style: TextStyle(
                      fontFamily: AppTheme.monoFontFamily,
                      fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF34D399))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _StatColumn(icon: LucideIcons.camera, value: '$photos', label: l.homeTotalShots, color: const Color(0xFFFA2D48)),
              const SizedBox(width: 24),
              _StatColumn(icon: LucideIcons.shieldCheck, value: '$secure', label: l.homeSecureShots, color: const Color(0xFFB8A0E8)),
              const SizedBox(width: 24),
              _StatColumn(icon: LucideIcons.folderOpen, value: '$projects', label: l.homeProjects, color: const Color(0xFF7ECBB4)),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.icon, required this.value, required this.label, required this.color});
  final IconData icon; final String value; final String label; final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontFamily: AppTheme.monoFontFamily, fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white, height: 1.1)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.45))),
        ],
      ),
    );
  }
}

class _HeroCardShimmer extends StatelessWidget {
  const _HeroCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, height: 160,
      decoration: BoxDecoration(
        color: AppColors.surface2, borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: const Center(child: CircularProgressIndicator(color: AppColors.accent, strokeWidth: 2)),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label, required this.gradient, required this.onTap});
  final IconData icon; final String label; final List<Color> gradient; final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        button: true, label: label,
        child: Material(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () { HapticFeedback.lightImpact(); onTap(); },
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(gradient: LinearGradient(colors: gradient), borderRadius: BorderRadius.circular(10)),
                    child: Icon(icon, size: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.text2), overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
