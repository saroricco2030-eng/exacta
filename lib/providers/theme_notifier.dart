/// Theme/Locale Riverpod Notifiers with DB sync
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 테마 모드 관리 — Riverpod Notifier
class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  bool get isDark => state == ThemeMode.dark;

  void setTheme(ThemeMode mode) => state = mode;

  void applyFromDb(String value) {
    final next = switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      'system' => ThemeMode.system,
      _ => null,
    };
    if (next == null) {
      // C15: 알 수 없는 값 로그 — 런타임 추적 가능하도록
      debugPrint('ThemeNotifier.applyFromDb: unknown value "$value" → fallback to system');
      state = ThemeMode.system;
    } else {
      state = next;
    }
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);

/// 로캘 관리 — Riverpod Notifier
class LocaleNotifier extends Notifier<Locale?> {
  @override
  Locale? build() => null; // system

  void setLocale(Locale? locale) => state = locale;

  void applyFromDb(String value) {
    final next = switch (value) {
      'ko' => const Locale('ko'),
      'en' => const Locale('en'),
      'ja' => const Locale('ja'),
      'system' => null,
      _ => 'unknown',
    };
    if (next == 'unknown') {
      // C15: 알 수 없는 값 로그
      debugPrint('LocaleNotifier.applyFromDb: unknown value "$value" → fallback to system');
      state = null;
    } else {
      state = next as Locale?;
    }
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(LocaleNotifier.new);
