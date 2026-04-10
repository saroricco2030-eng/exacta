/// Stamp burn engine using dart:ui Canvas API
/// Composites: time/date/address/GPS/compass/altitude/speed/weather/memo/logo/signature/code
/// JPEG encoding via compute() on background isolate
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter/painting.dart';
import 'package:image/image.dart' as img;

import 'package:exacta/features/camera/camera_screen.dart';

class StampBurnService {
  static const _monoFont = 'JetBrains Mono';
  static const _jpegQuality = 92;

  // 스탬프 색상 상수
  static const _bgColor = Color(0x73000000);
  static const _white30 = Color(0x4DFFFFFF);

  // 'text' 모드 전용 — 배경 없이 텍스트 가독성용 그림자
  static const _textShadows = [
    Shadow(offset: Offset(0, 1), blurRadius: 4, color: Color(0xCC000000)),
    Shadow(offset: Offset(0, 0), blurRadius: 12, color: Color(0x99000000)),
    Shadow(offset: Offset(1, 1), blurRadius: 2, color: Color(0xB3000000)),
  ];

  Future<Uint8List> burnStamp({
    required String imagePath,
    required DateTime timestamp,
    required CameraPreset preset,
    required bool showTime,
    required bool showDate,
    required bool showAddress,
    required bool showGps,
    String? address,
    double? latitude,
    double? longitude,
    String? memo,
    bool showCompass = false,
    bool showAltitude = false,
    bool showSpeed = false,
    double? compassHeading,
    double? altitude,
    double? speed,
    String? logoPath,
    String? signaturePath,
    String dateFormat = 'YYYY.MM.DD',
    String secureBadgeText = 'SECURE · EXIF STRIPPED',
    List<String> weekdayNames = const ['월', '화', '수', '목', '금', '토', '일'],
    String stampColorHex = '#FFFFFF',
    String stampPosition = 'bottom',
    String stampLayout = 'text', // 'bar' | 'card' | 'text' (기본 'text' = 배경 없이 그림자)
    String? projectName,
    String? weatherText,
    String? photoCode,
  }) async {
    // C11: 미래 timestamp 검증 — 기기 시간이 NTP보다 5분 이상 미래면 경고 (조작 가능성)
    final nowUtc = DateTime.now();
    if (timestamp.isAfter(nowUtc.add(const Duration(minutes: 5)))) {
      debugPrint(
          'StampBurn: suspicious future timestamp detected: $timestamp (now: $nowUtc)');
    }

    // 1. 원본 이미지 로드
    final file = File(imagePath);
    final bytes = await file.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;
    // C9: codec은 프레임 추출 후 즉시 dispose — 리소스 누수 방지
    codec.dispose();
    ui.Image? resultImage;

    final imgW = image.width.toDouble();
    final imgH = image.height.toDouble();

    // 2. Canvas에 원본 그리기
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, imgW, imgH));
    canvas.drawImage(image, Offset.zero, Paint());

    // 3. scale: 375 = 프로토타입 기준 폰 너비
    final scale = imgW / 375.0;
    final isSecure = preset == CameraPreset.secure;
    // 'text' 모드: 배경 사각형 없이 그림자 가독성으로만 렌더 (사진 전체가 보임)
    final isTextMode = stampLayout == 'text';
    final List<Shadow>? ts = isTextMode ? _textShadows : null;
    // text 모드에서는 반투명 텍스트가 읽기 어려우므로 알파값을 전부 1.0에 가깝게 올림
    double alpha(double original) => isTextMode
        ? (original * 0.4 + 0.6).clamp(0.0, 1.0)
        : original;

    final Color stampColor;
    stampColor = _parseColor(stampColorHex) ?? Colors.white;

    final padding = 16.0 * scale;
    final isTop = stampPosition == 'top';

    // ── 높이 계산을 위해 모든 TextPainter를 미리 생성 ──
    final painters = _StampPainters();

    // Row 1: 시간 (시인성 강화 — 34sp)
    if (showTime) {
      final h = timestamp.hour.toString().padLeft(2, '0');
      final m = timestamp.minute.toString().padLeft(2, '0');
      final s = timestamp.second.toString().padLeft(2, '0');

      painters.timeHhMm = _tp('$h:$m',
          fontSize: 34 * scale, fontWeight: FontWeight.w700, color: stampColor,
          shadows: ts);
      painters.timeSs = _tp(':$s',
          fontSize: 18 * scale, color: stampColor.withValues(alpha: alpha(0.6)),
          shadows: ts);
    }

    // Row 1: 날짜 + 요일 (16sp)
    if (showDate) {
      final dateStr = _formatDateOnly(timestamp, dateFormat);
      final wd = weekdayNames[timestamp.weekday - 1];
      painters.date = _tp('$dateStr ($wd)',
          fontSize: 16 * scale, fontWeight: FontWeight.w600,
          color: stampColor.withValues(alpha: alpha(0.85)),
          shadows: ts);
    }

    // Row 1: 주소 + GPS (15sp / 12sp)
    if (!isSecure) {
      if (showAddress && address != null && address.isNotEmpty) {
        painters.address = _tp(address,
            fontSize: 15 * scale, fontWeight: FontWeight.w500,
            color: stampColor.withValues(alpha: alpha(0.8)),
            maxWidth: imgW * 0.45,
            shadows: ts);
      }
      if (showGps && latitude != null && longitude != null) {
        final lat = latitude;
        final lng = longitude;
        final latDir = lat >= 0 ? 'N' : 'S';
        final lngDir = lng >= 0 ? 'E' : 'W';
        final gps =
            '${lat.abs().toStringAsFixed(4)}°$latDir  ${lng.abs().toStringAsFixed(4)}°$lngDir';
        painters.gps = _tp(gps,
            fontSize: 12 * scale, color: stampColor.withValues(alpha: alpha(0.55)),
            letterSpacing: 0.3, shadows: ts);
      }
    }

    // 메모 (14sp, 주소와 비슷하지만 볼드로 구분) — M10: 최대 3줄까지 허용
    if (!isSecure && memo != null && memo.isNotEmpty) {
      painters.memo = _tp(memo,
          fontSize: 14 * scale, fontWeight: FontWeight.w600,
          color: stampColor.withValues(alpha: alpha(0.9)),
          maxWidth: imgW * 0.5,
          maxLines: 3,
          shadows: ts);
    }

    // 오버레이: 나침반 / 해발 / 속도 (12sp)
    if (!isSecure) {
      final overlayParts = <String>[];
      if (showCompass && compassHeading != null) {
        overlayParts.add('${compassHeading.toStringAsFixed(0)}°');
      }
      if (showAltitude && altitude != null) {
        overlayParts.add('${altitude.toStringAsFixed(1)}m');
      }
      if (showSpeed && speed != null) {
        overlayParts.add('${(speed * 3.6).toStringAsFixed(1)}km/h');
      }
      if (overlayParts.isNotEmpty) {
        painters.overlay = _tp(overlayParts.join('  '),
            fontSize: 12 * scale, color: stampColor.withValues(alpha: alpha(0.55)),
            letterSpacing: 0.3, shadows: ts);
      }
    }

    // 날씨
    if (!isSecure && weatherText != null && weatherText.isNotEmpty) {
      painters.weather = _tp(weatherText,
          fontSize: 11 * scale, color: stampColor.withValues(alpha: alpha(0.5)),
          shadows: ts);
    }

    // 고유 사진 코드
    if (photoCode != null && photoCode.isNotEmpty) {
      painters.code = _tp(photoCode,
          fontSize: 9 * scale, color: stampColor.withValues(alpha: alpha(0.3)),
          letterSpacing: 0.5, shadows: ts);
    }

    // 보안 뱃지 (11sp)
    if (isSecure) {
      painters.secureBadge = _tp(secureBadgeText,
          fontSize: 11 * scale, fontWeight: FontWeight.w700,
          color: stampColor, letterSpacing: 0.8, shadows: ts);
      if (projectName != null && projectName.isNotEmpty) {
        painters.secureProject = _tp(projectName,
            fontSize: 14 * scale, color: stampColor.withValues(alpha: alpha(0.7)),
            shadows: ts);
      }
      final seq = '#${timestamp.hour.toString().padLeft(2, '0')}${timestamp.minute.toString().padLeft(2, '0')}';
      painters.secureId = _tp(seq,
          fontSize: 11 * scale, color: _white30, shadows: ts);
    }

    // 로고 — codec dispose 포함
    ui.Image? logoImage;
    if (logoPath != null && logoPath.isNotEmpty) {
      try {
        final logoFile = File(logoPath);
        if (await logoFile.exists()) {
          final logoBytes = await logoFile.readAsBytes();
          final logoCodec = await ui.instantiateImageCodec(
            logoBytes, targetWidth: (40 * scale).toInt());
          final logoFrame = await logoCodec.getNextFrame();
          logoImage = logoFrame.image;
          logoCodec.dispose();
        }
      } catch (e) { debugPrint('Error: $e'); }
    }

    // 서명 — codec dispose 포함
    ui.Image? sigImage;
    if (signaturePath != null && signaturePath.isNotEmpty) {
      try {
        final sigFile = File(signaturePath);
        if (await sigFile.exists()) {
          final sigBytes = await sigFile.readAsBytes();
          final sigCodec = await ui.instantiateImageCodec(
            sigBytes, targetWidth: (80 * scale).toInt());
          final sigFrame = await sigCodec.getNextFrame();
          sigImage = sigFrame.image;
          sigCodec.dispose();
        }
      } catch (e) { debugPrint('Error: $e'); }
    }

    // ── 바 높이 계산 ──
    double barHeight = padding * 2; // top + bottom padding

    // 좌측 블록: 시간 + 날짜 (세로 배치)
    double leftBlockHeight = 0;
    if (painters.timeHhMm != null) {
      leftBlockHeight += painters.timeHhMm!.height;
    }
    if (painters.date != null) {
      leftBlockHeight += (painters.timeHhMm != null ? 2 * scale : 0) + painters.date!.height;
    }

    // 우측 블록: 주소 + GPS + 메모 (세로 배치)
    double rightBlockHeight = 0;
    if (painters.address != null) {
      rightBlockHeight += painters.address!.height;
    }
    if (painters.gps != null) {
      rightBlockHeight += (painters.address != null ? 2 * scale : 0) + painters.gps!.height;
    }
    if (!isSecure && painters.memo != null) {
      rightBlockHeight += 6 * scale + painters.memo!.height;
    }

    final row1Height = leftBlockHeight > rightBlockHeight ? leftBlockHeight : rightBlockHeight;
    barHeight += row1Height;

    // 오버레이 행 (나침반/해발/속도)
    if (painters.overlay != null) {
      barHeight += 6 * scale + painters.overlay!.height;
    }

    // 날씨 + 코드 행
    if (painters.weather != null || painters.code != null) {
      barHeight += 4 * scale;
      barHeight += (painters.weather?.height ?? painters.code?.height ?? 0);
    }

    // 보안 뱃지
    if (painters.secureBadge != null) {
      barHeight += painters.secureBadge!.height + 8 * scale;
    }

    // 보안 프로젝트 (메모는 우측에 포함됨)
    final hasRow2 = isSecure && (painters.secureProject != null || painters.secureId != null);
    if (hasRow2) {
      barHeight += 6 * scale;
      barHeight += (painters.secureProject?.height ?? painters.secureId?.height ?? 0);
    }

    // 로고/서명
    if (logoImage != null || sigImage != null) {
      barHeight += 8 * scale;
      final logoH = logoImage?.height.toDouble() ?? 0;
      final sigH = sigImage?.height.toDouble() ?? 0;
      barHeight += logoH > sigH ? logoH : sigH;
    }

    // ── 바 그리기 ──
    final barTop = isTop ? 0.0 : imgH - barHeight;
    // 'text' 모드: 배경 사각형 스킵 → 사진이 전부 보임.
    //             가독성은 텍스트 shadow로 확보.
    if (!isTextMode) {
      final bgPaint = Paint()..color = _bgColor;
      canvas.drawRect(
        Rect.fromLTWH(0, barTop, imgW, barHeight),
        bgPaint,
      );
    }

    double y = barTop + padding;

    // 보안 뱃지 (상단)
    if (painters.secureBadge != null) {
      painters.secureBadge!.paint(canvas, Offset(padding, y));
      y += painters.secureBadge!.height + 8 * scale;
    }

    // ── 좌측: 시간 + 날짜 (세로) ──
    final row1Y = y;
    double leftY = row1Y;

    if (painters.timeHhMm != null) {
      painters.timeHhMm!.paint(canvas, Offset(padding, leftY));

      if (painters.timeSs != null) {
        final baselineY = leftY + painters.timeHhMm!.height * 0.82;
        final ssY = baselineY - painters.timeSs!.height * 0.82;
        painters.timeSs!.paint(canvas, Offset(padding + painters.timeHhMm!.width, ssY));
      }
      leftY += painters.timeHhMm!.height + 2 * scale;
    }

    if (painters.date != null) {
      painters.date!.paint(canvas, Offset(padding, leftY));
    }

    // ── 우측: 메모(상단) → 주소+GPS(하단) ──
    {
      final rightPadding = padding;
      double rightY = row1Y;

      // 메모 — 우상단 (크게, 잘 보이게)
      if (!isSecure && painters.memo != null) {
        final memoX = imgW - rightPadding - painters.memo!.width;
        painters.memo!.paint(canvas, Offset(memoX > padding ? memoX : padding, rightY));
        rightY += painters.memo!.height + 8 * scale;
      }

      // 주소 + GPS — 우하단 (작게)
      // 하단 정렬: row1Height 끝에서 위치 블록 높이만큼 위로
      final locBlockHeight = (painters.address != null ? painters.address!.height + 2 * scale : 0)
          + (painters.gps != null ? painters.gps!.height : 0);
      double locY = row1Y + row1Height - locBlockHeight;
      if (locY < rightY) locY = rightY; // 메모와 겹치지 않게

      if (painters.address != null) {
        final addrX = imgW - rightPadding - painters.address!.width;
        final dotPaint = Paint()..color = stampColor.withValues(alpha: 0.4);
        canvas.drawCircle(
          Offset(addrX - 8 * scale, locY + painters.address!.height / 2),
          2 * scale,
          dotPaint,
        );
        painters.address!.paint(canvas, Offset(addrX, locY));
        locY += painters.address!.height + 2 * scale;
      }

      if (painters.gps != null) {
        final gpsX = imgW - rightPadding - painters.gps!.width;
        painters.gps!.paint(canvas, Offset(gpsX, locY));
      }
    }

    y += row1Height;

    // ── 오버레이 (나침반/해발/속도) ──
    if (painters.overlay != null) {
      y += 6 * scale;
      painters.overlay!.paint(canvas, Offset(padding, y));
      y += painters.overlay!.height;
    }

    // ── 날씨 + 사진 코드 ──
    if (painters.weather != null || painters.code != null) {
      y += 4 * scale;
      if (painters.weather != null) {
        painters.weather!.paint(canvas, Offset(padding, y));
      }
      if (painters.code != null) {
        final codeX = imgW - padding - painters.code!.width;
        painters.code!.paint(canvas, Offset(codeX, y));
      }
      y += (painters.weather?.height ?? painters.code?.height ?? 0);
    }

    // ── 보안 프로젝트 ──
    if (hasRow2) {
      y += 6 * scale;
      if (painters.secureProject != null) {
        painters.secureProject!.paint(canvas, Offset(padding + 16 * scale, y));
      }
      if (painters.secureId != null) {
        final idX = imgW - padding - painters.secureId!.width;
        painters.secureId!.paint(canvas, Offset(idX, y));
      }
      y += (painters.secureProject?.height ?? painters.secureId?.height ?? 0);
    }

    // ── 로고 + 서명 (수평 배치) ──
    if (logoImage != null || sigImage != null) {
      y += 8 * scale;
      double logoX = padding;
      if (logoImage != null) {
        canvas.drawImage(logoImage, Offset(logoX, y), Paint());
        logoX += logoImage.width + 12 * scale;
      }
      if (sigImage != null) {
        canvas.drawImage(
          sigImage,
          Offset(logoX, y),
          Paint()..filterQuality = FilterQuality.high,
        );
      }
    }

    // ── 모든 painter dispose ──
    painters.disposeAll();

    // 4. 이미지 인코딩 — try-finally로 리소스 누수 방지
    try {
      final picture = recorder.endRecording();
      resultImage = await picture.toImage(image.width, image.height);

      final Uint8List resultBytes;
      if (isSecure) {
        final byteData =
            await resultImage.toByteData(format: ui.ImageByteFormat.png);
        if (byteData == null) throw Exception('Failed to encode image');
        resultBytes = byteData.buffer.asUint8List();
      } else {
        final byteData =
            await resultImage.toByteData(format: ui.ImageByteFormat.rawRgba);
        if (byteData == null) throw Exception('Failed to encode image');
        resultBytes = await _encodeJpeg(
          byteData.buffer.asUint8List(),
          image.width,
          image.height,
        );
      }

      return resultBytes;
    } finally {
      image.dispose();
      resultImage?.dispose();
      logoImage?.dispose();
      sigImage?.dispose();
    }
  }

  // ── 유틸 ──

  TextPainter _tp(
    String text, {
    required double fontSize,
    required Color color,
    FontWeight fontWeight = FontWeight.w400,
    double letterSpacing = 0,
    FontStyle fontStyle = FontStyle.normal,
    double? maxWidth,
    int maxLines = 2,
    List<Shadow>? shadows,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: _monoFont,
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          letterSpacing: letterSpacing,
          fontStyle: fontStyle,
          shadows: shadows,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: maxLines,
      ellipsis: '…',
    )..layout(maxWidth: maxWidth ?? double.infinity);
    return tp;
  }

  String _formatDateOnly(DateTime ts, String format) {
    final y = ts.year.toString();
    final mo = ts.month.toString().padLeft(2, '0');
    final d = ts.day.toString().padLeft(2, '0');
    return switch (format) {
      'MM/DD/YYYY' => '$mo/$d/$y',
      'DD-MM-YYYY' => '$d-$mo-$y',
      _ => '$y.$mo.$d',
    };
  }

  Color? _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (e) {
      return null;
    }
  }

  Future<Uint8List> _encodeJpeg(
      Uint8List rgbaBytes, int width, int height) async {
    return compute(_encodeJpegIsolate, _JpegEncodeParams(
      rgbaBytes: rgbaBytes,
      width: width,
      height: height,
      quality: _jpegQuality,
    ));
  }

  static Uint8List _encodeJpegIsolate(_JpegEncodeParams params) {
    final image = img.Image.fromBytes(
      width: params.width,
      height: params.height,
      bytes: params.rgbaBytes.buffer,
      order: img.ChannelOrder.rgba,
    );
    return Uint8List.fromList(
        img.encodeJpg(image, quality: params.quality));
  }
}

/// 번인에 사용되는 TextPainter 모음 — 한 번에 dispose
class _StampPainters {
  TextPainter? timeHhMm;
  TextPainter? timeSs;
  TextPainter? date;
  TextPainter? address;
  TextPainter? gps;
  TextPainter? memo;
  TextPainter? overlay;
  TextPainter? secureBadge;
  TextPainter? secureProject;
  TextPainter? secureId;
  TextPainter? weather;
  TextPainter? code;

  void disposeAll() {
    timeHhMm?.dispose();
    timeSs?.dispose();
    date?.dispose();
    address?.dispose();
    gps?.dispose();
    memo?.dispose();
    overlay?.dispose();
    secureBadge?.dispose();
    secureProject?.dispose();
    secureId?.dispose();
    weather?.dispose();
    code?.dispose();
  }
}

class _JpegEncodeParams {
  final Uint8List rgbaBytes;
  final int width;
  final int height;
  final int quality;

  const _JpegEncodeParams({
    required this.rgbaBytes,
    required this.width,
    required this.height,
    required this.quality,
  });
}
