/// Open-Meteo weather API - 5min cache, 3 languages, no API key
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherInfo {
  final double temperature;
  final int weatherCode;
  final String description;
  final String icon;

  const WeatherInfo({
    required this.temperature,
    required this.weatherCode,
    required this.description,
    required this.icon,
  });
}

class WeatherService {
  static WeatherInfo? _cached;
  static DateTime _lastFetch = DateTime(2000);

  /// Open-Meteo 무료 API — API 키 불필요
  static Future<WeatherInfo?> fetch(double lat, double lng) async {
    // 5분 캐시 — 불필요한 요청 방지
    if (_cached != null && DateTime.now().difference(_lastFetch).inMinutes < 5) {
      return _cached;
    }

    try {
      final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lng&current=temperature_2m,weather_code',
      );
      final res = await http.get(url).timeout(const Duration(seconds: 5));
      if (res.statusCode != 200) return _cached;

      final data = jsonDecode(res.body);
      final current = data['current'];
      final temp = (current['temperature_2m'] as num).toDouble();
      final code = current['weather_code'] as int;

      _cached = WeatherInfo(
        temperature: temp,
        weatherCode: code,
        description: weatherDesc(code),
        icon: _weatherIcon(code),
      );
      _lastFetch = DateTime.now();
      return _cached;
    } catch (e) {
      return _cached;
    }
  }

  static String weatherDesc(int code, [String locale = 'en']) {
    final map = switch (locale) {
      'ko' => _weatherKo,
      'ja' => _weatherJa,
      _ => _weatherEn,
    };
    return map[_weatherKey(code)] ?? map['unknown']!;
  }

  static String _weatherKey(int code) => switch (code) {
    0 => 'clear',
    1 || 2 || 3 => 'cloudy',
    45 || 48 => 'fog',
    51 || 53 || 55 => 'drizzle',
    61 || 63 || 65 => 'rain',
    71 || 73 || 75 => 'snow',
    80 || 81 || 82 => 'showers',
    95 || 96 || 99 => 'thunder',
    _ => 'unknown',
  };

  static const _weatherEn = {'clear': 'Clear', 'cloudy': 'Cloudy', 'fog': 'Fog', 'drizzle': 'Drizzle', 'rain': 'Rain', 'snow': 'Snow', 'showers': 'Showers', 'thunder': 'Thunder', 'unknown': 'Unknown'};
  static const _weatherKo = {'clear': '맑음', 'cloudy': '흐림', 'fog': '안개', 'drizzle': '이슬비', 'rain': '비', 'snow': '눈', 'showers': '소나기', 'thunder': '천둥', 'unknown': '알 수 없음'};
  static const _weatherJa = {'clear': '晴れ', 'cloudy': '曇り', 'fog': '霧', 'drizzle': '霧雨', 'rain': '雨', 'snow': '雪', 'showers': 'にわか雨', 'thunder': '雷', 'unknown': '不明'};

  static String _weatherIcon(int code) => switch (code) {
    0 => '☀️',
    1 || 2 || 3 => '☁️',
    45 || 48 => '🌫️',
    51 || 53 || 55 || 61 || 63 || 65 || 80 || 81 || 82 => '🌧️',
    71 || 73 || 75 => '❄️',
    95 || 96 || 99 => '⛈️',
    _ => '🌤️',
  };
}
