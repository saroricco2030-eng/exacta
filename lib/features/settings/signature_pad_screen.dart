/// Signature drawing pad - canvas strokes saved as PNG
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'package:exacta/core/extensions/build_context_ext.dart';
import 'package:exacta/core/theme/app_colors.dart';

class SignaturePadScreen extends StatefulWidget {
  const SignaturePadScreen({super.key});

  @override
  State<SignaturePadScreen> createState() => _SignaturePadScreenState();
}

class _SignaturePadScreenState extends State<SignaturePadScreen> {
  final List<List<Offset>> _strokes = [];
  List<Offset> _currentStroke = [];
  bool _isSaving = false;

  void _onPanStart(DragStartDetails details) {
    _currentStroke = [details.localPosition];
    setState(() {});
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _currentStroke.add(details.localPosition);
    setState(() {});
  }

  void _onPanEnd(DragEndDetails details) {
    _strokes.add(List.from(_currentStroke));
    _currentStroke = [];
    setState(() {});
  }

  void _clear() {
    setState(() {
      _strokes.clear();
      _currentStroke = [];
    });
  }

  Future<void> _save() async {
    if (_strokes.isEmpty) return;
    setState(() => _isSaving = true);

    try {
      // Canvas에 서명 렌더링
      const width = 512.0;
      const height = 256.0;

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(
        recorder,
        const Rect.fromLTWH(0, 0, width, height),
      );

      // 투명 배경
      canvas.drawRect(
        const Rect.fromLTWH(0, 0, width, height),
        Paint()..color = AppColors.transparent,
      );

      // 서명 그리기
      final paint = Paint()
        ..color = AppColors.lightText1
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      // 패드 영역 → 512x256 스케일 변환
      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox == null) return;

      // 패드 영역 크기 계산 (대략 화면 너비 - 48 패딩, 높이 300)
      final padWidth = renderBox.size.width - 48;
      const padHeight = 300.0;
      final scaleX = width / padWidth;
      final scaleY = height / padHeight;

      for (final stroke in _strokes) {
        if (stroke.length < 2) continue;
        final path = Path()
          ..moveTo(stroke.first.dx * scaleX, stroke.first.dy * scaleY);
        for (var i = 1; i < stroke.length; i++) {
          path.lineTo(stroke[i].dx * scaleX, stroke[i].dy * scaleY);
        }
        canvas.drawPath(path, paint);
      }

      final picture = recorder.endRecording();
      final image = await picture.toImage(width.toInt(), height.toInt());
      final byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();

      if (byteData == null) return;

      // 파일 저장
      final appDir = await getApplicationDocumentsDirectory();
      final assetsDir = Directory(p.join(appDir.path, 'assets'));
      if (!await assetsDir.exists()) await assetsDir.create(recursive: true);
      final filePath = p.join(assetsDir.path, 'signature.png');
      await File(filePath).writeAsBytes(
        byteData.buffer.asUint8List(),
      );

      if (mounted) Navigator.pop(context, filePath);
    } catch (e) {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;

    return Scaffold(
      backgroundColor: context.bg,
      appBar: AppBar(
        backgroundColor: context.bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.x, color: context.text1),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l.stampSignatureDraw,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: context.text1,
          ),
        ),
        actions: [
          // 지우기
          IconButton(
            icon: Icon(LucideIcons.eraser, color: context.text2),
            onPressed: _clear,
          ),
          // 저장
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: _isSaving ? null : _save,
              child: Text(
                l.commonSave,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _strokes.isEmpty
                      ? context.text3
                      : context.accent,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // 서명 캔버스
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: context.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.border),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: GestureDetector(
                    onPanStart: _onPanStart,
                    onPanUpdate: _onPanUpdate,
                    onPanEnd: _onPanEnd,
                    child: CustomPaint(
                      painter: _SignaturePainter(
                        strokes: _strokes,
                        currentStroke: _currentStroke,
                      ),
                      size: Size.infinite,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l.stampSignatureDraw,
              style: TextStyle(
                fontSize: 12,
                color: context.text3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignaturePainter extends CustomPainter {
  _SignaturePainter({
    required this.strokes,
    required this.currentStroke,
  });

  final List<List<Offset>> strokes;
  final List<Offset> currentStroke;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.lightText1
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      _drawStroke(canvas, stroke, paint);
    }
    if (currentStroke.isNotEmpty) {
      _drawStroke(canvas, currentStroke, paint);
    }
  }

  void _drawStroke(Canvas canvas, List<Offset> stroke, Paint paint) {
    if (stroke.length < 2) return;
    final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
    for (var i = 1; i < stroke.length; i++) {
      path.lineTo(stroke[i].dx, stroke[i].dy);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) => true;
}
