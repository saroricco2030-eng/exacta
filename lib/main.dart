/// Exacta - Field Timestamp Camera App
/// Entry point: Riverpod + theme/locale init + onboarding routing
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:exacta/l10n/generated/app_localizations.dart';
import 'package:exacta/core/colors.dart';
import 'package:exacta/data/database.dart';
import 'package:exacta/providers/theme_notifier.dart';
import 'package:exacta/shell/dual_shell.dart';
import 'package:exacta/features/onboarding/onboarding_screen.dart';
import 'package:exacta/features/splash/splash_screen.dart';
import 'package:exacta/services/ntp_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  // 스플래시 유지 — Android 12+ 시스템 스플래시가 너무 빨리 사라지는 것을 막고
  // 브랜드 스플래시 전용 이미지를 충분히 노출시키기 위함.
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  NtpService.sync();
  runApp(const ProviderScope(child: ExactaApp()));
}

class ExactaApp extends ConsumerStatefulWidget {
  const ExactaApp({super.key});

  @override
  ConsumerState<ExactaApp> createState() => _ExactaAppState();
}

class _ExactaAppState extends ConsumerState<ExactaApp> {
  bool? _showOnboarding;
  bool _splashDone = false;

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

    final sora = GoogleFonts.soraTextTheme();

    return MaterialApp(
      title: 'Exacta',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      // ── Light (Airbnb) ──
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AirbnbColors.bg,
        canvasColor: AirbnbColors.bg,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        colorScheme: const ColorScheme.light(
          primary: AirbnbColors.primary,
          secondary: AirbnbColors.primary,
          surface: Color(0xFFFFFFFF),
          error: Color(0xFFDC2626),
          onPrimary: Color(0xFFFFFFFF),
          onSurface: AirbnbColors.text1,
        ),
        appBarTheme: const AppBarTheme(backgroundColor: AirbnbColors.bg, foregroundColor: AirbnbColors.text1, elevation: 0, scrolledUnderElevation: 0),
        bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24)))),
        dialogTheme: DialogThemeData(backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12)))),
        cardTheme: CardThemeData(color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AirbnbColors.border, width: 1)), elevation: 0),
        inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: AirbnbColors.bg2,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AirbnbColors.border)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AirbnbColors.primary, width: 1.5)),
          hintStyle: const TextStyle(color: AirbnbColors.text3)),
        textTheme: sora.copyWith(
          headlineMedium: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.3, color: AirbnbColors.text1),
          titleMedium: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.w600, color: AirbnbColors.text1),
          labelSmall: GoogleFonts.sora(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.3, color: AirbnbColors.text2),
          bodyMedium: GoogleFonts.sora(fontSize: 14, color: AirbnbColors.text1, height: 1.6),
          bodySmall: GoogleFonts.sora(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: AirbnbColors.text2),
        ),
        iconTheme: const IconThemeData(color: AirbnbColors.text2, size: 22),
        dividerColor: AirbnbColors.border,
      ),

      // ── Dark (Apple Music) ──
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        canvasColor: AppColors.background,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFA2D48), secondary: Color(0xFFB8A0E8),
          surface: Color(0xFF1C1C1E), error: Color(0xFFEF5350),
          onPrimary: Color(0xFFFFFFFF), onSurface: Color(0xFFF5F5F7),
        ),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF000000), foregroundColor: Color(0xFFF5F5F7), elevation: 0, scrolledUnderElevation: 0),
        bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Color(0xFF1C1C1E), shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24)))),
        dialogTheme: DialogThemeData(backgroundColor: const Color(0xFF1C1C1E), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12)))),
        cardTheme: CardThemeData(color: const Color(0xFF1C1C1E), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Color(0x1AFFFFFF), width: 1)), elevation: 0),
        inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: const Color(0xFF2C2C2E),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0x1AFFFFFF))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFA2D48), width: 1.5)),
          hintStyle: const TextStyle(color: Color(0x4DEBEBF5))),
        textTheme: sora.copyWith(
          headlineMedium: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.3, color: const Color(0xFFF5F5F7)),
          titleMedium: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.w600, color: const Color(0xFFF5F5F7)),
          labelSmall: GoogleFonts.sora(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.3, color: const Color(0x99EBEBF5)),
          bodyMedium: GoogleFonts.sora(fontSize: 14, color: const Color(0xFFF5F5F7), height: 1.6),
          bodySmall: GoogleFonts.sora(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: const Color(0x99EBEBF5)),
        ),
        iconTheme: const IconThemeData(color: Color(0x99EBEBF5), size: 22),
        dividerColor: const Color(0x1AFFFFFF),
      ),

      home: !_splashDone
          ? SplashScreen(onDone: () => setState(() => _splashDone = true))
          : _showOnboarding == true
              ? OnboardingScreen(onComplete: () => setState(() => _showOnboarding = false))
              : const DualShell(),
    );
  }
}
