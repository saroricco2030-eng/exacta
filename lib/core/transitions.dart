/// Custom page transition animations (SlideUp/SlideRight/Fade/Scale)
/// 모든 페이지 전환은 여기 정의된 라우트만 사용. 새 트랜지션 필요 시 추가.
import 'package:flutter/material.dart';

// 공통 duration/curve — 앱 전체 일관성.
const Duration _kEnterDuration = Duration(milliseconds: 260);
const Duration _kExitDuration = Duration(milliseconds: 220);
const Curve _kEnterCurve = Curves.easeOutCubic;
const Curve _kExitCurve = Curves.easeInCubic;

/// 아래에서 위로 슬라이드 + 페이드 — 모달 진입용
class SlideUpRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SlideUpRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: _kEnterDuration,
          reverseTransitionDuration: _kExitDuration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curve = CurvedAnimation(
              parent: animation,
              curve: _kEnterCurve,
              reverseCurve: _kExitCurve,
            );
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.06),
                end: Offset.zero,
              ).animate(curve),
              child: FadeTransition(
                opacity: curve,
                child: child,
              ),
            );
          },
        );
}

/// 오른쪽에서 슬라이드 + 페이드 — 디테일 화면 진입용
class SlideRightRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SlideRightRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: _kEnterDuration,
          reverseTransitionDuration: _kExitDuration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curve = CurvedAnimation(
              parent: animation,
              curve: _kEnterCurve,
              reverseCurve: _kExitCurve,
            );
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.22, 0),
                end: Offset.zero,
              ).animate(curve),
              child: FadeTransition(
                opacity: curve,
                child: child,
              ),
            );
          },
        );
}

/// 페이드 전환 — 카메라/오버레이용
class FadeRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadeRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 220),
          reverseTransitionDuration: const Duration(milliseconds: 180),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: child,
            );
          },
        );
}
