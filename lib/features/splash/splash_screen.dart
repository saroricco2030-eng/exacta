import 'package:flutter/material.dart';

/// 브랜드 스플래시 — 전용 이미지(assets/branding/splash.png)를
/// 원본 해상도 그대로 풀스크린 렌더링한다.
/// Android 12+ 시스템 스플래시 API는 원형 아이콘 포맷만 허용하여
/// 전체 이미지를 표현할 수 없으므로 Flutter 위젯 레벨에서 직접 그린다.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) widget.onDone();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D1118) : const Color(0xFFFFF8F2),
      body: Center(
        child: Image.asset(
          'assets/branding/splash.png',
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}
