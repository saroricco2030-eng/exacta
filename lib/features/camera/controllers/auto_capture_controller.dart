/// Timelapse + interval auto-capture controller with timer management
import 'dart:async';
import 'dart:ui';

/// 타임랩스 + 인터벌 자동 촬영 로직을 캡슐화한 컨트롤러.
/// camera_screen에서 인스턴스를 만들어 사용한다.
class AutoCaptureController {
  bool isTimelapsing = false;
  int timelapseCount = 0;
  int timelapseIntervalSec = 3;
  Timer? _timelapseTimer;

  bool isIntervalShooting = false;
  int intervalCount = 0;
  int intervalSec = 60;
  Timer? _intervalTimer;

  /// 타임랩스를 시작한다.
  /// [takePhoto] — 실제 촬영 + 카운트 증가 콜백.
  void startTimelapse(Future<void> Function(VoidCallback) takePhoto) {
    isTimelapsing = true;
    timelapseCount = 0;

    takePhoto(() => timelapseCount++);

    _timelapseTimer = Timer.periodic(
      Duration(seconds: timelapseIntervalSec),
      (_) => takePhoto(() => timelapseCount++),
    );
  }

  /// 타임랩스를 정지하고 촬영된 매수를 반환한다.
  int stopTimelapse() {
    _timelapseTimer?.cancel();
    _timelapseTimer = null;
    final count = timelapseCount;
    isTimelapsing = false;
    timelapseCount = 0;
    return count;
  }

  /// 인터벌 촬영을 시작한다.
  void startInterval(Future<void> Function(VoidCallback) takePhoto) {
    isIntervalShooting = true;
    intervalCount = 0;

    takePhoto(() => intervalCount++);

    _intervalTimer = Timer.periodic(
      Duration(seconds: intervalSec),
      (_) => takePhoto(() => intervalCount++),
    );
  }

  /// 인터벌 촬영을 정지하고 촬영된 매수를 반환한다.
  int stopInterval() {
    _intervalTimer?.cancel();
    _intervalTimer = null;
    final count = intervalCount;
    isIntervalShooting = false;
    intervalCount = 0;
    return count;
  }

  void dispose() {
    _timelapseTimer?.cancel();
    _intervalTimer?.cancel();
  }
}
