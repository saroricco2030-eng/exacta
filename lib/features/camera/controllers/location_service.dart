/// Location/compass/altitude/speed/weather service for camera
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_compass/flutter_compass.dart';

import 'package:exacta/services/weather_service.dart';

/// 위치/나침반/해발/속도/날씨 관련 로직을 캡슐화한 서비스.
class LocationService {
  Position? currentPosition;
  String currentAddress = '';
  double? compassHeading;
  double? altitude;
  double? speed;
  WeatherInfo? weather;

  Timer? _locationTimer;
  StreamSubscription<CompassEvent>? _compassSubscription;
  DateTime _lastCompassNotify = DateTime(2000);

  /// [isSecureMode] — true이면 위치 업데이트를 건너뛴다.
  /// [onUpdate] — 값이 갱신될 때마다 호출 (보통 setState).
  bool Function() isSecureMode = () => false;

  /// [isMounted] — 위젯 dispose 후 콜백 방지용 (camera_screen의 mounted 전달)
  bool Function() isMounted = () => true;

  void start(VoidCallback onUpdate) {
    _updateLocation(onUpdate);
    _locationTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (isMounted()) _updateLocation(onUpdate);
    });
    _startCompass(onUpdate);
  }

  void stop() {
    _locationTimer?.cancel();
    _locationTimer = null;
    _compassSubscription?.cancel();
    _compassSubscription = null;
  }

  void _startCompass(VoidCallback onUpdate) {
    _compassSubscription = FlutterCompass.events?.listen((event) {
      if (event.heading != null) {
        compassHeading = event.heading;
        // 나침반 이벤트는 30-60Hz로 발생 — 500ms 쓰로틀로 리빌드 최소화
        final now = DateTime.now();
        if (now.difference(_lastCompassNotify).inMilliseconds >= 500) {
          _lastCompassNotify = now;
          if (isMounted()) onUpdate();
        }
      }
    });
  }

  Future<void> _updateLocation(VoidCallback onUpdate) async {
    // 보안 모드에서는 위치 가져오지 않음
    if (isSecureMode()) return;

    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return; // 권한은 카메라 초기화에서 요청 — 여기서는 체크만
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 5),
        ),
      );

      String address = '';
      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          address = [p.locality, p.subLocality, p.thoroughfare]
              .where((s) => s != null && s.isNotEmpty)
              .join(' ');
        }
      } catch (e) {
        debugPrint('Geocoding failed: $e');
      }

      currentPosition = position;
      currentAddress = address;
      altitude = position.altitude;
      speed = position.speed;

      // 날씨 가져오기 (5분 캐시, 실패 시 무시)
      weather = await WeatherService.fetch(position.latitude, position.longitude);

      if (isMounted()) onUpdate();
    } catch (e) {
      debugPrint('Location update failed: $e');
    }
  }

  /// 프리셋 전환 시 즉시 위치 업데이트를 트리거한다.
  void forceUpdate(VoidCallback onUpdate) {
    _updateLocation(onUpdate);
  }
}
