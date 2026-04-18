/// Exacta - Field Timestamp Camera App
/// Entry point: Riverpod + theme/locale init + onboarding routing
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:exacta/l10n/generated/app_localizations.dart';
import 'package:exacta/core/colors.dart';
import 'package:exacta/core/theme/app_colors.dart';
import 'package:exacta/data/database.dart';
import 'package:exacta/providers/theme_notifier.dart';
import 'package:exacta/shell/dual_shell.dart';
import 'package:exacta/features/onboarding/onboarding_screen.dart';
import 'package:exacta/features/splash/splash_screen.dart';
import 'package:exacta/services/ntp_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Sentry DSN — 출시 전 https://sentry.io 에서 프로젝트 생성 후 DSN 입력
/// 빈 문자열이면 Sentry 비활성화 (개발 중에는 비워둠)
const _sentryDsn = String.fromEnvironment('SENTRY_DSN', defaultValue: '');

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // ── 블로킹 초기화 최소화 — 빈화면 시간 단축 ──
  GoogleFonts.config.allowRuntimeFetching = true;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 100 * 1024 * 1024;
  // 나머지는 fire-and-forget — 첫 프레임 렌더링 차단 방지
  initializeDateFormatting();
  NtpService.sync();
  FlutterDisplayMode.setHighRefreshRate().catchError((_) {});

  // Sentry: DSN 미설정 시 일반 runApp, 설정 시 크래시 자동 보고
  if (_sentryDsn.isEmpty) {
    runApp(const ProviderScope(child: ExactaApp()));
  } else {
    await SentryFlutter.init(
      (options) {
        options.dsn = _sentryDsn;
        options.tracesSampleRate = 0.1; // 10% 트랜잭션 샘플링
        options.attachScreenshot = false; // 개인정보 보호 — 스크린샷 비전송
        options.sendDefaultPii = false; // PII 비전송
      },
      appRunner: () => runApp(const ProviderScope(child: ExactaApp())),
    );
  }
}

class ExactaApp extends ConsumerStatefulWidget {
  const ExactaApp({super.key});

  @override
  ConsumerState<ExactaApp> createState() => _ExactaAppState();
}

class _ExactaAppState extends ConsumerState<ExactaApp> {
  bool? _showOnboarding;
  bool _splashDone = false;

  // ThemeData 캐시 — build()마다 50+ 객체 재생성 방지
  static ThemeData? _lightThemeCache;
  static ThemeData? _darkThemeCache;

  static ThemeData get _lightTheme {
    return _lightThemeCache ??= _buildLightTheme();
  }

  static ThemeData get _darkTheme {
    return _darkThemeCache ??= _buildDarkTheme();
  }

  static ThemeData _buildLightTheme() {
    final sora = GoogleFonts.soraTextTheme();
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBg,
      canvasColor: AppColors.lightBg,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightAccent,
        secondary: AppColors.lightAccent,
        surface: AppColors.lightSurface,
        error: AppColors.lightDanger,
        onPrimary: AppColors.lightOnAccent,
        onSurface: AppColors.lightText1,
      ),
      appBarTheme: const AppBarTheme(backgroundColor: AppColors.lightBg, foregroundColor: AppColors.lightText1, elevation: 0, scrolledUnderElevation: 0),
      bottomSheetTheme: const BottomSheetThemeData(backgroundColor: AppColors.lightSurface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24)))),
      dialogTheme: DialogThemeData(backgroundColor: AppColors.lightSurface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12)))),
      cardTheme: CardThemeData(color: AppColors.lightSurface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.lightBorder, width: 1)), elevation: 0),
      inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: AppColors.lightSurfaceHi,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.lightBorder)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.lightAccent, width: 1.5)),
        hintStyle: const TextStyle(color: AppColors.lightText3)),
      textTheme: sora.copyWith(
        headlineMedium: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.3, color: AppColors.lightText1),
        titleMedium: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.lightText1),
        labelSmall: GoogleFonts.sora(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.3, color: AppColors.lightText2),
        bodyMedium: GoogleFonts.sora(fontSize: 14, color: AppColors.lightText1, height: 1.6),
        bodySmall: GoogleFonts.sora(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: AppColors.lightText2),
      ),
      iconTheme: const IconThemeData(color: AppColors.lightText2, size: 22),
      dividerColor: AppColors.lightBorder,
    );
  }

  static ThemeData _buildDarkTheme() {
    final sora = GoogleFonts.soraTextTheme();
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      canvasColor: AppColors.darkBg,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkAccent, secondary: AppColors.darkInfo,
        surface: DarkModeColors.surface2, error: AppColors.darkDanger,
        onPrimary: AppColors.darkOnAccent, onSurface: AppColors.darkText1,
      ),
      appBarTheme: const AppBarTheme(backgroundColor: AppColors.darkBg, foregroundColor: AppColors.darkText1, elevation: 0, scrolledUnderElevation: 0),
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: DarkModeColors.surface2, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24)))),
      dialogTheme: DialogThemeData(backgroundColor: DarkModeColors.surface2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12)))),
      cardTheme: CardThemeData(color: DarkModeColors.surface2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.darkBorder, width: 1)), elevation: 0),
      inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: DarkModeColors.surface3,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.darkBorder)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.darkAccent, width: 1.5)),
        hintStyle: const TextStyle(color: AppColors.darkText3)),
      textTheme: sora.copyWith(
        headlineMedium: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.3, color: AppColors.darkText1),
        titleMedium: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.darkText1),
        labelSmall: GoogleFonts.sora(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.3, color: AppColors.darkText2),
        bodyMedium: GoogleFonts.sora(fontSize: 14, color: AppColors.darkText1, height: 1.6),
        bodySmall: GoogleFonts.sora(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: AppColors.darkText2),
      ),
      iconTheme: const IconThemeData(color: AppColors.darkText2, size: 22),
      dividerColor: AppColors.darkBorder,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadSettingsFromDb();
    _checkOnboarding();
    // 네이티브 스플래시(배경색만)는 Flutter 엔진 준비 즉시 제거 —
    // 이후 SplashScreen 위젯이 원본 해상도로 브랜드 스플래시를 렌더한다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
  }

  Future<void> _loadSettingsFromDb() async {
    final config = await AppDatabase.instance.getStampConfig();
    if (!mounted) return;
    ref.read(themeProvider.notifier).applyFromDb(config.themeMode);
    ref.read(localeProvider.notifier).applyFromDb(config.locale);
    setState(() {});
  }

  Future<void> _checkOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    final done = prefs.getBool('onboarding_done') ?? false;
    if (mounted) setState(() => _showOnboarding = !done);
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'Exacta',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: _lightTheme,
      darkTheme: _darkTheme,

      home: !_splashDone
          ? SplashScreen(onDone: () => setState(() => _splashDone = true))
          : _showOnboarding == true
              ? OnboardingScreen(onComplete: () => setState(() => _showOnboarding = false))
              : const DualShell(),
    );
  }
}
