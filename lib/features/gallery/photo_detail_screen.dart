/// Photo/video detail - pinch zoom + video playback + share/delete + metadata/reassign
import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:video_player/video_player.dart';

import 'package:share_plus/share_plus.dart';

import 'package:exacta/core/enums.dart';
import 'package:exacta/core/extensions/build_context_ext.dart';
import 'package:exacta/core/theme/app_colors.dart';
import 'package:exacta/core/theme/app_theme.dart';
import 'package:exacta/data/database.dart';
import 'package:exacta/data/providers.dart';

class PhotoDetailScreen extends ConsumerStatefulWidget {
  const PhotoDetailScreen({super.key, required this.photo});
  final Photo photo;

  @override
  ConsumerState<PhotoDetailScreen> createState() => _PhotoDetailScreenState();
}

class _PhotoDetailScreenState extends ConsumerState<PhotoDetailScreen> {
  VideoPlayerController? _videoController;
  bool _videoInitialized = false;
  late Photo _photo;

  @override
  void initState() {
    super.initState();
    _photo = widget.photo;
    if (_photo.isVideo) {
      _initVideo();
    }
  }

  Future<void> _initVideo() async {
    final file = File(_photo.filePath);
    if (!await file.exists()) return;
    _videoController = VideoPlayerController.file(file);
    try {
      await _videoController!.initialize();
      if (mounted) setState(() => _videoInitialized = true);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _openInfoSheet() async {
    HapticFeedback.lightImpact();
    _videoController?.pause();
    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkBg,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _PhotoInfoSheet(
        photo: _photo,
        onProjectChanged: (newProjectId) async {
          await ref.read(dbProvider).updatePhoto(
                PhotosCompanion(
                  id: drift.Value(_photo.id),
                  filePath: drift.Value(_photo.filePath),
                  thumbnailPath: drift.Value(_photo.thumbnailPath),
                  presetType: drift.Value(_photo.presetType),
                  memo: drift.Value(_photo.memo),
                  tags: drift.Value(_photo.tags),
                  timestamp: drift.Value(_photo.timestamp),
                  latitude: drift.Value(_photo.latitude),
                  longitude: drift.Value(_photo.longitude),
                  address: drift.Value(_photo.address),
                  isSecure: drift.Value(_photo.isSecure),
                  isVideo: drift.Value(_photo.isVideo),
                  photoCode: drift.Value(_photo.photoCode),
                  weatherInfo: drift.Value(_photo.weatherInfo),
                  projectId: drift.Value(newProjectId),
                  createdAt: drift.Value(_photo.createdAt),
                ),
              );
          // 로컬 상태 업데이트 — 다시 열지 않아도 즉시 반영
          setState(() {
            _photo = Photo(
              id: _photo.id,
              filePath: _photo.filePath,
              thumbnailPath: _photo.thumbnailPath,
              presetType: _photo.presetType,
              memo: _photo.memo,
              tags: _photo.tags,
              timestamp: _photo.timestamp,
              latitude: _photo.latitude,
              longitude: _photo.longitude,
              address: _photo.address,
              isSecure: _photo.isSecure,
              isVideo: _photo.isVideo,
              photoCode: _photo.photoCode,
              weatherInfo: _photo.weatherInfo,
              projectId: newProjectId,
              createdAt: _photo.createdAt,
            );
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.darkBg,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // ── 콘텐츠 ──
            if (_photo.isVideo)
              _videoInitialized
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _videoController!.value.isPlaying
                              ? _videoController!.pause()
                              : _videoController!.play();
                        });
                      },
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: _videoController!.value.aspectRatio,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              VideoPlayer(_videoController!),
                              if (!_videoController!.value.isPlaying)
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: AppColors.darkBg.withValues(alpha: 0.6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(LucideIcons.play, size: 32, color: Colors.white),
                                ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(color: AppColors.darkAccent, strokeWidth: 2),
                    )
            else
              InteractiveViewer(
                minScale: 1.0,
                maxScale: 5.0,
                child: Center(
                  child: Image.file(
                    File(_photo.filePath),
                    fit: BoxFit.contain,
                    cacheWidth: 2000,
                    errorBuilder: (ctx, err, st) => Icon(
                      LucideIcons.imageOff,
                      size: 64,
                      color: AppColors.darkText3,
                    ),
                  ),
                ),
              ),

            // ── 상단 바 ──
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.paddingOf(context).top + 8,
                  left: 16,
                  right: 16,
                  bottom: 12,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.gradientBlack80, AppColors.transparent],
                  ),
                ),
                child: Row(
                  children: [
                    Semantics(
                      button: true,
                      label: 'Back',
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.darkSurface,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.darkBorder),
                          ),
                          child: const Icon(
                            LucideIcons.arrowLeft,
                            size: 18,
                            color: AppColors.darkText1,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    // ── 정보 버튼 (메타데이터 + 프로젝트 재배정) ──
                    Semantics(
                      button: true,
                      label: l.photoDetailInfo,
                      child: GestureDetector(
                        onTap: _openInfoSheet,
                        child: Container(
                          width: 44,
                          height: 44,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: AppColors.darkSurface,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.darkBorder),
                          ),
                          child: const Icon(
                            LucideIcons.info,
                            size: 18,
                            color: AppColors.darkText1,
                          ),
                        ),
                      ),
                    ),
                    if (_photo.isSecure)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.secureBg.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(LucideIcons.shieldCheck,
                                size: 12, color: AppColors.stampSecure),
                            const SizedBox(width: 4),
                            Text(
                              context.l10n.cameraSecure.toUpperCase(),
                              style: TextStyle(
                                fontFamily: AppTheme.monoFontFamily,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.stampSecure,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // ── 하단 액션 ──
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 16,
                  bottom: MediaQuery.paddingOf(context).bottom + 24,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [AppColors.gradientBlack80, AppColors.transparent],
                  ),
                ),
                child: Row(
                  children: [
                    _ActionButton(
                      icon: LucideIcons.share2,
                      label: l.commonShare,
                      onTap: () async {
                        if (await File(_photo.filePath).exists()) {
                          Share.shareXFiles([XFile(_photo.filePath)]);
                        }
                      },
                    ),
                    const SizedBox(width: 16),
                    _ActionButton(
                      icon: LucideIcons.trash2,
                      label: l.commonDelete,
                      color: AppColors.darkDanger,
                      onTap: () => _deletePhoto(context),
                    ),
                  ],
                ),
              ),
            ),

            // ── 비디오 프로그레스 바 ──
            if (_photo.isVideo && _videoInitialized)
              Positioned(
                left: 24,
                right: 24,
                bottom: MediaQuery.paddingOf(context).bottom + 90,
                child: VideoProgressIndicator(
                  _videoController!,
                  allowScrubbing: true,
                  colors: const VideoProgressColors(
                    playedColor: AppColors.darkAccent,
                    bufferedColor: AppColors.darkSurfaceHi,
                    backgroundColor: AppColors.darkBorder,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _deletePhoto(BuildContext context) async {
    final l = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurfaceHi,
        title: Text(l.commonDelete,
            style: const TextStyle(color: AppColors.darkText1)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style:
                TextButton.styleFrom(foregroundColor: AppColors.darkDanger),
            child: Text(l.commonDelete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      _videoController?.pause();
      final file = File(_photo.filePath);
      if (await file.exists()) await file.delete();
      if (_photo.thumbnailPath != null) {
        final thumb = File(_photo.thumbnailPath!);
        if (await thumb.exists()) await thumb.delete();
      }
      await ref.read(dbProvider).deletePhoto(_photo.id);
      if (context.mounted) Navigator.of(context).pop();
    }
  }
}

// ── 메타 정보 바텀시트 ────────────────────────────────────────
class _PhotoInfoSheet extends ConsumerStatefulWidget {
  const _PhotoInfoSheet({
    required this.photo,
    required this.onProjectChanged,
  });

  final Photo photo;
  final Future<void> Function(int? newProjectId) onProjectChanged;

  @override
  ConsumerState<_PhotoInfoSheet> createState() => _PhotoInfoSheetState();
}

class _PhotoInfoSheetState extends ConsumerState<_PhotoInfoSheet> {
  List<Project> _projects = [];
  int? _currentProjectId;
  String? _currentProjectName;
  String? _currentProjectColor;

  @override
  void initState() {
    super.initState();
    _currentProjectId = widget.photo.projectId;
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    final all = await AppDatabase.instance.getAllProjects();
    Project? current;
    if (_currentProjectId != null) {
      try {
        current = all.firstWhere((p) => p.id == _currentProjectId);
      } catch (_) {
        current = null;
      }
    }
    if (mounted) {
      setState(() {
        _projects = all.where((p) => p.status == ProjectStatus.active.value).toList();
        _currentProjectName = current?.name;
        _currentProjectColor = current?.color;
      });
    }
  }

  Future<bool?> _confirmChange(String message) async {
    final l = context.l10n;
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurfaceHi,
        title: Text(l.photoDetailChangeProject,
            style: const TextStyle(color: AppColors.darkText1)),
        content: Text(message,
            style: const TextStyle(color: AppColors.darkText2)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.darkAccent),
            child: Text(l.commonSave),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    final y = dt.year.toString().padLeft(4, '0');
    final mo = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final mi = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    return '$y.$mo.$d  $h:$mi:$s';
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final photo = widget.photo;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 드래그 핸들
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 16),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.darkBorderHi,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // 타이틀
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                l.photoDetailInfo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkText1,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── 프로젝트 (배정 + 변경) ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                l.photoDetailProject,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkText3,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _projects.length + 1,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (ctx, i) {
                  if (i == 0) {
                    final isActive = _currentProjectId == null;
                    return _ProjectChip(
                      label: l.photoDetailNoProject,
                      isActive: isActive,
                      color: null,
                      onTap: () async {
                        if (_currentProjectId == null) return;
                        // M4: 재배정 확인
                        final ok = await _confirmChange(
                            l.photoDetailClearProjectConfirm);
                        if (ok != true) return;
                        await widget.onProjectChanged(null);
                        if (mounted) {
                          setState(() {
                            _currentProjectId = null;
                            _currentProjectName = null;
                            _currentProjectColor = null;
                          });
                          HapticFeedback.lightImpact();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l.photoProjectChanged),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                    );
                  }
                  final project = _projects[i - 1];
                  final isActive = _currentProjectId == project.id;
                  return _ProjectChip(
                    label: project.name,
                    isActive: isActive,
                    color: project.color,
                    onTap: () async {
                      if (_currentProjectId == project.id) return;
                      // M4: 재배정 확인
                      final ok = await _confirmChange(
                          l.photoDetailChangeConfirm(project.name));
                      if (ok != true) return;
                      await widget.onProjectChanged(project.id);
                      if (mounted) {
                        setState(() {
                          _currentProjectId = project.id;
                          _currentProjectName = project.name;
                          _currentProjectColor = project.color;
                        });
                        HapticFeedback.lightImpact();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l.photoProjectChanged),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // ── 메타 필드 ──
            _InfoRow(
              icon: LucideIcons.clock,
              label: l.photoDetailTimestamp,
              value: _formatTimestamp(photo.timestamp),
            ),
            // C1: 보안 사진은 address/GPS를 절대 표시 금지 (프라이버시)
            if (!photo.isSecure &&
                photo.address != null &&
                photo.address!.isNotEmpty)
              _InfoRow(
                icon: LucideIcons.mapPin,
                label: l.photoDetailAddress,
                value: photo.address!,
              ),
            if (!photo.isSecure &&
                photo.latitude != null &&
                photo.longitude != null)
              _InfoRow(
                icon: LucideIcons.satellite,
                label: l.photoDetailGps,
                value:
                    '${photo.latitude!.toStringAsFixed(5)}, ${photo.longitude!.toStringAsFixed(5)}',
                mono: true,
              ),
            if (photo.memo != null && photo.memo!.isNotEmpty)
              _InfoRow(
                icon: LucideIcons.fileText,
                label: l.photoDetailMemo,
                value: photo.memo!,
              ),
            if (photo.tags != null && photo.tags!.isNotEmpty)
              _InfoRow(
                icon: LucideIcons.tag,
                label: l.photoDetailTags,
                value: photo.tags!,
              ),
            if (photo.weatherInfo != null && photo.weatherInfo!.isNotEmpty)
              _InfoRow(
                icon: LucideIcons.cloudSun,
                label: l.photoDetailWeather,
                value: photo.weatherInfo!,
              ),
            if (photo.photoCode != null && photo.photoCode!.isNotEmpty)
              _InfoRow(
                icon: LucideIcons.hash,
                label: l.photoDetailCode,
                value: photo.photoCode!,
                mono: true,
              ),
            if (_currentProjectName != null)
              _InfoRow(
                icon: LucideIcons.folderOpen,
                label: l.photoDetailProject,
                value: _currentProjectName!,
                dotColor: _currentProjectColor,
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ProjectChip extends StatelessWidget {
  const _ProjectChip({
    required this.label,
    required this.isActive,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final String? color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = color != null
        ? Color(int.parse(color!.replaceFirst('#', '0xFF')))
        : AppColors.darkAccent;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive
              ? c.withValues(alpha: 0.15)
              : AppColors.darkSurfaceHi,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? c.withValues(alpha: 0.5) : AppColors.darkBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (color != null) ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: c, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? c : AppColors.darkText2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.mono = false,
    this.dotColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool mono;
  final String? dotColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.darkText3),
          const SizedBox(width: 12),
          SizedBox(
            width: 88,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.darkText3,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                if (dotColor != null) ...[
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Color(int.parse(dotColor!.replaceFirst('#', '0xFF'))),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontFamily: mono ? AppTheme.monoFontFamily : null,
                      fontSize: 13,
                      color: AppColors.darkText1,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.darkText2;
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16, color: c),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(fontSize: 13, color: c),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
