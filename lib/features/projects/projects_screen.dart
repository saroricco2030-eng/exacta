/// Projects list - active/done filter, CRUD operations with Undo + cascade delete
import 'dart:io';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:exacta/core/enums.dart';
import 'package:exacta/core/extensions/build_context_ext.dart';
import 'package:exacta/core/transitions.dart';
import 'package:exacta/data/database.dart';
import 'package:exacta/data/providers.dart';
import 'package:exacta/features/projects/project_form_sheet.dart';
import 'package:exacta/features/projects/widgets/project_filter_tab.dart';
import 'package:exacta/features/projects/widgets/project_card.dart';
import 'package:exacta/features/projects/widgets/projects_empty.dart';

class ProjectsScreen extends ConsumerStatefulWidget {
  const ProjectsScreen({super.key});

  @override
  ConsumerState<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends ConsumerState<ProjectsScreen> {
  ProjectStatus _filter = ProjectStatus.active;
  // C10: 동시 편집/삭제 방지 — 현재 작업 중인 프로젝트 id
  final Set<int> _busyProjectIds = <int>{};

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final projectsAsync = _filter == ProjectStatus.active
        ? ref.watch(activeProjectsProvider)
        : ref.watch(allProjectsProvider);

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
                    l.projectsTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Spacer(),
                  // 새 프로젝트 버튼 — 56dp 터치 타겟
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: Material(
                      color: context.accentDim,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => _showProjectForm(context),
                        child: Icon(
                          LucideIcons.plus,
                          color: context.accent,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── 필터 탭 ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  ProjectFilterTab(
                    label: l.projectsActive,
                    isActive: _filter == ProjectStatus.active,
                    onTap: () => setState(() => _filter = ProjectStatus.active),
                  ),
                  const SizedBox(width: 8),
                  ProjectFilterTab(
                    label: l.projectsDone,
                    isActive: _filter == ProjectStatus.done,
                    onTap: () => setState(() => _filter = ProjectStatus.done),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── 프로젝트 목록 ──
            Expanded(
              child: projectsAsync.when(
                loading: () => Center(
                  child: CircularProgressIndicator(
                    color: context.accent,
                    strokeWidth: 2,
                  ),
                ),
                error: (e, _) => Center(
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
                          onPressed: () {
                            ref.invalidate(activeProjectsProvider);
                            ref.invalidate(allProjectsProvider);
                          },
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
                ),
                data: (projects) {
                  final filtered = _filter == ProjectStatus.done
                      ? projects
                          .where((p) => p.status == ProjectStatus.done.value)
                          .toList()
                      : projects;

                  if (filtered.isEmpty) {
                    return ProjectsEmpty(
                      l: l,
                      onCreateTap: () => _showProjectForm(context),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 8),
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final project = filtered[index];
                      final db = ref.read(dbProvider);
                      return FutureBuilder<(int, List<Photo>)>(
                        future: Future.wait([
                          db.getPhotoCountByProject(project.id),
                          db.getProjectThumbnails(project.id),
                        ]).then((r) => (r[0] as int, r[1] as List<Photo>)),
                        builder: (ctx, snap) => ProjectCard(
                          project: project,
                          photoCount: snap.data?.$1 ?? 0,
                          thumbnails: snap.data?.$2 ?? const [],
                          onTap: () =>
                              _showProjectForm(context, project: project),
                          onToggleStatus: () => _toggleStatus(project),
                          onDelete: () => _deleteProject(project),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProjectForm(BuildContext context, {Project? project}) {
    Navigator.of(context).push(
      SlideUpRoute(page: ProjectFormSheet(project: project)),
    );
  }

  Future<void> _toggleStatus(Project project) async {
    // C10: 동시 편집/삭제 중이면 무시
    if (_busyProjectIds.contains(project.id)) return;
    _busyProjectIds.add(project.id);

    final db = ref.read(dbProvider);
    final wasDone = project.status == ProjectStatus.done.value;
    final newStatus = wasDone ? ProjectStatus.active.value : ProjectStatus.done.value;
    final l = context.l10n;

    try {
      await db.updateProject(
        ProjectsCompanion(
          id: Value(project.id),
          name: Value(project.name),
          color: Value(project.color),
          startDate: Value(project.startDate),
          endDate: Value(newStatus == ProjectStatus.done.value
              ? DateTime.now().toIso8601String()
              : null),
          status: Value(newStatus),
          createdAt: Value(project.createdAt),
          updatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );
    } catch (e) {
      debugPrint('Toggle status failed: $e');
      _busyProjectIds.remove(project.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.updateError),
            backgroundColor: context.danger,
            duration: const Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    _busyProjectIds.remove(project.id);
    if (!mounted) return;
    HapticFeedback.mediumImpact();

    final message = wasDone
        ? l.projectsMovedToActive(project.name)
        : l.projectsMovedToDone(project.name);

    // Undo SnackBar — 이전 상태로 되돌릴 수 있도록 3초 노출
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: l.commonUndo,
          onPressed: () async {
            if (_busyProjectIds.contains(project.id)) return;
            _busyProjectIds.add(project.id);
            try {
              await db.updateProject(
                ProjectsCompanion(
                  id: Value(project.id),
                  name: Value(project.name),
                  color: Value(project.color),
                  startDate: Value(project.startDate),
                  endDate: Value(project.endDate),
                  status: Value(project.status),
                  createdAt: Value(project.createdAt),
                  updatedAt: Value(DateTime.now().toIso8601String()),
                ),
              );
              HapticFeedback.lightImpact();
            } catch (e) {
              debugPrint('Undo failed: $e');
            } finally {
              _busyProjectIds.remove(project.id);
            }
          },
        ),
      ),
    );
  }

  Future<void> _deleteProject(Project project) async {
    // C10: 동시 편집/삭제 방지
    if (_busyProjectIds.contains(project.id)) return;

    final l = context.l10n;
    final db = ref.read(dbProvider);

    // 1. 연결된 사진 수 조회 — 사용자에게 고지
    final int photoCount;
    try {
      photoCount = await db.getPhotoCountByProject(project.id);
    } catch (e) {
      debugPrint('getPhotoCountByProject failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.deleteError),
            backgroundColor: context.danger,
            duration: const Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    if (!mounted) return;

    // 2. 선택지 포함 다이얼로그
    //    사진 0장 : 단순 확인 (프로젝트만 삭제)
    //    사진 1장+: 프로젝트 유지(기본) vs 함께 삭제 선택
    final choice = await showDialog<_DeleteChoice>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.surface,
        title: Text(l.commonDelete),
        content: Text(
          photoCount == 0
              ? l.projectsDeleteConfirm(project.name)
              : l.projectsDeleteWithCount(project.name, photoCount),
        ),
        actionsOverflowDirection: VerticalDirection.down,
        actionsOverflowAlignment: OverflowBarAlignment.end,
        actionsOverflowButtonSpacing: 8,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, _DeleteChoice.cancel),
            child: Text(l.commonCancel),
          ),
          if (photoCount > 0)
            TextButton(
              onPressed: () => Navigator.pop(ctx, _DeleteChoice.keepPhotos),
              child: Text(l.projectsDeleteKeepPhotos),
            ),
          TextButton(
            onPressed: () => Navigator.pop(
              ctx,
              photoCount > 0 ? _DeleteChoice.cascade : _DeleteChoice.keepPhotos,
            ),
            style: TextButton.styleFrom(foregroundColor: ctx.danger),
            child: Text(
              photoCount > 0 ? l.projectsDeleteWithPhotos : l.commonDelete,
            ),
          ),
        ],
      ),
    );

    if (choice == null || choice == _DeleteChoice.cancel) return;

    _busyProjectIds.add(project.id);
    try {
      // 3. cascade 인 경우 실제 파일 먼저 삭제 (DB 삭제 전)
      if (choice == _DeleteChoice.cascade) {
        final photos = await db.getPhotosByProject(project.id);
        for (final photo in photos) {
          try {
            final file = File(photo.filePath);
            if (await file.exists()) await file.delete();
            if (photo.thumbnailPath != null) {
              final thumb = File(photo.thumbnailPath!);
              if (await thumb.exists()) await thumb.delete();
            }
          } catch (_) {
            // 개별 파일 삭제 실패는 무시 — DB는 삭제 계속 진행
          }
        }
        await db.deleteProjectCascade(project.id);

        // M24: 빈 project_{id}/ 폴더 정리
        try {
          final appDir = await getApplicationDocumentsDirectory();
          final photoProjectDir = Directory(p.join(appDir.path, 'photos', 'project_${project.id}'));
          if (await photoProjectDir.exists()) {
            await photoProjectDir.delete(recursive: true);
          }
          final videoProjectDir = Directory(p.join(appDir.path, 'videos', 'project_${project.id}'));
          if (await videoProjectDir.exists()) {
            await videoProjectDir.delete(recursive: true);
          }
        } catch (e) {
          debugPrint('Failed to cleanup project folder: $e');
        }
      } else {
        await db.deleteProject(project.id);
      }

      if (mounted) {
        HapticFeedback.mediumImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.commonDeleteSuccess),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      debugPrint('Delete project failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.deleteError),
            backgroundColor: context.danger,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      _busyProjectIds.remove(project.id);
    }
  }
}

enum _DeleteChoice { cancel, keepPhotos, cascade }
