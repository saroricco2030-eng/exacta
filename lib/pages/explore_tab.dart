/// Airbnb-style home tab - hero card, calendar, today strip, photo history, stats
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../core/colors.dart';
import '../core/extensions/build_context_ext.dart';
import '../core/theme/app_theme.dart';
import '../data/database.dart';
import '../data/providers.dart';
import '../features/camera/camera_screen.dart';
import '../features/gallery/photo_detail_screen.dart';
import '../features/home/photo_calendar.dart';
import 'package:exacta/core/transitions.dart';

class ExploreTab extends ConsumerStatefulWidget {
  const ExploreTab({super.key});

  @override
  ConsumerState<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends ConsumerState<ExploreTab> {
  int? _selectedProjectId;
  ({int total, int secure, int projects})? _todayStats;
  List<Project>? _recentProjects;

  @override
  void initState() {
    super.initState();
    _loadExtras();
  }

  Future<void> _loadExtras() async {
    final db = AppDatabase.instance;
    final today = await db.getTodayStats();
    final projects = await db.getProjectsByStatus('active');
    if (mounted) {
      setState(() {
        _todayStats = today;
        _recentProjects = projects.take(3).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final photosAsync = ref.watch(photosByProjectProvider(_selectedProjectId));
    final projectsAsync = ref.watch(allProjectsProvider);
    final statsAsync = ref.watch(weeklyStatsProvider);
    final latestAsync = ref.watch(latestPhotoProvider);

    return RefreshIndicator(
      color: AirbnbColors.primary,
      onRefresh: () async {
        ref.invalidate(weeklyStatsProvider);
        ref.invalidate(latestPhotoProvider);
        await _loadExtras();
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: const SizedBox(height: 16)),

          // ── 헤더 ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: AirbnbColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(LucideIcons.aperture, size: 20, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(l.homeTitle,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AirbnbColors.text1, letterSpacing: -0.5),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // ── 마지막 촬영 히어로 카드 ──
          SliverToBoxAdapter(
            child: latestAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
              data: (photo) {
                if (photo == null) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _HeroPhotoCard(photo: photo, label: l.homeLastPhoto),
                );
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // ── 오늘의 요약 스트립 ──
          if (_todayStats != null && _todayStats!.total > 0)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AirbnbColors.bg2,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(LucideIcons.activity, size: 14, color: AirbnbColors.primary),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          '${l.homeTodayPhotos(_todayStats!.total)}  ·  ${l.homeTodaySecure(_todayStats!.secure)}  ·  ${l.homeTodayProjects(_todayStats!.projects)}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AirbnbColors.text2),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // ── 촬영 활동 캘린더 ──
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: RepaintBoundary(
                child: PhotoCalendar(accentColor: AirbnbColors.primary),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // ── 바로 촬영 (최근 프로젝트 칩) ──
          if (_recentProjects != null && _recentProjects!.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(l.homeRecentProjects,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AirbnbColors.text1)),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: _recentProjects!.length + 1,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (ctx, i) {
                    if (i == 0) {
                      return _ShootChip(
                        icon: LucideIcons.camera,
                        label: l.navCamera,
                        color: AirbnbColors.primary,
                        onTap: () => Navigator.of(context).push(FadeRoute(page: const CameraScreen())),
                      );
                    }
                    final p = _recentProjects![i - 1];
                    return _ShootChip(
                      icon: LucideIcons.folderOpen,
                      label: p.name,
                      color: context.parseHexColor(p.color),
                      onTap: () => Navigator.of(context).push(
                        FadeRoute(page: CameraScreen(initialProjectId: p.id)),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ],

          // ── 프로젝트 필터 ──
          SliverToBoxAdapter(
            child: SizedBox(
              height: 40,
              child: projectsAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
                data: (projects) => ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: projects.length + 1,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _FilterChip(label: l.commonAll, isActive: _selectedProjectId == null,
                        onTap: () => setState(() => _selectedProjectId = null));
                    }
                    final project = projects[index - 1];
                    return _FilterChip(label: project.name, isActive: _selectedProjectId == project.id,
                      onTap: () => setState(() => _selectedProjectId = project.id));
                  },
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // ── 사진 히스토리 ──
          ...photosAsync.when(
            loading: () => [
              const SliverToBoxAdapter(
                child: SizedBox(height: 200,
                  child: Center(child: CircularProgressIndicator(color: AirbnbColors.primary, strokeWidth: 2))),
              ),
            ],
            error: (_, _) => [
              SliverToBoxAdapter(
                child: SizedBox(height: 200,
                  child: Center(child: Text(l.commonError, style: const TextStyle(color: AirbnbColors.text2)))),
              ),
            ],
            data: (photos) {
              if (photos.isEmpty) {
                return [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 64, height: 64,
                              decoration: BoxDecoration(
                                color: AirbnbColors.primaryLight,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(LucideIcons.camera, size: 28, color: AirbnbColors.primary),
                            ),
                            const SizedBox(height: 16),
                            Text(l.homeNoPhotosYet, style: const TextStyle(fontSize: 14, color: AirbnbColors.text2)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ];
              }

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
                            Flexible(
                              child: Text(_dateLabel(dateStr, l),
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AirbnbColors.text1),
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AirbnbColors.bg2,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(l.galleryPhotos(groups[dateStr]!.length),
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AirbnbColors.text2)),
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
                        crossAxisCount: 3, crossAxisSpacing: 4, mainAxisSpacing: 4),
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          final photo = groups[dateStr]![i];
                          return GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              SlideRightRoute(page: PhotoDetailScreen(photo: photo))),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: photo.isVideo
                                ? Container(color: AirbnbColors.bg2,
                                    child: const Center(child: Icon(LucideIcons.play, size: 24, color: AirbnbColors.text3)))
                                : Image.file(File(photo.filePath), fit: BoxFit.cover, cacheWidth: 400,
                                    errorBuilder: (_, _, _) => Container(color: AirbnbColors.bg2)),
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

          // ── 하단: 주간 통계 ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: statsAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
                data: (stats) => Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFFFF0F2), Color(0xFFFFF8F0)]),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AirbnbColors.primary.withValues(alpha: 0.1)),
                  ),
                  child: Row(
                    children: [
                      _LightStat(icon: LucideIcons.camera, value: '${stats.weeklyPhotos}', label: l.homeTotalShots),
                      _LightStat(icon: LucideIcons.shieldCheck, value: '${stats.securePhotos}', label: l.homeSecureShots),
                      _LightStat(icon: LucideIcons.folderOpen, value: '${stats.activeProjects}', label: l.homeProjects),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

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

// ── 마지막 촬영 히어로 카드 ──
class _HeroPhotoCard extends StatelessWidget {
  const _HeroPhotoCard({required this.photo, required this.label});
  final Photo photo;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        SlideRightRoute(page: PhotoDetailScreen(photo: photo)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // 사진
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220),
              child: SizedBox(
                width: double.infinity,
                child: photo.isVideo
                    ? Container(
                        height: 220,
                        color: AirbnbColors.bg2,
                        child: const Center(child: Icon(LucideIcons.play, size: 48, color: AirbnbColors.text3)))
                    : Image.file(
                        File(photo.filePath),
                        fit: BoxFit.cover,
                        height: 220,
                        cacheWidth: 800,
                        errorBuilder: (_, _, _) => Container(
                          height: 220, color: AirbnbColors.bg2,
                          child: const Center(child: Icon(LucideIcons.imageOff, size: 32, color: AirbnbColors.text3))),
                      ),
              ),
            ),
            // 하단 그래디언트 + 메타
            Positioned(
              left: 0, right: 0, bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 12),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter, end: Alignment.topCenter,
                    colors: [Color(0xCC000000), Color(0x00000000)],
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(label,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Color(0x99FFFFFF))),
                          const SizedBox(height: 2),
                          if (photo.address != null && photo.address!.isNotEmpty && !photo.isSecure)
                            Text(photo.address!,
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      photo.timestamp.substring(11, 16),
                      style: TextStyle(
                        fontFamily: AppTheme.monoFontFamily,
                        fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            // 보안 뱃지
            if (photo.isSecure)
              Positioned(
                top: 8, left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xDD2A1520),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(LucideIcons.shieldCheck, size: 10, color: Color(0xFFFCA5A5)),
                      const SizedBox(width: 4),
                      Text('SECURE',
                        style: TextStyle(fontFamily: AppTheme.monoFontFamily, fontSize: 8, fontWeight: FontWeight.w700,
                          color: const Color(0xFFFCA5A5), letterSpacing: 0.5)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── 바로 촬영 칩 ──
class _ShootChip extends StatelessWidget {
  const _ShootChip({required this.icon, required this.label, required this.color, required this.onTap});
  final IconData icon; final String label; final Color color; final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 100),
              child: Text(label,
                maxLines: 1, overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
            ),
            const SizedBox(width: 4),
            Icon(LucideIcons.chevronRight, size: 12, color: color.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }
}

class _LightStat extends StatelessWidget {
  const _LightStat({required this.icon, required this.value, required this.label});
  final IconData icon; final String value; final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 16, color: AirbnbColors.primary),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontFamily: AppTheme.monoFontFamily,
            fontSize: 22, fontWeight: FontWeight.w700, color: AirbnbColors.text1)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 10, color: AirbnbColors.text2),
            overflow: TextOverflow.ellipsis, maxLines: 1),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.isActive, required this.onTap});
  final String label; final bool isActive; final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AirbnbColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? AirbnbColors.primary : AirbnbColors.border),
        ),
        child: Text(label, style: TextStyle(
          fontSize: 13, fontWeight: FontWeight.w500,
          color: isActive ? Colors.white : AirbnbColors.text1),
          maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
