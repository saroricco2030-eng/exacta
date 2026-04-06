/// Gallery photo grid - date grouping, SliverGrid lazy loading
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:exacta/core/extensions/build_context_ext.dart';
import 'package:exacta/l10n/generated/app_localizations.dart';
import 'package:exacta/core/theme/app_colors.dart';
import 'package:exacta/core/theme/app_theme.dart';
import 'package:exacta/data/database.dart';
import 'package:exacta/data/providers.dart';
import 'package:exacta/features/gallery/photo_detail_screen.dart';
import 'package:exacta/core/transitions.dart';

class GalleryLoaded extends StatelessWidget {
  const GalleryLoaded({
    super.key,
    required this.photos,
    required this.l,
    this.selectMode = false,
    this.selectedIds,
    this.onSelectionChanged,
  });
  final List<Photo> photos;
  final AppLocalizations l;
  final bool selectMode;
  final Set<int>? selectedIds;
  final VoidCallback? onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    // 날짜별 그룹핑
    final groups = <String, List<Photo>>{};
    for (final photo in photos) {
      final date = photo.timestamp.substring(0, 10); // YYYY-MM-DD
      groups.putIfAbsent(date, () => []).add(photo);
    }

    final sortedDates = groups.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // 최신순

    return CustomScrollView(
      slivers: [
        const SliverPadding(padding: EdgeInsets.only(top: 8)),
        for (final dateStr in sortedDates) ...[
          // 날짜 헤더
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Text(
                    _dateLabel(dateStr, l),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: context.text1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l.galleryPhotos(groups[dateStr]!.length),
                    style: TextStyle(
                      fontSize: 12,
                      color: context.text3,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(top: 12)),
          // 사진 그리드 — SliverGrid로 lazy 로딩
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) => PhotoTile(
                  photo: groups[dateStr]![i],
                  selectMode: selectMode,
                  isSelected: selectedIds?.contains(groups[dateStr]![i].id) ?? false,
                  onSelectToggle: () {
                    final id = groups[dateStr]![i].id;
                    if (selectedIds?.contains(id) ?? false) {
                      selectedIds?.remove(id);
                    } else {
                      selectedIds?.add(id);
                    }
                    onSelectionChanged?.call();
                  },
                ),
                childCount: groups[dateStr]!.length,
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(top: 24)),
        ],
      ],
    );
  }

  String _dateLabel(String dateStr, dynamic l) {
    final now = DateTime.now();
    final today =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final yesterdayStr =
        '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';

    if (dateStr == today) return l.galleryToday;
    if (dateStr == yesterdayStr) return l.galleryYesterday;
    return dateStr;
  }
}

// ── 사진 타일 ──────────────────────────────────────────────────
class PhotoTile extends ConsumerWidget {
  const PhotoTile({
    super.key,
    required this.photo,
    this.selectMode = false,
    this.isSelected = false,
    this.onSelectToggle,
  });
  final Photo photo;
  final bool selectMode;
  final bool isSelected;
  final VoidCallback? onSelectToggle;

  Future<void> _deletePhoto(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.surface,
        title: Text(l.commonDelete),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
                foregroundColor: ctx.danger),
            child: Text(l.commonDelete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      // 파일 삭제
      final file = File(photo.filePath);
      if (await file.exists()) {
        await file.delete();
      }
      // DB 삭제
      await ref.read(dbProvider).deletePhoto(photo.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Semantics(
      button: true,
      label: photo.isVideo ? 'Video' : 'Photo',
      child: GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        if (selectMode) {
          onSelectToggle?.call();
        } else {
          Navigator.of(context).push(
            SlideRightRoute(page: PhotoDetailScreen(photo: photo)),
          );
        }
      },
      onLongPress: selectMode ? null : () {
        HapticFeedback.mediumImpact();
        _deletePhoto(context, ref);
      },
      child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 사진/영상 썸네일
          if (photo.isVideo)
            Container(
              color: AppColors.darkBg,
              child: Center(
                child: Icon(LucideIcons.play,
                    size: 32, color: AppColors.darkText2),
              ),
            )
          else
            Image.file(
              File(photo.filePath),
              fit: BoxFit.cover,
              cacheWidth: 200,
              errorBuilder: (ctx, err, st) => Container(
                color: ctx.surfaceHi,
                child: Icon(LucideIcons.image, color: ctx.text3),
              ),
            ),

          // 영상 뱃지
          if (photo.isVideo)
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.darkBg.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(LucideIcons.video,
                    size: 10, color: AppColors.darkText1),
              ),
            ),

          // 보안 뱃지
          if (photo.isSecure)
            Positioned(
              top: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.secureBg.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.shieldCheck,
                        size: 10, color: AppColors.stampSecure),
                    const SizedBox(width: 2),
                    Text(
                      context.l10n.cameraSecure.toUpperCase(),
                      style: TextStyle(
                        fontFamily: AppTheme.monoFontFamily, // badge — custom 8sp Bold
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: AppColors.stampSecure,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // 선택 모드 체크마크
          if (selectMode)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: 24, height: 24,
                decoration: BoxDecoration(
                  color: isSelected
                      ? context.accent
                      : context.surface.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? context.accent : context.text3,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Icon(LucideIcons.check, size: 14, color: context.onAccent)
                    : null,
              ),
            ),
        ],
      ),
      ),
      ),
    );
  }
}
