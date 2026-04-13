/// Gallery photo grid - date grouping, SliverGrid lazy loading,
/// long-press selection entry, drag-to-select, multi-select.
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
import 'package:exacta/features/gallery/photo_detail_screen.dart';
import 'package:exacta/core/transitions.dart';

class GalleryLoaded extends StatefulWidget {
  const GalleryLoaded({
    super.key,
    required this.photos,
    required this.l,
    this.selectMode = false,
    this.selectedIds,
    this.onSelectionChanged,
    this.onEnterSelectMode,
  });
  final List<Photo> photos;
  final AppLocalizations l;
  final bool selectMode;
  final Set<int>? selectedIds;
  final VoidCallback? onSelectionChanged;
  /// 선택 모드가 OFF일 때 long-press로 진입할 때 호출.
  /// 인자로 첫 선택할 사진 ID를 받는다.
  final ValueChanged<int>? onEnterSelectMode;

  @override
  State<GalleryLoaded> createState() => _GalleryLoadedState();
}

class _GalleryLoadedState extends State<GalleryLoaded> {
  // 드래그 선택을 위한 타일 GlobalKey 매핑.
  // 화면에 보이는 타일만 currentContext가 살아있으므로,
  // 보이는 영역만 hit-test 됨 (성능 OK).
  final Map<int, GlobalKey> _tileKeys = {};

  // 드래그 상태
  Offset? _dragStartPos;
  bool _isDragging = false;
  // 같은 드래그 안에서 한 타일은 한 번만 토글되도록 추적
  final Set<int> _dragVisitedIds = {};
  // 첫 hit 시점에 결정 — true면 추가, false면 제거.
  // 이후 드래그 방향과 무관하게 일관된 동작.
  bool? _dragSelectMode;

  GlobalKey _keyFor(int id) => _tileKeys.putIfAbsent(id, () => GlobalKey());

  /// 주어진 글로벌 좌표가 어느 타일 위에 있는지 찾는다.
  int? _hitTestTile(Offset globalPos) {
    for (final entry in _tileKeys.entries) {
      final ctx = entry.value.currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) continue;
      final tl = box.localToGlobal(Offset.zero);
      final rect = Rect.fromLTWH(tl.dx, tl.dy, box.size.width, box.size.height);
      if (rect.contains(globalPos)) return entry.key;
    }
    return null;
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (!widget.selectMode) return;
    _dragStartPos = event.position;
    _isDragging = false;
    _dragVisitedIds.clear();
    _dragSelectMode = null;
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (!widget.selectMode || _dragStartPos == null) return;
    // 드래그 임계값: 12px 이상 이동해야 드래그로 판정 (탭 오인 방지)
    if (!_isDragging) {
      final dist = (event.position - _dragStartPos!).distance;
      if (dist < 12) return;
      _isDragging = true;
      // 드래그 시작 지점의 타일도 토글에 포함
      final startId = _hitTestTile(_dragStartPos!);
      if (startId != null) {
        _toggleInDrag(startId);
      }
    }
    final hitId = _hitTestTile(event.position);
    if (hitId != null) _toggleInDrag(hitId);
  }

  void _handlePointerUp(PointerUpEvent event) {
    _dragStartPos = null;
    _isDragging = false;
    _dragVisitedIds.clear();
    _dragSelectMode = null;
  }

  void _toggleInDrag(int id) {
    if (_dragVisitedIds.contains(id)) return;
    _dragVisitedIds.add(id);

    final ids = widget.selectedIds;
    if (ids == null) return;

    // 첫 토글에서 모드 결정 (현재 상태의 반대)
    _dragSelectMode ??= !ids.contains(id);

    final shouldSelect = _dragSelectMode!;
    final changed = shouldSelect ? ids.add(id) : ids.remove(id);
    if (changed) {
      HapticFeedback.selectionClick();
      widget.onSelectionChanged?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 날짜별 그룹핑
    final groups = <String, List<Photo>>{};
    for (final photo in widget.photos) {
      final date = photo.timestamp.substring(0, 10); // YYYY-MM-DD
      groups.putIfAbsent(date, () => []).add(photo);
    }

    final sortedDates = groups.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // 최신순

    // 화면에 안 보이는 ID는 GlobalKey에서 GC (메모리 누수 방지)
    final liveIds = widget.photos.map((p) => p.id).toSet();
    _tileKeys.removeWhere((id, _) => !liveIds.contains(id));

    return Listener(
      // 드래그 선택 — 선택 모드일 때만 동작
      onPointerDown: _handlePointerDown,
      onPointerMove: _handlePointerMove,
      onPointerUp: _handlePointerUp,
      onPointerCancel: (_) => _handlePointerUp(
        PointerUpEvent(position: _dragStartPos ?? Offset.zero),
      ),
      child: CustomScrollView(
        // 드래그 선택 중일 땐 스크롤 차단
        physics: _isDragging
            ? const NeverScrollableScrollPhysics()
            : const AlwaysScrollableScrollPhysics(),
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
                      _dateLabel(dateStr, widget.l),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: context.text1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.l.galleryPhotos(groups[dateStr]!.length),
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
                  (context, i) {
                    final photo = groups[dateStr]![i];
                    return PhotoTile(
                      key: _keyFor(photo.id),
                      photo: photo,
                      selectMode: widget.selectMode,
                      isSelected:
                          widget.selectedIds?.contains(photo.id) ?? false,
                      onTap: () {
                        if (widget.selectMode) {
                          _toggleSingle(photo.id);
                        } else {
                          HapticFeedback.selectionClick();
                          Navigator.of(context).push(
                            SlideRightRoute(
                                page: PhotoDetailScreen(photo: photo)),
                          );
                        }
                      },
                      onLongPress: () {
                        if (widget.selectMode) {
                          // 이미 선택 모드 → 이 타일도 토글
                          _toggleSingle(photo.id);
                          return;
                        }
                        // 선택 모드 진입 + 이 타일 선택
                        HapticFeedback.mediumImpact();
                        widget.onEnterSelectMode?.call(photo.id);
                      },
                    );
                  },
                  childCount: groups[dateStr]!.length,
                ),
              ),
            ),
            const SliverPadding(padding: EdgeInsets.only(top: 24)),
          ],
        ],
      ),
    );
  }

  void _toggleSingle(int id) {
    final ids = widget.selectedIds;
    if (ids == null) return;
    HapticFeedback.selectionClick();
    if (ids.contains(id)) {
      ids.remove(id);
    } else {
      ids.add(id);
    }
    widget.onSelectionChanged?.call();
  }

  String _dateLabel(String dateStr, AppLocalizations l) {
    final now = DateTime.now();
    final today =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final yesterday = now.subtract(const Duration(days: 1));
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
    required this.onTap,
    required this.onLongPress,
  });
  final Photo photo;
  final bool selectMode;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Semantics(
      button: true,
      label: photo.isVideo ? context.l10n.cameraModeVideo : context.l10n.cameraModePhoto,
      selected: isSelected,
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          clipBehavior: Clip.hardEdge,
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
                  cacheWidth: 200, cacheHeight: 200,
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4, vertical: 2),
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
                            fontFamily: AppTheme.monoFontFamily,
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

              // 선택 모드 — 하단 어둠 + 우상단 체크마크 + 선택 시 액센트 보더
              if (selectMode) ...[
                if (isSelected)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: context.accent,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOutCubic,
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? context.accent
                          : Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? context.accent
                            : Colors.white.withValues(alpha: 0.7),
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? Icon(LucideIcons.check,
                            size: 14, color: context.onAccent)
                        : null,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
