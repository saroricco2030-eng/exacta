/// Gallery - project filter + search + multi-select bulk delete
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:exacta/core/extensions/build_context_ext.dart';
import 'package:exacta/data/database.dart';
import 'package:exacta/data/providers.dart';
import 'package:exacta/features/gallery/widgets/gallery_filter_chip.dart';
import 'package:exacta/features/gallery/widgets/gallery_states.dart';
import 'package:exacta/features/gallery/widgets/gallery_loaded.dart';

class GalleryScreen extends ConsumerStatefulWidget {
  const GalleryScreen({super.key});

  @override
  ConsumerState<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends ConsumerState<GalleryScreen> {
  int? _selectedProjectId;
  bool _showSearch = false;
  bool _selectMode = false;
  final Set<int> _selectedIds = {};
  final _searchController = TextEditingController();
  List<Photo>? _searchResults;
  Timer? _searchDebounce;

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebounce?.cancel();
    _searchDebounce = null;
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // M3: 300ms debounce — 매 글자 DB 쿼리 방지
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      if (mounted) setState(() => _searchResults = null);
      return;
    }
    try {
      final results = await AppDatabase.instance.searchPhotos(query.trim());
      if (mounted) setState(() => _searchResults = results);
    } catch (e) {
      debugPrint('searchPhotos failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final photosAsync = ref.watch(photosByProjectProvider(_selectedProjectId));
    final projectsAsync = ref.watch(allProjectsProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 헤더 ──
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                children: [
                  Text(
                    l.galleryTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Spacer(),
                  // 전체 선택 / 해제 버튼 (선택 모드일 때만)
                  if (_selectMode && !_showSearch)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Semantics(
                        button: true,
                        label: l.commonSelectAll,
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            _toggleSelectAll(photosAsync.valueOrNull);
                          },
                          child: Container(
                            width: 56, height: 56,
                            decoration: BoxDecoration(
                              color: context.surfaceHi,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              LucideIcons.copyCheck,
                              size: 20,
                              color: context.text2,
                            ),
                          ),
                        ),
                      ),
                    ),

                  // 선택 모드 토글
                  if (!_showSearch)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Semantics(
                        button: true,
                        label: l.commonSelect,
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            setState(() {
                              _selectMode = !_selectMode;
                              _selectedIds.clear();
                            });
                          },
                          child: Container(
                            width: 56, height: 56,
                            decoration: BoxDecoration(
                              color: _selectMode ? context.accentDim : context.surfaceHi,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              _selectMode ? LucideIcons.x : LucideIcons.squareCheck,
                              size: 20,
                              color: _selectMode ? context.accent : context.text2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  // 검색 토글
                  Semantics(
                    button: true,
                    label: l.projectsSearch,
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        setState(() {
                          _showSearch = !_showSearch;
                          if (!_showSearch) {
                            _searchController.clear();
                            _searchResults = null;
                          }
                        });
                      },
                      child: Container(
                        width: 56, height: 56,
                        decoration: BoxDecoration(
                          color: _showSearch ? context.accentDim : context.surfaceHi,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          _showSearch ? LucideIcons.x : LucideIcons.search,
                          size: 20,
                          color: _showSearch ? context.accent : context.text2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── 검색 바 ──
            if (_showSearch)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  style: TextStyle(fontSize: 14, color: context.text1),
                  decoration: InputDecoration(
                    hintText: l.commonSearch,
                    prefixIcon: Icon(LucideIcons.search, size: 18, color: context.text3),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // ── 프로젝트 필터 칩 (검색 모드가 아닐 때만) ──
            if (!_showSearch) ...[
              SizedBox(
                height: 44,
                child: projectsAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (e, st) => const SizedBox.shrink(),
                  data: (projects) {
                    // 대원칙 1: SSoT — 선택된 projectId가 실제 목록에 없으면 자동 리셋
                    // (예: 다른 화면에서 프로젝트가 삭제된 경우)
                    if (_selectedProjectId != null &&
                        _selectedProjectId != -1 &&
                        !projects.any((p) => p.id == _selectedProjectId)) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) setState(() => _selectedProjectId = null);
                      });
                    }

                    // 칩 구성: [전체] + [미지정] + 각 프로젝트
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: projects.length + 2,
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return GalleryFilterChip(
                            label: l.commonAll,
                            isActive: _selectedProjectId == null,
                            onTap: () => setState(() => _selectedProjectId = null),
                          );
                        }
                        if (index == 1) {
                          return GalleryFilterChip(
                            label: l.galleryNoProjectFilter,
                            isActive: _selectedProjectId == -1,
                            onTap: () => setState(() => _selectedProjectId = -1),
                          );
                        }
                        final project = projects[index - 2];
                        return GalleryFilterChip(
                          label: project.name,
                          isActive: _selectedProjectId == project.id,
                          color: _parseColor(project.color, context),
                          onTap: () => setState(() => _selectedProjectId = project.id),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],

            // ── 일괄 삭제 바 ──
            if (_selectMode && _selectedIds.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Material(
                    color: context.danger,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => _bulkDelete(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(LucideIcons.trash2, size: 18, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            '${l.commonDelete} (${_selectedIds.length})',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // ── 사진 목록 ──
            Expanded(
              child: _searchResults != null
                  ? _searchResults!.isEmpty
                      ? GalleryEmpty(l: l)
                      : GalleryLoaded(
                          photos: _searchResults!,
                          l: l,
                          selectMode: _selectMode,
                          selectedIds: _selectedIds,
                          onSelectionChanged: () => setState(() {}),
                          onEnterSelectMode: _enterSelectMode,
                        )
                  : photosAsync.when(
                      loading: () => const GalleryLoading(),
                      error: (e, _) => GalleryError(
                        l: l,
                        onRetry: () => ref.invalidate(photosByProjectProvider(_selectedProjectId)),
                      ),
                      data: (photos) {
                        if (photos.isEmpty) return GalleryEmpty(l: l);
                        return GalleryLoaded(
                          photos: photos,
                          l: l,
                          selectMode: _selectMode,
                          selectedIds: _selectedIds,
                          onSelectionChanged: () => setState(() {}),
                          onEnterSelectMode: _enterSelectMode,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// 사진 위에서 long-press → 선택 모드 진입 + 첫 ID 자동 선택
  void _enterSelectMode(int firstSelectedId) {
    setState(() {
      _selectMode = true;
      _selectedIds
        ..clear()
        ..add(firstSelectedId);
    });
  }

  /// 전체 선택 / 해제 토글 — 현재 화면에 보이는 사진 전체 대상
  void _toggleSelectAll(List<Photo>? photos) {
    if (photos == null || photos.isEmpty) return;
    setState(() {
      final allIds = photos.map((p) => p.id).toSet();
      // 이미 전체가 선택된 상태면 해제
      if (_selectedIds.containsAll(allIds) && _selectedIds.length == allIds.length) {
        _selectedIds.clear();
      } else {
        _selectedIds
          ..clear()
          ..addAll(allIds);
      }
    });
  }

  Future<void> _bulkDelete(BuildContext context) async {
    final l = context.l10n;
    final count = _selectedIds.length;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(LucideIcons.triangleAlert, size: 20, color: ctx.danger),
            const SizedBox(width: 8),
            Expanded(child: Text(l.galleryDeleteConfirmTitle)),
          ],
        ),
        content: Text(
          l.galleryDeleteConfirmMessage(count),
          style: const TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.commonCancel),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.pop(ctx, true),
            icon: const Icon(LucideIcons.trash2, size: 16),
            label: Text(l.commonDelete),
            style: FilledButton.styleFrom(
              backgroundColor: ctx.danger,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    HapticFeedback.mediumImpact();
    final db = ref.read(dbProvider);
    final ids = _selectedIds.toList();

    // 1단계: 즉시 갤러리에서 숨김 (DB 임시 boolean이 아닌 SnackBar 지연)
    if (mounted) {
      setState(() {
        _selectedIds.clear();
        _selectMode = false;
      });
    }

    // 2단계: 3초 Undo SnackBar — Undo 누르면 삭제 취소
    bool undone = false;
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(l.galleryDeleteConfirmMessage(count)),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: l.commonUndo,
          onPressed: () {
            undone = true;
            HapticFeedback.lightImpact();
          },
        ),
      ),
    );

    // 3단계: 3.5초 후 실제 삭제 (Undo 시간 부여)
    await Future.delayed(const Duration(milliseconds: 3500));
    if (undone) return;

    // 파일-DB 동기 삭제 — 1 쿼리 + 병렬 파일 삭제
    final list = await db.getPhotosByIds(ids);
    await Future.wait(list.map((photo) async {
      try {
        final file = File(photo.filePath);
        if (await file.exists()) await file.delete();
        if (photo.thumbnailPath != null) {
          final thumb = File(photo.thumbnailPath!);
          if (await thumb.exists()) await thumb.delete();
        }
        // v13: 원본 사진 cascade 삭제
        if (photo.originalPath != null) {
          final original = File(photo.originalPath!);
          if (await original.exists()) await original.delete();
        }
      } catch (e) {
        debugPrint('Bulk delete file failed (${photo.filePath}): $e');
      }
    }));
    await db.deletePhotosByIds(ids);
  }

  Color _parseColor(String? hex, BuildContext context) => context.parseHexColor(hex);
}
