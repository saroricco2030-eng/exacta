import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// 브랜드 스플래시 — 전용 이미지(assets/branding/splash.png)를
/// 원본 해상도 그대로 풀스크린 렌더링한다.
/// Android 12+ 시스템 스플래시 API는 원형 아이콘 포맷만 허용하여
/// 전체 이미지를 표현할 수 없으므로 Flutter 위젯 레벨에서 직접 그린다.
/// 하단에 버전 배지를 노출하여 빌드 구분 용이.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _versionText = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) widget.onDone();
    });
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (!mounted) return;
      setState(() => _versionText = 'v${info.version} · build ${info.buildNumber}');
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0D1118) : const Color(0xFFFFF8F2);
    final versionColor = isDark
        ? Colors.white.withValues(alpha: 0.35)
        : const Color(0xFF3D2E22).withValues(alpha: 0.35);
    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/branding/splash.png',
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 32,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 400),
              opacity: _versionText.isEmpty ? 0.0 : 1.0,
              child: Text(
                _versionText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'monospace',
                  fontFeatures: const [FontFeature.tabularFigures()],
                  letterSpacing: 0.5,
                  color: versionColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
