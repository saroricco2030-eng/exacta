/// Camera main screen - photo/video/timelapse/interval modes
/// Lifecycle-aware, ValueNotifier for partial rebuilds
import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:exacta/core/extensions/build_context_ext.dart';
import 'package:exacta/core/safe_parse.dart';
import 'package:exacta/l10n/generated/app_localizations.dart';
import 'package:exacta/core/theme/app_colors.dart';
import 'package:exacta/features/camera/stamp_overlay.dart';
import 'package:exacta/features/camera/stamp_edit_sheet.dart';
import 'package:exacta/features/camera/widgets/camera_top_bar.dart';
import 'package:exacta/features/camera/widgets/camera_bottom_controls.dart';
import 'package:exacta/features/camera/controllers/location_service.dart';
import 'package:exacta/features/camera/controllers/auto_capture_controller.dart';
import 'package:exacta/data/database.dart';
import 'package:exacta/services/photo_save_service.dart';
import 'package:exacta/services/ntp_service.dart';
import 'package:exacta/services/weather_service.dart';

enum CameraPreset { construction, secure }
enum CameraMode { photo, video, timelapse, interval }

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key, this.initialProjectId});

  final int? initialProjectId;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isInitialized = false;
  bool _hasError = false;
  bool _isPermissionGranted = false;
  bool _isInitializing = false;
  bool _requestingPermission = false;
  int _selectedCameraIndex = 0;

  // ── 모드 ──
  CameraMode _mode = CameraMode.photo;
  bool _isRecording = false;
  DateTime? _recordingStartTime;

  // ── 프리셋 ──
  CameraPreset _preset = CameraPreset.construction;

  // ── 스탬프 상태 ──
  bool _showTime = true;
  bool _showDate = true;
  bool _showAddress = true;
  bool _showGps = true;
  String _memo = '';
  String _tags = '';

  // ── 오버레이 토글 ──
  bool _showCompass = false;
  bool _showAltitude = false;
  bool _showSpeed = false;

  // ── 시간 (ValueNotifier — setState 없이 시간만 업데이트) ──
  Timer? _clockTimer;
  final ValueNotifier<DateTime> _nowNotifier = ValueNotifier(DateTime.now());

  // ── 플래시 ──
  FlashMode _flashMode = FlashMode.off;

  // ── 프로젝트 ──
  int? _selectedProjectId;
  String? _selectedProjectName;

  // ── 저장 서비스 ──
  late final PhotoSaveService _saveService;

  // ── 촬영 중 잠금 ──
  bool _isSaving = false;

  // ── 셔터 피드백 ──
  bool _showShutterFlash = false;
  Timer? _shutterFlashTimer;
  String? _lastPhotoPath;
  DateTime _lastShutterTime = DateTime(2000);

  // ── Wow 모먼트: 촬영 직후 증거 배지 ──
  bool _showCaptureBadge = false;
  Timer? _captureBadgeTimer;

  // ── 스탬프 master on/off ──
  bool _stampEnabled = true;

  // ── 탭 투 포커스 ──
  Offset? _focusPoint; // 화면 상 탭 지점 (px)
  Timer? _focusIndicatorTimer;

  // ── 설정 ──
  StampConfig? _stampConfig;

  // ── 추출된 서비스/컨트롤러 ──
  final LocationService _locationService = LocationService();
  final AutoCaptureController _autoCaptureController = AutoCaptureController();

  // ── 위치 업데이트용 ValueNotifier — 전체 리빌드 없이 스탬프만 갱신 ──
  final ValueNotifier<int> _locationVersion = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _selectedProjectId = widget.initialProjectId;
    _saveService = PhotoSaveService(AppDatabase.instance);
    _loadSettings();
    _loadProjectName();
    _initCamera();
    _startClock();
    _locationService.isSecureMode = () => _preset == CameraPreset.secure;
    _locationService.isMounted = () => mounted;
  }

  Future<void> _loadSettings() async {
    final config = await AppDatabase.instance.getStampConfig();
    if (mounted) setState(() => _stampConfig = config);
  }

  Future<void> _loadProjectName() async {
    if (_selectedProjectId == null) {
      if (mounted) setState(() => _selectedProjectName = null);
      return;
    }
    final project = await AppDatabase.instance.getProjectById(_selectedProjectId!);
    if (!mounted) return;
    // 대원칙 2: FK 정합성 — 프로젝트가 삭제됐거나 완료 상태면 선택 해제
    if (project == null) {
      setState(() {
        _selectedProjectId = null;
        _selectedProjectName = null;
      });
      return;
    }
    setState(() => _selectedProjectName = project.name);
  }

  /// M23: locale별 요일 축약명 반환
  List<String> _weekdayNames(String locale) {
    return switch (locale) {
      'ko' => const ['월', '화', '수', '목', '금', '토', '일'],
      'ja' => const ['月', '火', '水', '木', '金', '土', '日'],
      _ => const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    };
  }

  /// 촬영 직전 프로젝트 유효성 재검증 — DB에 존재하는지 최종 확인.
  /// 반환값: 사용할 projectId (유효하면 원본, 아니면 null)
  Future<int?> _validateProjectId(int? projectId) async {
    if (projectId == null) return null;
    final project = await AppDatabase.instance.getProjectById(projectId);
    if (project == null) {
      // 이미 삭제된 프로젝트 — UI 상태도 클리어
      if (mounted) {
        setState(() {
          _selectedProjectId = null;
          _selectedProjectName = null;
        });
      }
      return null;
    }
    return projectId;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    _clockTimer?.cancel();
    _shutterFlashTimer?.cancel();
    _captureBadgeTimer?.cancel();
    _focusIndicatorTimer?.cancel();
    _nowNotifier.dispose();
    _locationVersion.dispose();
    _locationService.stop();
    _autoCaptureController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 권한 다이얼로그 표시 중에는 모든 lifecycle 이벤트 무시
    if (_requestingPermission) return;

    if (state == AppLifecycleState.paused) {
      _controller?.dispose();
      _controller = null;
      if (mounted) setState(() => _isInitialized = false);
    } else if (state == AppLifecycleState.resumed) {
      if (_isInitializing) return;
      // 백그라운드 동안 권한이 회수됐을 가능성 — 권한 재검증 후 복구
      _verifyPermissionAndResume();
    }
  }

  /// 백그라운드에서 권한이 회수된 경우 감지 — 회수됐으면 에러 화면, 살아있으면 카메라 복구
  Future<void> _verifyPermissionAndResume() async {
    final cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      // 사용자가 설정에서 권한 회수 → 이전 컨트롤러 정리 + 에러 표시
      await _controller?.dispose();
      _controller = null;
      if (mounted) setState(() {
        _isInitialized = false;
        _hasError = true;
      });
      return;
    }
    // 권한 OK → 컨트롤러가 없거나 초기화 안 됐으면 복구
    if (_controller == null || !_isInitialized) {
      _resumeCamera();
    }
  }

  Future<void> _initCamera() async {
    if (_isInitializing) return;
    _isInitializing = true;
    try {
      // 권한 요청 중 lifecycle 이벤트 차단 — 한 번에 모든 권한 요청
      _requestingPermission = true;
      final statuses = await [
        Permission.camera,
        Permission.microphone,
        Permission.location,
      ].request();
      _requestingPermission = false;

      if (statuses[Permission.camera]?.isGranted != true) {
        debugPrint('Camera permission denied');
        if (mounted) setState(() => _hasError = true);
        return;
      }
      _isPermissionGranted = true;

      // M19: 부분 권한 거부 피드백 (마이크/위치)
      final micDenied = statuses[Permission.microphone]?.isGranted != true;
      final locDenied = statuses[Permission.location]?.isGranted != true;
      if ((micDenied || locDenied) && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.permissionPartial),
                backgroundColor: AppColors.darkSurfaceHi,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        });
      }

      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        if (mounted) setState(() => _hasError = true);
        return;
      }
      await _setupController(_cameras[_selectedCameraIndex]);

      // 카메라 권한 완료 후 위치 서비스 시작 (권한 충돌 방지)
      _locationService.start(_onLocationUpdated);
    } catch (e) {
      if (mounted) setState(() => _hasError = true);
    } finally {
      _requestingPermission = false;
      _isInitializing = false;
    }
  }

  /// 백그라운드 복귀 시 — 권한 재요청 없이 카메라만 재설정
  Future<void> _resumeCamera() async {
    if (_isInitializing) return;
    if (!_isPermissionGranted) {
      _initCamera();
      return;
    }
    _isInitializing = true;
    try {
      if (_cameras.isEmpty) {
        _cameras = await availableCameras();
      }
      if (_cameras.isEmpty) return;
      await _setupController(_cameras[_selectedCameraIndex]);
    } catch (e) {
      if (mounted) setState(() => _hasError = true);
    } finally {
      _isInitializing = false;
    }
  }

  ResolutionPreset get _resolutionPreset {
    if (_stampConfig?.resolution == '1080p') return ResolutionPreset.high;
    return ResolutionPreset.max; // 4k
  }

  // C13: 카메라 설정 semaphore — 동시 setup 방지
  bool _isSettingUpController = false;

  Future<void> _setupController(CameraDescription camera) async {
    // C13: 이미 설정 중이면 무시
    if (_isSettingUpController) return;
    _isSettingUpController = true;

    try {
      await _controller?.dispose();
      // C3: 보안 모드에서는 오디오 비활성화 (음성 포함 방지)
      final controller = CameraController(
        camera,
        _resolutionPreset,
        enableAudio: _preset != CameraPreset.secure,
      );
      _controller = controller;

      try {
        await controller.initialize();
        // C12: setFlashMode 예외 처리
        try {
          await controller.setFlashMode(_flashMode);
        } catch (e) {
          debugPrint('setFlashMode failed: $e');
          // flash 미지원 기기 — off로 리셋하고 계속 진행
          _flashMode = FlashMode.off;
        }
        if (mounted) setState(() => _isInitialized = true);
      } catch (e) {
        debugPrint('Camera initialize failed: $e');
        await controller.dispose();
        if (mounted) setState(() => _hasError = true);
      }
    } finally {
      _isSettingUpController = false;
    }
  }

  Color _parseStampColor() =>
      SafeParse.color(_stampConfig?.stampColor);

  /// 위치/나침반 업데이트 콜백 — ValueNotifier로 스탬프만 갱신 (전체 리빌드 없음)
  void _onLocationUpdated() {
    if (mounted) _locationVersion.value++;
  }

  void _startClock() {
    // 스탬프가 꺼져있으면 매초 업데이트 불필요 — 배터리/CPU 절약
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && _stampEnabled) _nowNotifier.value = NtpService.now();
    });
  }

  void _toggleFlash() async {
    final next = switch (_flashMode) {
      FlashMode.off => FlashMode.auto,
      FlashMode.auto => FlashMode.always,
      FlashMode.always => FlashMode.torch,
      FlashMode.torch => FlashMode.off,
    };
    setState(() => _flashMode = next);
    // C12: setFlashMode 예외 처리 — 플래시 미지원 기기 대응
    try {
      await _controller?.setFlashMode(next);
    } catch (e) {
      debugPrint('setFlashMode failed: $e');
      if (mounted) {
        setState(() => _flashMode = FlashMode.off);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.flashNotSupported),
            backgroundColor: AppColors.darkDanger,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  IconData get _flashIcon => switch (_flashMode) {
        FlashMode.off => LucideIcons.zapOff,
        FlashMode.auto => LucideIcons.zap,
        FlashMode.always => LucideIcons.zap,
        FlashMode.torch => LucideIcons.flashlight,
      };

  void _switchCamera() async {
    // M15/C13: 재탭 방어 — 이미 setup 중이면 무시
    if (_cameras.length < 2) return;
    if (_isSettingUpController) return;
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    setState(() => _isInitialized = false);
    await _setupController(_cameras[_selectedCameraIndex]);
  }

  Future<void> _switchPreset(CameraPreset preset) async {
    if (_preset == preset) return;
    final wasSecure = _preset == CameraPreset.secure;
    final nowSecure = preset == CameraPreset.secure;

    setState(() {
      _preset = preset;
      if (preset == CameraPreset.secure) {
        _showAddress = false;
        _showGps = false;
      } else {
        _showAddress = true;
        _showGps = true;
      }
    });

    // C3: 오디오 활성 상태가 달라지면 controller 재설정 (secure↔construction)
    if (wasSecure != nowSecure && _cameras.isNotEmpty) {
      setState(() => _isInitialized = false);
      await _setupController(_cameras[_selectedCameraIndex]);
    }

    if (preset == CameraPreset.construction) {
      _locationService.forceUpdate(_onLocationUpdated);
    }
  }

  /// 탭 투 포커스 — 탭 지점에 카메라 포커스 + 노출 맞추기
  Future<void> _handleViewfinderTap(TapDownDetails details, Size viewSize) async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    // 화면 좌표 → 카메라 좌표계 (0.0 ~ 1.0)
    final dx = (details.localPosition.dx / viewSize.width).clamp(0.0, 1.0);
    final dy = (details.localPosition.dy / viewSize.height).clamp(0.0, 1.0);
    final normalized = Offset(dx, dy);

    // 포커스 인디케이터 표시 (1초)
    if (mounted) {
      setState(() => _focusPoint = details.localPosition);
      _focusIndicatorTimer?.cancel();
      _focusIndicatorTimer = Timer(const Duration(milliseconds: 1000), () {
        if (mounted) setState(() => _focusPoint = null);
      });
    }

    try {
      await _controller!.setFocusPoint(normalized);
      await _controller!.setExposurePoint(normalized);
      HapticFeedback.selectionClick();
    } catch (e) {
      debugPrint('setFocusPoint failed: $e');
    }
  }

  /// 스탬프 master on/off 토글
  void _toggleStampEnabled() {
    HapticFeedback.selectionClick();
    setState(() => _stampEnabled = !_stampEnabled);
    // 스탬프 재활성화 시 현재 시각으로 즉시 반영
    if (_stampEnabled) _nowNotifier.value = NtpService.now();
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (_controller!.value.isTakingPicture) return;
    // 연속 탭 방지 — 최소 500ms 간격
    final now = DateTime.now();
    if (now.difference(_lastShutterTime).inMilliseconds < 500) return;
    _lastShutterTime = now;

    // 셔터 즉시 반응 — 햅틱 + 플래시를 촬영 전에 실행
    HapticFeedback.mediumImpact();
    if (mounted) {
      setState(() => _showShutterFlash = true);
      _shutterFlashTimer?.cancel();
      _shutterFlashTimer = Timer(const Duration(milliseconds: 100), () {
        if (mounted) setState(() => _showShutterFlash = false);
      });
    }

    try {
      final xFile = await _controller!.takePicture();

      // Wow 모먼트 — 증거 배지 2초 표시
      if (mounted) {
        setState(() => _showCaptureBadge = true);
        _captureBadgeTimer?.cancel();
        _captureBadgeTimer = Timer(const Duration(milliseconds: 2000), () {
          if (mounted) setState(() => _showCaptureBadge = false);
        });
      }

      // 즉시 썸네일 갱신 — 저장 완료 기다리지 않음
      if (mounted) setState(() => _lastPhotoPath = xFile.path);

      // 저장 시점의 상태를 캡처 (비동기 중 변경될 수 있으므로)
      final capturePreset = _preset;
      final captureMemo = _memo.isNotEmpty ? _memo : null;
      final captureTags = _tags.isNotEmpty ? _tags : null;
      // FK 정합성 검증을 백그라운드 save 내부로 이동 — 셔터 응답 시간 단축
      final captureProjectId = _selectedProjectId;
      final captureLat = _locationService.currentPosition?.latitude;
      final captureLng = _locationService.currentPosition?.longitude;
      final captureAddr = _locationService.currentAddress.isNotEmpty
          ? _locationService.currentAddress : null;
      final captureShowTime = _showTime;
      final captureShowDate = _showDate;
      final captureShowAddress = _showAddress;
      final captureShowGps = _showGps;
      final captureDateFormat = _stampConfig?.dateFormat ?? 'YYYY.MM.DD';
      final captureStampColor = _stampConfig?.stampColor ?? '#FFFFFF';
      final captureStampPosition = _stampConfig?.stampPosition ?? 'bottom';
      final captureStampLayout = _stampConfig?.stampLayout ?? 'text';
      final captureTamperBadge = context.l10n.stampTamperBadge;
      final captureShowInGallery = _stampConfig?.showInNativeGallery ?? true;
      final captureLogoPath = _stampConfig?.logoPath;
      final captureSignaturePath = _stampConfig?.signaturePath;
      final captureProjectName = _selectedProjectName;
      final captureShowCompass = _showCompass;
      final captureShowAltitude = _showAltitude;
      final captureShowSpeed = _showSpeed;
      final captureCompassHeading = _locationService.compassHeading;
      final captureAltitude = _locationService.altitude;
      final captureSpeed = _locationService.speed;
      final locale = Localizations.localeOf(context).languageCode;
      final captureWeather = _locationService.weather != null
          ? '${_locationService.weather!.temperature.toStringAsFixed(0)}° ${WeatherService.weatherDesc(_locationService.weather!.weatherCode, locale)}'
          : null;
      // M23: locale 기반 요일명 전달
      final captureWeekdays = _weekdayNames(locale);
      // v12: 스탬프 커스터마이징 확장 — 촬영 시점 캡처
      final captureStampSize = _stampConfig?.stampSize ?? 'medium';
      final captureStampOpacity = _stampConfig?.stampOpacity ?? 1.0;
      final captureStampBgColor = _stampConfig?.stampBgColor ?? '#000000';
      final captureCustomLine1 = _stampConfig?.customLine1;
      final captureCustomLine2 = _stampConfig?.customLine2;
      final captureSaveOriginal = _stampConfig?.saveOriginal ?? false;
      final captureStampEnabled = _stampEnabled;

      // 저장은 백그라운드 — UI 차단하지 않음, 연속 촬영 가능
      _saveService.savePhoto(
        tempFilePath: xFile.path,
        preset: capturePreset,
        memo: captureMemo,
        tags: captureTags,
        projectId: captureProjectId,
        latitude: captureLat,
        longitude: captureLng,
        address: captureAddr,
        showTime: captureShowTime,
        showDate: captureShowDate,
        showAddress: captureShowAddress,
        showGps: captureShowGps,
        dateFormat: captureDateFormat,
        stampColor: captureStampColor,
        stampPosition: captureStampPosition,
        stampLayout: captureStampLayout,
        tamperBadgeText: captureTamperBadge,
        showInNativeGallery: captureShowInGallery,
        logoPath: captureLogoPath,
        signaturePath: captureSignaturePath,
        projectName: captureProjectName,
        showCompass: captureShowCompass,
        showAltitude: captureShowAltitude,
        showSpeed: captureShowSpeed,
        compassHeading: captureCompassHeading,
        altitude: captureAltitude,
        speed: captureSpeed,
        weatherText: captureWeather,
        weekdayNames: captureWeekdays,
        stampSize: captureStampSize,
        stampOpacity: captureStampOpacity,
        stampBgColor: captureStampBgColor,
        customLine1: captureCustomLine1,
        customLine2: captureCustomLine2,
        saveOriginal: captureSaveOriginal,
        stampEnabled: captureStampEnabled,
      ).then((savedPath) {
        if (mounted) setState(() => _lastPhotoPath = savedPath);
      }).catchError((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.errorSaveFailed),
              backgroundColor: AppColors.darkDanger,
            ),
          );
        }
      });
    } catch (e) {
      // M17: takePicture 실패 — 로깅 후 무시 (카메라 상태 이상)
      debugPrint('takePicture failed: $e');
    }
  }

  // C8: 녹화 시작 중 락 — startVideoRecording 진행 중 중복 호출 방지
  bool _isStartingRecording = false;

  Future<void> _startRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (_isRecording || _isStartingRecording) return;
    _isStartingRecording = true;

    try {
      await _controller!.startVideoRecording();
      // C8: 실제 녹화가 시작된 후에만 상태 변경
      if (mounted) {
        setState(() {
          _isRecording = true;
          _recordingStartTime = DateTime.now();
        });
      }
      HapticFeedback.mediumImpact();
    } catch (e) {
      debugPrint('startVideoRecording failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.commonError),
            backgroundColor: AppColors.darkDanger,
          ),
        );
      }
    } finally {
      _isStartingRecording = false;
    }
  }

  Future<void> _stopRecording() async {
    if (_controller == null || !_isRecording) return;

    try {
      final xFile = await _controller!.stopVideoRecording();
      setState(() {
        _isRecording = false;
        _recordingStartTime = null;
      });

      // 영상 저장 — 프로젝트 유효성 재검증
      final safeProjectId = await _validateProjectId(_selectedProjectId);
      await _saveService.saveVideo(
        tempFilePath: xFile.path,
        preset: _preset,
        memo: _memo.isNotEmpty ? _memo : null,
        tags: _tags.isNotEmpty ? _tags : null,
        projectId: safeProjectId,
        latitude: _locationService.currentPosition?.latitude,
        longitude: _locationService.currentPosition?.longitude,
        address: _locationService.currentAddress.isNotEmpty ? _locationService.currentAddress : null,
      );

      if (mounted) {
        HapticFeedback.mediumImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.cameraRecordingDone),
            backgroundColor: AppColors.darkAccent,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
        _recordingStartTime = null;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.errorSaveFailed),
            backgroundColor: AppColors.darkDanger,
          ),
        );
      }
    }
  }

  void _onShutterTap() {
    switch (_mode) {
      case CameraMode.photo:
        _takePicture();
      case CameraMode.video:
        _isRecording ? _stopRecording() : _startRecording();
      case CameraMode.timelapse:
        _autoCaptureController.isTimelapsing
            ? _stopTimelapse()
            : _showTimelapseIntervalPicker();
      case CameraMode.interval:
        _autoCaptureController.isIntervalShooting
            ? _stopInterval()
            : _showIntervalPicker();
    }
  }

  void _showTimelapseIntervalPicker() {
    final l = context.l10n;
    final options = [
      (1, l.cameraInterval1s),
      (3, l.cameraInterval3s),
      (5, l.cameraInterval5s),
      (10, l.cameraInterval10s),
      (30, l.cameraInterval30s),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).padding.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.cameraTimelapseInterval,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.darkText1,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: options.map((opt) {
                final isActive = opt.$1 == _autoCaptureController.timelapseIntervalSec;
                return GestureDetector(
                  onTap: () {
                    setState(() => _autoCaptureController.timelapseIntervalSec = opt.$1);
                    Navigator.pop(ctx);
                    _startTimelapse();
                  },
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.darkAccentDim
                          : AppColors.darkSurfaceHi,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isActive
                            ? AppColors.darkAccent
                            : AppColors.darkBorder,
                      ),
                    ),
                    child: Text(
                      opt.$2,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isActive
                            ? AppColors.darkAccent
                            : AppColors.darkText2,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _startTimelapse() {
    HapticFeedback.mediumImpact();
    _autoCaptureController.startTimelapse(_takeAutoPhoto);
    setState(() {}); // isTimelapsing 상태 반영
  }

  /// 자동 촬영 공통 메서드 (타임랩스 + 인터벌 공용)
  Future<void> _takeAutoPhoto(VoidCallback onSuccess) async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (_controller!.value.isTakingPicture || _isSaving) return;

    setState(() => _isSaving = true);
    try {
      final xFile = await _controller!.takePicture();
      final safeProjectId = await _validateProjectId(_selectedProjectId);
      await _saveService.savePhoto(
        tempFilePath: xFile.path,
        preset: _preset,
        memo: _memo.isNotEmpty ? _memo : null,
        tags: _tags.isNotEmpty ? _tags : null,
        projectId: safeProjectId,
        latitude: _locationService.currentPosition?.latitude,
        longitude: _locationService.currentPosition?.longitude,
        address: _locationService.currentAddress.isNotEmpty ? _locationService.currentAddress : null,
        showTime: _showTime,
        showDate: _showDate,
        showAddress: _showAddress,
        showGps: _showGps,
        dateFormat: _stampConfig?.dateFormat ?? 'YYYY.MM.DD',
        stampColor: _stampConfig?.stampColor ?? '#FFFFFF',
        stampPosition: _stampConfig?.stampPosition ?? 'bottom',
        stampLayout: _stampConfig?.stampLayout ?? 'text',
        tamperBadgeText: context.l10n.stampTamperBadge,
        showInNativeGallery: _stampConfig?.showInNativeGallery ?? true,
        logoPath: _stampConfig?.logoPath,
        signaturePath: _stampConfig?.signaturePath,
        projectName: _selectedProjectName,
        showCompass: _showCompass,
        showAltitude: _showAltitude,
        showSpeed: _showSpeed,
        compassHeading: _locationService.compassHeading,
        altitude: _locationService.altitude,
        speed: _locationService.speed,
        weatherText: _locationService.weather != null
            ? '${_locationService.weather!.temperature.toStringAsFixed(0)}° ${WeatherService.weatherDesc(_locationService.weather!.weatherCode, Localizations.localeOf(context).languageCode)}'
            : null,
        weekdayNames: _weekdayNames(Localizations.localeOf(context).languageCode),
        stampSize: _stampConfig?.stampSize ?? 'medium',
        stampOpacity: _stampConfig?.stampOpacity ?? 1.0,
        stampBgColor: _stampConfig?.stampBgColor ?? '#000000',
        customLine1: _stampConfig?.customLine1,
        customLine2: _stampConfig?.customLine2,
      );
      if (mounted) {
        setState(onSuccess);
        HapticFeedback.lightImpact();
      }
    } catch (e) {
      // 자동 촬영 중 개별 실패는 무시하고 계속 진행
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _stopTimelapse() {
    final count = _autoCaptureController.stopTimelapse();
    setState(() {});
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.cameraTimelapseDone(count)),
        backgroundColor: AppColors.darkAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showIntervalPicker() {
    final l = context.l10n;
    final options = [
      (60, l.cameraInterval1m),
      (300, l.cameraInterval5m),
      (600, l.cameraInterval10m),
      (1800, l.cameraInterval30m),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24, right: 24, top: 24,
          bottom: MediaQuery.of(ctx).padding.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.cameraTimelapseInterval,
              style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700,
                color: AppColors.darkText1,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12, runSpacing: 12,
              children: options.map((opt) {
                final isActive = opt.$1 == _autoCaptureController.intervalSec;
                return GestureDetector(
                  onTap: () {
                    setState(() => _autoCaptureController.intervalSec = opt.$1);
                    Navigator.pop(ctx);
                    _startInterval();
                  },
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.darkAccentDim : AppColors.darkSurfaceHi,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isActive
                            ? AppColors.darkAccent : AppColors.darkBorder,
                      ),
                    ),
                    child: Text(
                      opt.$2,
                      style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600,
                        color: isActive
                            ? AppColors.darkAccent : AppColors.darkText2,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _startInterval() {
    HapticFeedback.mediumImpact();
    _autoCaptureController.startInterval(_takeAutoPhoto);
    setState(() {});
  }

  void _stopInterval() {
    final count = _autoCaptureController.stopInterval();
    setState(() {});
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.cameraIntervalDone(count)),
        backgroundColor: AppColors.darkAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openStampEditor() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => StampEditSheet(
        showTime: _showTime,
        showDate: _showDate,
        showAddress: _showAddress,
        showGps: _showGps,
        memo: _memo,
        tags: _tags,
        showCompass: _showCompass,
        showAltitude: _showAltitude,
        showSpeed: _showSpeed,
        isSecureMode: _preset == CameraPreset.secure,
        selectedProjectId: _selectedProjectId,
        onProjectChanged: (id) {
          setState(() => _selectedProjectId = id);
          _loadProjectName();
        },
        onChanged: ({
          bool? showTime,
          bool? showDate,
          bool? showAddress,
          bool? showGps,
          String? memo,
          String? tags,
          bool? showCompass,
          bool? showAltitude,
          bool? showSpeed,
        }) {
          setState(() {
            if (showTime != null) _showTime = showTime;
            if (showDate != null) _showDate = showDate;
            if (showAddress != null) _showAddress = showAddress;
            if (showGps != null) _showGps = showGps;
            if (memo != null) _memo = memo;
            if (tags != null) _tags = tags;
            if (showCompass != null) _showCompass = showCompass;
            if (showAltitude != null) _showAltitude = showAltitude;
            if (showSpeed != null) _showSpeed = showSpeed;
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
            // ── 카메라 프리뷰 + 탭 투 포커스 ──
            if (_isInitialized && _controller != null)
              Positioned.fill(
                child: LayoutBuilder(
                  builder: (ctx, constraints) => GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTapDown: (d) => _handleViewfinderTap(
                      d,
                      Size(constraints.maxWidth, constraints.maxHeight),
                    ),
                    child: ClipRect(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _controller!.value.previewSize?.height ?? 1,
                          height: _controller!.value.previewSize?.width ?? 1,
                          child: CameraPreview(_controller!),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            else if (_hasError)
              _CameraError(l: l)
            else
              const Center(
                child: CircularProgressIndicator(
                  color: AppColors.darkAccent,
                  strokeWidth: 2,
                ),
              ),

            // ── 배터리 세이버 모드 ──
            if (_stampConfig?.batterySaver == true)
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    color: AppColors.amoledBlack, // AMOLED 검은색
                  ),
                ),
              ),

            // ── 보안 모드 틴트 ──
            if (_preset == CameraPreset.secure && _stampConfig?.batterySaver != true)
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    color: AppColors.secureBg.withValues(alpha: 0.3),
                  ),
                ),
              ),

            // ── 상단 바 ──
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CameraTopBar(
                preset: _preset,
                flashIcon: _flashIcon,
                flashMode: _flashMode,
                onPresetChanged: _switchPreset,
                onFlashTap: _toggleFlash,
                onClose: () => Navigator.of(context).pop(),
                l: l,
                stampEnabled: _stampEnabled,
                onStampToggle: _toggleStampEnabled,
                stampColor: _parseStampColor(),
              ),
            ),

            // ── 스탬프 오버레이 — 하단 컨트롤 위에 배치 (master toggle off 시 숨김) ──
            if (_stampEnabled) Positioned(
              left: 0,
              right: 0,
              bottom: 230,
              child: RepaintBoundary(
                child: ValueListenableBuilder<DateTime>(
                  valueListenable: _nowNotifier,
                  builder: (context, now, _) => ValueListenableBuilder<int>(
                    valueListenable: _locationVersion,
                    builder: (ctx2, locVer, child2) => StampOverlay(
                    now: now,
                    preset: _preset,
                    showTime: _showTime,
                    showDate: _showDate,
                    showAddress: _showAddress && _preset != CameraPreset.secure,
                    showGps: _showGps && _preset != CameraPreset.secure,
                    address: _locationService.currentAddress,
                    latitude: _locationService.currentPosition?.latitude,
                    longitude: _locationService.currentPosition?.longitude,
                    memo: _memo,
                    onEditTap: _openStampEditor,
                    dateFormat: _stampConfig?.dateFormat ?? 'YYYY.MM.DD',
                    stampColorHex: _stampConfig?.stampColor,
                    stampPosition: _stampConfig?.stampPosition ?? 'bottom',
                    stampLayout: _stampConfig?.stampLayout ?? 'text',
                    showCompass: _showCompass && _preset != CameraPreset.secure,
                    showAltitude: _showAltitude && _preset != CameraPreset.secure,
                    showSpeed: _showSpeed && _preset != CameraPreset.secure,
                    compassHeading: _locationService.compassHeading,
                    altitude: _locationService.altitude,
                    speed: _locationService.speed,
                    logoPath: _stampConfig?.logoPath,
                    signaturePath: _stampConfig?.signaturePath,
                    secureBadgeText: l.cameraSecureBadge,
                    tamperBadgeText: l.stampTamperBadge,
                    projectName: _selectedProjectName,
                    weatherText: _locationService.weather != null
                        ? '${_locationService.weather!.temperature.toStringAsFixed(0)}° ${WeatherService.weatherDesc(_locationService.weather!.weatherCode, Localizations.localeOf(context).languageCode)}'
                        : null,
                    photoCode: null, // 코드는 촬영 시점에만 생성
                    // v12: 스탬프 커스터마이징 확장
                    stampSize: _stampConfig?.stampSize ?? 'medium',
                    stampOpacity: _stampConfig?.stampOpacity ?? 1.0,
                    stampBgColor: _stampConfig?.stampBgColor,
                    customLine1: _stampConfig?.customLine1,
                    customLine2: _stampConfig?.customLine2,
                  ),
                ),
                ),
              ),
            ),

            // ── 셔터 플래시 오버레이 ──
            if (_showShutterFlash)
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(color: Colors.white.withValues(alpha: 0.6)),
                ),
              ),

            // ── 탭 투 포커스 인디케이터 ──
            if (_focusPoint != null)
              Positioned(
                left: _focusPoint!.dx - 32,
                top: _focusPoint!.dy - 32,
                child: IgnorePointer(
                  child: _FocusIndicator(key: ValueKey(_focusPoint)),
                ),
              ),

            // ── Wow 모먼트: 촬영 성공 증거 배지 (상단 중앙) ──
            // RepaintBoundary로 카메라 프리뷰와 분리 — 배지 애니메이션이 프리뷰 리페인트 안 함
            Positioned(
              top: MediaQuery.paddingOf(context).top + 96,
              left: 0, right: 0,
              child: IgnorePointer(
                child: Center(
                  child: RepaintBoundary(
                    child: _CaptureBadgeOverlay(
                      visible: _showCaptureBadge,
                      l: l,
                    ),
                  ),
                ),
              ),
            ),

            // ── 하단 컨트롤 ──
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CameraBottomControls(
                mode: _mode,
                isRecording: _isRecording,
                isTimelapsing: _autoCaptureController.isTimelapsing,
                isIntervalShooting: _autoCaptureController.isIntervalShooting,
                timelapseCount: _autoCaptureController.timelapseCount,
                intervalCount: _autoCaptureController.intervalCount,
                recordingStartTime: _recordingStartTime,
                now: _nowNotifier.value,
                onShutter: _onShutterTap,
                onSwitchCamera: _switchCamera,
                hasFrontCamera: _cameras.length > 1,
                onModeChanged: (m) => setState(() {
                  _mode = m;
                  // M16: 모드 전환 시 연속 탭 쿨다운 초기화
                  _lastShutterTime = DateTime(2000);
                }),
                lastPhotoPath: _lastPhotoPath,
                onGalleryTap: () {
                  Navigator.of(context).pop('gallery');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 카메라 에러 ────────────────────────────────────────────────
class _CameraError extends StatelessWidget {
  const _CameraError({required this.l});
  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            LucideIcons.cameraOff,
            size: 48,
            color: AppColors.darkText3,
          ),
          const SizedBox(height: 16),
          Text(
            l.errorCameraPermission,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.darkText2,
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => openAppSettings(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.darkAccentDim,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.darkAccent.withValues(alpha: 0.3)),
              ),
              child: Text(
                l.openSettingsAction,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkAccent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 촬영 성공 배지 오버레이 — AnimationController 단일 통합 트랜지션 (60/120fps 부드러움)
class _CaptureBadgeOverlay extends StatefulWidget {
  const _CaptureBadgeOverlay({required this.visible, required this.l});
  final bool visible;
  final AppLocalizations l;

  @override
  State<_CaptureBadgeOverlay> createState() => _CaptureBadgeOverlayState();
}

class _CaptureBadgeOverlayState extends State<_CaptureBadgeOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _slide;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
      reverseDuration: const Duration(milliseconds: 200),
    );
    // easeOutQuint — 빠르게 들어오고 부드럽게 안착
    _slide = Tween<double>(begin: -16.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuint),
    );
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void didUpdateWidget(covariant _CaptureBadgeOverlay old) {
    super.didUpdateWidget(old);
    if (widget.visible != old.visible) {
      if (widget.visible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        if (_controller.value == 0) return const SizedBox.shrink();
        return Opacity(
          opacity: _opacity.value,
          child: Transform.translate(
            offset: Offset(0, _slide.value),
            child: child,
          ),
        );
      },
      child: _CaptureSuccessBadge(l: widget.l),
    );
  }
}

class _CaptureSuccessBadge extends StatelessWidget {
  const _CaptureSuccessBadge({required this.l});
  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.darkAccent.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24, height: 24,
            decoration: const BoxDecoration(
              color: AppColors.darkAccent,
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.check, size: 14, color: AppColors.darkBg),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l.captureSuccessTitle,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.1,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                l.captureSuccessTamper,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.7),
                  letterSpacing: 0.2,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 탭 투 포커스 인디케이터 — 탭 지점에 나타나는 원형 링 (0.8→1.0 scale + 페이드아웃)
class _FocusIndicator extends StatefulWidget {
  const _FocusIndicator({super.key});

  @override
  State<_FocusIndicator> createState() => _FocusIndicatorState();
}

class _FocusIndicatorState extends State<_FocusIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scale = Tween<double>(begin: 1.35, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.35, curve: Curves.easeOutQuint)),
    );
    // 앞 200ms 불투명, 이후 페이드아웃
    _opacity = TweenSequence([
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => Opacity(
        opacity: _opacity.value,
        child: Transform.scale(
          scale: _scale.value,
          child: Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.darkAccent, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkAccent.withValues(alpha: 0.35),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 6, height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.darkAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
