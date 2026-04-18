/// Project card with color stripe, thumbnails, status pill, delete action
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:exacta/core/enums.dart';
import 'package:exacta/core/extensions/build_context_ext.dart';
import 'package:exacta/core/safe_parse.dart';
import 'package:exacta/data/database.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
    required this.onToggleStatus,
    required this.onDelete,
    this.photoCount = 0,
    this.thumbnails = const [],
  });

  final Project project;
  final VoidCallback onTap;
  final VoidCallback onToggleStatus;
  final VoidCallback onDelete;
  final int photoCount;
  final List<Photo> thumbnails;

  Color _projectColor(BuildContext context) =>
      context.parseHexColor(project.color);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final isDone = project.status == ProjectStatus.done.value;

    return Material(
      color: context.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 상단 컬러 스트라이프
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: isDone ? context.text3 : _projectColor(context),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                ),
              ),
              // 썸네일 행 (사진이 있을 때만)
              if (thumbnails.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: SizedBox(
                    height: 56,
                    child: Row(
                      children: [
                        for (var i = 0; i < thumbnails.length && i < 4; i++) ...[
                          if (i > 0) const SizedBox(width: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 56, height: 56,
                              child: Image.file(
                                File(thumbnails[i].filePath),
                                fit: BoxFit.cover,
                                cacheWidth: 120, cacheHeight: 120,
                                errorBuilder: (_, _, _) => Container(color: context.surfaceHi),
                              ),
                            ),
                          ),
                        ],
                        if (photoCount > thumbnails.length) ...[
                          const SizedBox(width: 4),
                          Container(
                            width: 56, height: 56,
                            decoration: BoxDecoration(
                              color: context.surfaceHi,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text('+${photoCount - thumbnails.length}',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.text3)),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
                child: Row(
                  children: [
                    // 프로젝트 아이콘 — 활성 시 프로젝트 컬러, 완료 시 회색
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isDone
                            ? context.text3.withValues(alpha: 0.08)
                            : _projectColor(context).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDone
                              ? context.text3.withValues(alpha: 0.15)
                              : _projectColor(context).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Icon(
                        isDone ? LucideIcons.folderCheck : LucideIcons.folderOpen,
                        size: 18,
                        color: isDone ? context.text3 : _projectColor(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // 이름 + 날짜 + 사진 수
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isDone ? context.text3 : context.text1,
                              decoration:
                                  isDone ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              if (project.startDate != null) ...[
                                Text(
                                  SafeParse.substringOr(project.startDate, 0, 10),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: context.text3,
                                  ),
                                ),
                                if (photoCount > 0)
                                  Text(
                                    '  ·  ',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: context.text3,
                                    ),
                                  ),
                              ],
                              if (photoCount > 0)
                                Text(
                                  l.projectsPhotoCount(photoCount),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: context.text3,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // ── 상태 변경 Pill 버튼 (레이블 포함 — 삭제와 명확히 구분) ──
                    _StatusPill(
                      isDone: isDone,
                      label: isDone ? l.projectsMarkActive : l.projectsMarkDone,
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        onToggleStatus();
                      },
                    ),
                    const SizedBox(width: 4),

                    // ── 삭제 버튼 (아이콘만, 56dp 터치 타겟) ──
                    Semantics(
                      button: true,
                      label: l.commonDelete,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          onDelete();
                        },
                        child: SizedBox(
                          width: 48,
                          height: 56,
                          child: Center(
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: context.danger.withValues(alpha: 0.08),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                LucideIcons.trash2,
                                size: 16,
                                color: context.danger.withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 상태 변경 pill — 텍스트 레이블로 삭제 버튼과 명확히 구분
class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.isDone,
    required this.label,
    required this.onTap,
  });

  final bool isDone;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = isDone ? context.accent : context.success;
    final bg = isDone
        ? context.accent.withValues(alpha: 0.10)
        : context.success.withValues(alpha: 0.10);
    final border = isDone
        ? context.accent.withValues(alpha: 0.25)
        : context.success.withValues(alpha: 0.25);

    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          height: 56,
          child: Center(
            child: Container(
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(17),
                border: Border.all(color: border, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isDone ? LucideIcons.rotateCcw : LucideIcons.check,
                    size: 13,
                    color: fg,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: fg,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
