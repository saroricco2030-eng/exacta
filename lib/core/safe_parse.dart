/// 크래시 방지용 안전 파싱 유틸 — substring OOB, int.parse FormatException 차단
import 'package:flutter/material.dart';

class SafeParse {
  SafeParse._();

  /// hex 색상 안전 파싱 — 실패 시 fallback 반환 (크래시 방지)
  /// "#RRGGBB" / "RRGGBB" 모두 허용
  static Color color(String? hex, {Color fallback = const Color(0xFFFFFFFF)}) {
    if (hex == null || hex.isEmpty) return fallback;
    try {
      final cleaned = hex.replaceFirst('#', '0xFF');
      return Color(int.parse(cleaned));
    } catch (_) {
      return fallback;
    }
  }

  /// 안전 substring — 길이 부족 시 null 또는 원본 반환
  /// e.g. timestamp.substring(0, 10) 인데 timestamp 길이 < 10인 경우 크래시 방지
  static String? substring(String? source, int start, [int? end]) {
    if (source == null) return null;
    if (start < 0 || start > source.length) return null;
    if (end == null) return source.substring(start);
    final safeEnd = end > source.length ? source.length : end;
    if (start >= safeEnd) return null;
    return source.substring(start, safeEnd);
  }

  /// 안전 substring with fallback — null 대신 빈 문자열
  static String substringOr(String? source, int start, int? end, {String fallback = ''}) {
    return substring(source, start, end) ?? fallback;
  }
}
