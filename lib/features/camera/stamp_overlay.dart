/// Viewfinder stamp overlay — bar (full-width) / card (compact bottom-left) modes
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:exacta/core/theme/app_colors.dart';
import 'package:exacta/core/theme/app_theme.dart';
import 'package:exacta/features/camera/camera_screen.dart';

class StampOverlay extends StatelessWidget {
  const StampOverlay({
    super.key,
    required this.now,
    required this.preset,
    required this.showTime,
    required this.showDate,
    required this.showAddress,
    required this.showGps,
    required this.address,
    required this.memo,
    required this.onEditTap,
    this.latitude,
    this.longitude,
    this.dateFormat = 'YYYY.MM.DD',
    this.stampColorHex,
    this.stampPosition = 'bottom',
    this.stampLayout = 'text',
    this.showCompass = false,
    this.showAltitude = false,
    this.showSpeed = false,
    this.logoPath,
    this.signaturePath,
    this.compassHeading,
    this.altitude,
    this.speed,
    this.secureBadgeText = 'SECURE · EXIF STRIPPED',
    this.tamperBadgeText = '',
    this.projectName,
    this.weatherText,
    this.photoCode,
  });

  final DateTime now;
  final CameraPreset preset;
  final bool showTime, showDate, showAddress, showGps;
  final bool showCompass, showAltitude, showSpeed;
  final String address;
  final double? latitude, longitude, compassHeading, altitude, speed;
  final String? logoPath, signaturePath, projectName, weatherText, photoCode;
  final String secureBadgeText, tamperBadgeText, memo, dateFormat;
  final String? stampColorHex;
  final String stampPosition;
  final String stampLayout;
  final VoidCallback onEditTap;

  Color get _color {
    if (stampColorHex != null) {
      try { return Color(int.parse(stampColorHex!.replaceFirst('#', '0xFF'))); }
      catch (_) {}
    }
    return Colors.white;
  }

  bool get _isSecure => preset == CameraPreset.secure;

  List<Shadow> get _shadows => const [
    Shadow(offset: Offset(0, 1), blurRadius: 3, color: Color(0x99000000)),
    Shadow(offset: Offset(0, 0), blurRadius: 8, color: Color(0x66000000)),
  ];

  /// text 모드 전용 — 배경 없이 가독성 확보용 강화 그림자
  List<Shadow> get _textShadows => const [
    Shadow(offset: Offset(0, 1), blurRadius: 4, color: Color(0xCC000000)),
    Shadow(offset: Offset(0, 0), blurRadius: 12, color: Color(0x99000000)),
    Shadow(offset: Offset(1, 1), blurRadius: 2, color: Color(0xB3000000)),
  ];

  String get _hhmm => '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  String get _ss => ':${now.second.toString().padLeft(2, '0')}';

  String get _dateStr {
    final y = now.year, mo = now.month.toString().padLeft(2, '0'), d = now.day.toString().padLeft(2, '0');
    return switch (dateFormat) {
      'MM/DD/YYYY' => '$mo/$d/$y',
      'DD-MM-YYYY' => '$d-$mo-$y',
      _ => '$y.$mo.$d',
    };
  }

  String _weekday(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    const wd = {'ko': ['월','화','수','목','금','토','일'], 'ja': ['月','火','水','木','金','土','日'], 'en': ['Mon','Tue','Wed','Thu','Fri','Sat','Sun']};
    return '(${(wd[locale] ?? wd['en']!)[now.weekday - 1]})';
  }

  String get _gps {
    if (latitude == null || longitude == null) return '';
    final lat = latitude!, lng = longitude!;
    return '${lat.abs().toStringAsFixed(4)}°${lat >= 0 ? 'N' : 'S'}  ${lng.abs().toStringAsFixed(4)}°${lng >= 0 ? 'E' : 'W'}';
  }

  bool get _hasContent => showTime || showDate || showAddress || showGps || showCompass || showAltitude || showSpeed || memo.isNotEmpty || (projectName?.isNotEmpty ?? false) || (weatherText?.isNotEmpty ?? false) || logoPath != null || signaturePath != null;

  @override
  Widget build(BuildContext context) {
    if (!_hasContent && !_isSecure) {
      return Align(
        alignment: Alignment.centerRight,
        child: Padding(padding: const EdgeInsets.only(right: 16), child: _EditBtn(onTap: onEditTap)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Padding(padding: const EdgeInsets.only(right: 8, bottom: 4), child: _EditBtn(onTap: onEditTap)),
        ),
        switch (stampLayout) {
          'card' => _buildCard(context),
          'text' => _buildTextOnly(context),
          _ => _buildBar(context),
        },
      ],
    );
  }

  // ════════════════════════════════════════════════════════════
  // TEXT 레이아웃 — 2열 + 중앙 배지
  //   좌측: 시간 → 날짜 → 풀 주소 → 센서(방위°/고도m/속도km/h 인라인 1줄)
  //   우측: • 도시명 → 좌표 → 증거 ID
  //   메인 Row 위: memo(전폭), secureBadge
  //   메인 Row 아래: logo/sig → 6dp → 중앙 tamperBadge
  // Row crossAxisAlignment: start — 두 열 높이 불일치해도 상단 기준 안정
  // ════════════════════════════════════════════════════════════
  Widget _buildTextOnly(BuildContext context) {
    double a(double o) => (o * 0.4 + 0.6).clamp(0.0, 1.0);
    final c = _color;
    final sh = _textShadows;

    String cityLine() {
      if (address.isEmpty) return '';
      final first = address.split(RegExp(r'[,\s]')).firstWhere(
          (t) => t.trim().isNotEmpty, orElse: () => '');
      return first.isEmpty ? address : first;
    }

    // 센서 인라인 1줄 (방위° / 고도m / 속도km/h)
    String sensorLine() {
      final parts = <String>[];
      if (showCompass && compassHeading != null) {
        parts.add('${compassHeading!.toStringAsFixed(0)}°');
      }
      if (showAltitude && altitude != null) {
        parts.add('${altitude!.toStringAsFixed(1)}m');
      }
      if (showSpeed && speed != null) {
        parts.add('${(speed! * 3.6).toStringAsFixed(1)}km/h');
      }
      return parts.join('  ');
    }
    final sensorText = !_isSecure ? sensorLine() : '';
    final hasAddress = !_isSecure && showAddress && address.isNotEmpty;

    // 좌측 컬럼
    final leftChildren = <Widget>[
      if (showTime)
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(_hhmm, style: _ts(30, FontWeight.w700, c, shadows: sh)),
            Text(_ss, style: _ts(17, FontWeight.w500, c.withValues(alpha: a(0.6)), shadows: sh)),
          ],
        ),
      if (showDate)
        Padding(
          padding: EdgeInsets.only(top: showTime ? 2 : 0),
          child: Text('$_dateStr ${_weekday(context)}',
            style: _ts(13, FontWeight.w600, c.withValues(alpha: a(0.9)), shadows: sh)),
        ),
      if (hasAddress)
        Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(address, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: _ts(11, FontWeight.w500, c.withValues(alpha: a(0.75)), shadows: sh)),
        ),
      if (sensorText.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(sensorText, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: _ts(10, FontWeight.w500, c.withValues(alpha: a(0.6)),
              letterSpacing: 0.2, shadows: sh)),
        ),
    ];

    // 우측 컬럼
    final rightChildren = <Widget>[
      if (hasAddress)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6, height: 6,
              decoration: BoxDecoration(
                color: c.withValues(alpha: a(0.75)),
                shape: BoxShape.circle,
                boxShadow: sh.map((s) => BoxShadow(
                  offset: s.offset, blurRadius: s.blurRadius, color: s.color,
                )).toList(),
              ),
            ),
            const SizedBox(width: 5),
            Text(cityLine(),
              maxLines: 1, overflow: TextOverflow.ellipsis,
              style: _ts(13, FontWeight.w600, c.withValues(alpha: a(0.9)), shadows: sh)),
          ],
        ),
      if (!_isSecure && showGps && _gps.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(_gps,
            style: _ts(11, FontWeight.w500, c.withValues(alpha: a(0.75)),
              letterSpacing: 0.3, shadows: sh)),
        ),
      if (photoCode != null && photoCode!.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(photoCode!,
            style: _ts(9, FontWeight.w500, c.withValues(alpha: a(0.55)),
              letterSpacing: 0.4, shadows: sh)),
        ),
    ];

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isSecure) _secureBadge(c),

          // 메모 (메인 Row 위 전폭)
          if (memo.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(memo, maxLines: 2, overflow: TextOverflow.ellipsis,
                style: _ts(12, FontWeight.w600, c.withValues(alpha: a(0.9)), shadows: sh)),
            ),

          // ── 메인 Row ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: leftChildren,
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: rightChildren,
              ),
            ],
          ),

          // 로고/서명 (메인 Row 아래 전폭)
          _logoSignature(c),
          if (_isSecure) _secureFooter(c),

          const SizedBox(height: 6),

          // ── 중앙 검증 텍스트 ──
          if (tamperBadgeText.isNotEmpty)
            Text(
              tamperBadgeText,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _ts(10, FontWeight.w600, c.withValues(alpha: a(0.7)),
                letterSpacing: 0.3, shadows: sh),
            ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // CARD 레이아웃 — 좌하단 소형 라운드 카드, 꽉 찬 정보
  // ════════════════════════════════════════════════════════════
  Widget _buildCard(BuildContext context) {
    final c = _color;
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: const Color(0xB3000000),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: c.withValues(alpha: 0.12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 보안 뱃지
            if (_isSecure) _secureBadge(c),

            // 시간
            if (showTime)
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(_hhmm, style: _ts(28, FontWeight.w700, c, shadows: _shadows)),
                  Text(_ss, style: _ts(15, FontWeight.w400, c.withValues(alpha: 0.5), shadows: _shadows)),
                ],
              ),

            // 날짜
            if (showDate)
              Padding(
                padding: EdgeInsets.only(top: showTime ? 2 : 0),
                child: Text('$_dateStr ${_weekday(context)}',
                  style: _ts(13, FontWeight.w600, c.withValues(alpha: 0.8), shadows: _shadows)),
              ),

            // 프로젝트명
            if (projectName != null && projectName!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.folderOpen, size: 10, color: c.withValues(alpha: 0.5)),
                    const SizedBox(width: 4),
                    Flexible(child: Text(projectName!, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: _ts(11, FontWeight.w500, c.withValues(alpha: 0.6)))),
                  ],
                ),
              ),

            // 주소
            if (!_isSecure && showAddress && address.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.mapPin, size: 10, color: c.withValues(alpha: 0.45)),
                    const SizedBox(width: 4),
                    Flexible(child: Text(address, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: _ts(11, FontWeight.w400, c.withValues(alpha: 0.6)))),
                  ],
                ),
              ),

            // GPS
            if (!_isSecure && showGps && _gps.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(_gps, style: _ts(9, FontWeight.w400, c.withValues(alpha: 0.4), letterSpacing: 0.3)),
              ),

            // 나침반/해발/속도 — 인라인 태그
            if (!_isSecure && (showCompass || showAltitude || showSpeed))
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Wrap(
                  spacing: 8,
                  children: [
                    if (showCompass && compassHeading != null) _tag(LucideIcons.compass, '${compassHeading!.toStringAsFixed(0)}°', c),
                    if (showAltitude && altitude != null) _tag(LucideIcons.mountain, '${altitude!.toStringAsFixed(1)}m', c),
                    if (showSpeed && speed != null) _tag(LucideIcons.gauge, '${(speed! * 3.6).toStringAsFixed(1)}km/h', c),
                  ],
                ),
              ),

            // 메모
            if (memo.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(memo, maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: _ts(11, FontWeight.w600, c.withValues(alpha: 0.85))),
              ),

            // 날씨 + 코드
            if (!_isSecure && (weatherText != null || photoCode != null))
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (weatherText != null) ...[
                      Icon(LucideIcons.cloudSun, size: 9, color: c.withValues(alpha: 0.4)),
                      const SizedBox(width: 3),
                      Text(weatherText!, style: _ts(9, FontWeight.w400, c.withValues(alpha: 0.4))),
                    ],
                    if (weatherText != null && photoCode != null) const SizedBox(width: 8),
                    if (photoCode != null) Text(photoCode!, style: _ts(8, FontWeight.w400, c.withValues(alpha: 0.25), letterSpacing: 0.5)),
                  ],
                ),
              ),

            // 로고 + 서명
            _logoSignature(c),

            // 보안 모드 하단
            if (_isSecure) _secureFooter(c),

            // 위변조 불가 배지
            _tamperBadge(c),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // BAR 레이아웃 — 풀와이드 바 (기존, 정리)
  // ════════════════════════════════════════════════════════════
  Widget _buildBar(BuildContext context) {
    final c = _color;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.stampBg,
        border: Border(top: BorderSide(color: c.withValues(alpha: 0.15), width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isSecure) _secureBadge(c),

          // 시간 + 날짜 + 위치 — 2열
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // 좌: 시간 + 날짜
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showTime)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(_hhmm, style: _ts(30, FontWeight.w700, c, shadows: _shadows)),
                          Text(_ss, style: _ts(16, FontWeight.w400, c.withValues(alpha: 0.5), shadows: _shadows)),
                        ],
                      ),
                    if (showDate)
                      Text('$_dateStr ${_weekday(context)}',
                        style: _ts(14, FontWeight.w600, c.withValues(alpha: 0.8), shadows: _shadows)),
                    if (projectName != null && projectName!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(projectName!, maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: _ts(12, FontWeight.w500, c.withValues(alpha: 0.6))),
                      ),
                  ],
                ),
              ),

              // 우: 주소 + GPS + 메모
              if (!_isSecure)
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (memo.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(memo, maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.right,
                            style: _ts(13, FontWeight.w600, c.withValues(alpha: 0.9), shadows: _shadows)),
                        ),
                      if (showAddress && address.isNotEmpty)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(LucideIcons.mapPin, size: 10, color: c.withValues(alpha: 0.45)),
                            const SizedBox(width: 3),
                            Flexible(child: Text(address, maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: _ts(11, FontWeight.w400, c.withValues(alpha: 0.6)))),
                          ],
                        ),
                      if (showGps && _gps.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: Text(_gps, style: _ts(9, FontWeight.w400, c.withValues(alpha: 0.4), letterSpacing: 0.3)),
                        ),
                    ],
                  ),
                ),
            ],
          ),

          // 오버레이 + 날씨 + 코드
          if (!_isSecure && (showCompass || showAltitude || showSpeed))
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Wrap(spacing: 10, children: [
                if (showCompass && compassHeading != null) _tag(LucideIcons.compass, '${compassHeading!.toStringAsFixed(0)}°', c),
                if (showAltitude && altitude != null) _tag(LucideIcons.mountain, '${altitude!.toStringAsFixed(1)}m', c),
                if (showSpeed && speed != null) _tag(LucideIcons.gauge, '${(speed! * 3.6).toStringAsFixed(1)}km/h', c),
              ]),
            ),
          if (!_isSecure && (weatherText != null || photoCode != null))
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Row(children: [
                if (weatherText != null) ...[
                  Icon(LucideIcons.cloudSun, size: 10, color: c.withValues(alpha: 0.45)),
                  const SizedBox(width: 3),
                  Text(weatherText!, style: _ts(10, FontWeight.w400, c.withValues(alpha: 0.45))),
                ],
                const Spacer(),
                if (photoCode != null) Text(photoCode!, style: _ts(8, FontWeight.w400, c.withValues(alpha: 0.25), letterSpacing: 0.5)),
              ]),
            ),

          _logoSignature(c),
          if (_isSecure) _secureFooter(c),
          _tamperBadge(c),
        ],
      ),
    );
  }

  // ── 공통 위젯 ──
  Widget _secureBadge(Color c) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(LucideIcons.shieldCheck, size: 11, color: c),
      const SizedBox(width: 5),
      Text(secureBadgeText, style: _ts(10, FontWeight.w700, c, letterSpacing: 0.8)),
    ]),
  );

  Widget _secureFooter(Color c) => Padding(
    padding: const EdgeInsets.only(top: 6),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      if (projectName != null && projectName!.isNotEmpty) ...[
        Icon(LucideIcons.shieldCheck, size: 11, color: c.withValues(alpha: 0.5)),
        const SizedBox(width: 5),
        Flexible(child: Text(projectName!, maxLines: 1, overflow: TextOverflow.ellipsis,
          style: _ts(12, FontWeight.w500, c.withValues(alpha: 0.6)))),
        const SizedBox(width: 12),
      ],
      Text('#${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}',
        style: _ts(10, FontWeight.w400, c.withValues(alpha: 0.35))),
    ]),
  );

  Widget _logoSignature(Color c) {
    if ((logoPath == null || logoPath!.isEmpty) && (signaturePath == null || signaturePath!.isEmpty)) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (logoPath != null && logoPath!.isNotEmpty)
          ClipRRect(borderRadius: BorderRadius.circular(4),
            child: Image.file(File(logoPath!), width: 32, height: 32, cacheWidth: 64, fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const SizedBox.shrink())),
        if (logoPath != null && logoPath!.isNotEmpty && signaturePath != null && signaturePath!.isNotEmpty) const SizedBox(width: 8),
        if (signaturePath != null && signaturePath!.isNotEmpty)
          Image.file(File(signaturePath!), width: 64, height: 24, cacheWidth: 128, fit: BoxFit.contain,
            opacity: const AlwaysStoppedAnimation(0.6),
            errorBuilder: (_, _, _) => const SizedBox.shrink()),
      ]),
    );
  }

  /// 위변조 불가 배지 — 3가지 layout 모두 맨 아래에 같은 한 줄
  Widget _tamperBadge(Color c, {bool isTextMode = false}) {
    if (tamperBadgeText.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        tamperBadgeText,
        style: _ts(
          9,
          FontWeight.w600,
          c.withValues(alpha: 0.55),
          letterSpacing: 0.3,
          shadows: isTextMode ? _textShadows : null,
        ),
      ),
    );
  }

  Widget _tag(IconData icon, String text, Color c) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 10, color: c.withValues(alpha: 0.45)),
      const SizedBox(width: 3),
      Text(text, style: _ts(10, FontWeight.w400, c.withValues(alpha: 0.5))),
    ],
  );

  TextStyle _ts(double size, FontWeight w, Color c, {List<Shadow>? shadows, double letterSpacing = 0}) => TextStyle(
    fontFamily: AppTheme.monoFontFamily,
    fontSize: size, fontWeight: w, color: c, height: 1.2,
    letterSpacing: letterSpacing, shadows: shadows,
  );
}

// ── 편집 버튼 ──
class _EditBtn extends StatelessWidget {
  const _EditBtn({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(button: true, label: 'Edit stamp',
      child: GestureDetector(
        onTap: () { HapticFeedback.lightImpact(); onTap(); },
        behavior: HitTestBehavior.opaque,
        child: SizedBox(width: 48, height: 48,
          child: Center(child: Container(
            width: 32, height: 32,
            decoration: BoxDecoration(color: AppColors.stampBg, borderRadius: BorderRadius.circular(8)),
            child: const Icon(LucideIcons.pencil, size: 14, color: AppColors.darkText2),
          )),
        ),
      ),
    );
  }
}
