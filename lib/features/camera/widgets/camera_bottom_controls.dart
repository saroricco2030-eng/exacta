/// Camera bottom bar - shutter/mode tabs/gallery thumb/camera switch
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:exacta/core/extensions/build_context_ext.dart';
import 'package:exacta/core/theme/app_colors.dart';
import 'package:exacta/core/theme/app_theme.dart';
import 'package:exacta/features/camera/camera_screen.dart';

// ── 하단 컨트롤 ────────────────────────────────────────────────
class CameraBottomControls extends StatelessWidget {
  const CameraBottomControls({
    super.key,
    required this.mode,
    required this.isRecording,
    required this.isTimelapsing,
    required this.isIntervalShooting,
    required this.timelapseCount,
    required this.intervalCount,
    required this.onShutter,
    required this.onSwitchCamera,
    required this.hasFrontCamera,
    required this.onModeChanged,
    this.recordingStartTime,
    this.now,
    this.lastPhotoPath,
    this.onGalleryTap,
  });

  final CameraMode mode;
  final bool isRecording;
  final bool isTimelapsing;
  final bool isIntervalShooting;
  final int timelapseCount;
  final int intervalCount;
  final DateTime? recordingStartTime;
  final DateTime? now;
  final VoidCallback onShutter;
  final VoidCallback onSwitchCamera;
  final bool hasFrontCamera;
  final ValueChanged<CameraMode> onModeChanged;
  final String? lastPhotoPath;
  final VoidCallback? onGalleryTap;

  String get _recordingDuration {
    if (recordingStartTime == null || now == null) return '00:00';
    final diff = now!.difference(recordingStartTime!);
    final m = diff.inMinutes.toString().padLeft(2, '0');
    final s = (diff.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;

    return Container(
      padding: EdgeInsets.only(
        left: 32,
        right: 32,
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 녹화 타이머
          if (isRecording)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.darkDanger,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _recordingDuration,
                    style: TextStyle(
                      fontFamily: AppTheme.monoFontFamily, // recording timer — custom 16sp Bold
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkText1,
                    ),
                  ),
                ],
              ),
            ),

          // 타임랩스 카운터
          if (isTimelapsing)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.darkAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l.cameraTimelapseRunning(timelapseCount),
                    style: TextStyle(
                      fontFamily: AppTheme.monoFontFamily, // timelapse counter — custom 14sp Bold
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkText1,
                    ),
                  ),
                ],
              ),
            ),

          // 인터벌 카운터
          if (isIntervalShooting)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.mint,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l.cameraIntervalShooting(intervalCount),
                    style: TextStyle(
                      fontFamily: AppTheme.monoFontFamily, // interval counter — custom 14sp Bold
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkText1,
                    ),
                  ),
                ],
              ),
            ),

          // 모드 전환 (사진/영상/타임랩스/인터벌)
          if (!isRecording && !isTimelapsing && !isIntervalShooting)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  _ModeTab(
                    label: l.cameraModePhoto,
                    isActive: mode == CameraMode.photo,
                    onTap: () => onModeChanged(CameraMode.photo),
                  ),
                  const SizedBox(width: 16),
                  _ModeTab(
                    label: l.cameraModeVideo,
                    isActive: mode == CameraMode.video,
                    onTap: () => onModeChanged(CameraMode.video),
                  ),
                  const SizedBox(width: 16),
                  _ModeTab(
                    label: l.cameraModeTimelapse,
                    isActive: mode == CameraMode.timelapse,
                    onTap: () => onModeChanged(CameraMode.timelapse),
                  ),
                  const SizedBox(width: 16),
                  _ModeTab(
                    label: l.cameraModeInterval,
                    isActive: mode == CameraMode.interval,
                    onTap: () => onModeChanged(CameraMode.interval),
                  ),
                ],
              ),
              ),
            ),

          // 셔터 + 좌우 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 갤러리 썸네일 — 탭하면 갤러리 열기
              GestureDetector(
                onTap: () { HapticFeedback.lightImpact(); onGalleryTap?.call(); },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Container(
                    key: ValueKey(lastPhotoPath),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.darkSurfaceHi,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.darkBorderHi, width: 2),
                      image: lastPhotoPath != null
                          ? DecorationImage(
                              image: ResizeImage(
                                FileImage(File(lastPhotoPath!)),
                                width: 96,
                                height: 96,
                              ),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: lastPhotoPath == null
                        ? const Icon(
                            LucideIcons.image,
                            size: 20,
                            color: AppColors.darkText3,
                          )
                        : null,
                  ),
                ),
              ),

              // 셔터/녹화/타임랩스 버튼 — 66dp
              Semantics(
                button: true,
                label: isRecording ? l.cameraStopRecordingLabel : l.cameraShutterLabel,
                child: GestureDetector(
                onTap: onShutter,
                child: Container(
                  width: 66,
                  height: 66,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: mode == CameraMode.video
                          ? AppColors.darkDanger
                          : mode == CameraMode.timelapse
                              ? AppColors.darkAccent
                              : mode == CameraMode.interval
                                  ? AppColors.mint
                                  : AppColors.darkText1,
                      width: 3,
                    ),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Container(
                    decoration: BoxDecoration(
                      color: mode == CameraMode.video
                          ? AppColors.darkDanger
                          : mode == CameraMode.timelapse
                              ? AppColors.darkAccent
                              : mode == CameraMode.interval
                                  ? AppColors.mint
                                  : AppColors.darkText1,
                      shape: (isRecording || isTimelapsing || isIntervalShooting)
                          ? BoxShape.rectangle
                          : BoxShape.circle,
                      borderRadius: (isRecording || isTimelapsing || isIntervalShooting)
                          ? BorderRadius.circular(8)
                          : null,
                    ),
                  ),
                ),
              ),
              ),

              // 카메라 전환
              GestureDetector(
                onTap: (hasFrontCamera && !isRecording && !isTimelapsing && !isIntervalShooting)
                    ? () { HapticFeedback.lightImpact(); onSwitchCamera(); }
                    : null,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.darkSurfaceHi,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.darkBorder),
                  ),
                  child: Icon(
                    LucideIcons.switchCamera,
                    size: 20,
                    color: (hasFrontCamera && !isRecording && !isTimelapsing && !isIntervalShooting)
                        ? AppColors.darkText2
                        : AppColors.darkText3,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── 모드 탭 (사진/영상) ────────────────────────────────────────
class _ModeTab extends StatelessWidget {
  const _ModeTab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      selected: isActive,
      child: GestureDetector(
      onTap: () { HapticFeedback.selectionClick(); onTap(); },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
              color: isActive ? AppColors.darkText1 : AppColors.darkText3,
            ),
          ),
          const SizedBox(height: 4),
          if (isActive)
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.darkAccent,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
      ),
      ),
    );
  }
}
