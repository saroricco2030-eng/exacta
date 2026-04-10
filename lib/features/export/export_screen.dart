/// Export screen - select photos, share, ZIP, or PDF report
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';

import 'package:exacta/core/extensions/build_context_ext.dart';

import 'package:exacta/data/database.dart';
import 'package:exacta/data/providers.dart';
import 'package:exacta/services/pdf_report_service.dart';
import 'package:exacta/services/evidence_pack_service.dart';

class ExportScreen extends ConsumerStatefulWidget {
  const ExportScreen({super.key, this.projectId});
  final int? projectId;

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  final Set<int> _selectedIds = {};
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final photosAsync = ref.watch(photosByProjectProvider(widget.projectId));

    return Scaffold(
      backgroundColor: context.bg,
      appBar: AppBar(
        backgroundColor: context.bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft, color: context.text1),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l.exportTitle,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: context.text1,
          ),
        ),
        actions: [
          if (_selectedIds.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton(
                onPressed: () {
                  setState(() => _selectedIds.clear());
                },
                child: Text(
                  l.commonCancel,
                  style: TextStyle(color: context.text2),
                ),
              ),
            ),
        ],
      ),
      body: photosAsync.when(
        loading: () => Center(
          child: CircularProgressIndicator(
            color: context.accent, strokeWidth: 2,
          ),
        ),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.triangleAlert,
                  size: 48, color: context.danger),
              const SizedBox(height: 16),
              Text(l.commonError,
                  style: TextStyle(color: context.text2)),
              const SizedBox(height: 16),
              SizedBox(
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: () => ref.invalidate(
                      photosByProjectProvider(widget.projectId)),
                  icon: const Icon(LucideIcons.refreshCw, size: 18),
                  label: Text(l.commonRetry),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context.accent,
                    side: BorderSide(color: context.accent),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 32),
                  ),
                ),
              ),
            ],
          ),
        ),
        data: (photos) {
          final nonVideo = photos.where((p) => !p.isVideo).toList();
          if (nonVideo.isEmpty) {
            return Center(
              child: Text(l.exportNoPhotos,
                  style: TextStyle(color: context.text2)),
            );
          }

          return Column(
            children: [
              // 선택 카운터
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      _selectedIds.isEmpty
                          ? l.exportSelectPhotos
                          : l.exportSelectedCount(_selectedIds.length),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: context.text2,
                      ),
                    ),
                    const Spacer(),
                    // 전체 선택
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_selectedIds.length == nonVideo.length) {
                            _selectedIds.clear();
                          } else {
                            _selectedIds.addAll(
                                nonVideo.map((p) => p.id));
                          }
                        });
                      },
                      child: Text(
                        l.commonAll,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: context.accent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 사진 그리드
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: nonVideo.length,
                  itemBuilder: (context, index) {
                    final photo = nonVideo[index];
                    final isSelected = _selectedIds.contains(photo.id);
                    return Semantics(
                      button: true,
                      label: 'Photo ${index + 1}',
                      selected: isSelected,
                      child: GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() {
                          if (isSelected) {
                            _selectedIds.remove(photo.id);
                          } else if (_selectedIds.length < 50) {
                            _selectedIds.add(photo.id);
                          }
                        });
                      },
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(photo.filePath),
                              fit: BoxFit.cover,
                              cacheWidth: 300,
                              cacheHeight: 300,
                              errorBuilder: (ctx, e, st) => Container(
                                color: ctx.surfaceHi,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? context.accent
                                    : context.surface
                                        .withValues(alpha: 0.7),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? context.accent
                                      : context.text3,
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? Icon(LucideIcons.check,
                                      size: 14,
                                      color: context.onAccent)
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    );
                  },
                ),
              ),

              // 하단 액션
              if (_selectedIds.isNotEmpty)
                Container(
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 16,
                    bottom:
                        MediaQuery.paddingOf(context).bottom + 16,
                  ),
                  decoration: BoxDecoration(
                    color: context.surface,
                    border: Border(
                      top: BorderSide(color: context.border),
                    ),
                  ),
                  child: Row(
                    children: [
                      // 공유
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: context.btnGradient,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: _isExporting
                                    ? null
                                    : () => _shareSelected(nonVideo),
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(LucideIcons.share2,
                                          size: 18,
                                          color:
                                              context.onAccent),
                                      const SizedBox(width: 8),
                                      Text(
                                        l.exportShareSelected,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              context.onAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // ZIP
                      SizedBox(
                        width: 56,
                        height: 56,
                        child: Material(
                          color: context.accentDim,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: _isExporting
                                ? null
                                : () => _exportZip(nonVideo),
                            child: _isExporting
                                ? Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: context.accent,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                : Icon(LucideIcons.fileArchive,
                                    color: context.accent,
                                    size: 22),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // PDF
                      SizedBox(
                        width: 56,
                        height: 56,
                        child: Material(
                          color: context.accentDim,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: _isExporting
                                ? null
                                : () => _exportPdf(nonVideo),
                            child: Icon(LucideIcons.fileText,
                                color: context.accent,
                                size: 22),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // 증거 팩 PDF (SHA-256 체인)
                      SizedBox(
                        width: 56,
                        height: 56,
                        child: Material(
                          color: context.accentDim,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: _isExporting
                                ? null
                                : () => _exportEvidencePack(nonVideo),
                            child: Icon(LucideIcons.shieldCheck,
                                color: context.accent,
                                size: 22),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _shareSelected(List<Photo> allPhotos) async {
    final selected =
        allPhotos.where((p) => _selectedIds.contains(p.id)).toList();
    if (selected.isEmpty) return;

    final files = <XFile>[];
    for (final photo in selected) {
      if (await File(photo.filePath).exists()) {
        files.add(XFile(photo.filePath));
      }
    }

    if (files.isNotEmpty) {
      await Share.shareXFiles(files);
    }
  }

  Future<void> _exportZip(List<Photo> allPhotos) async {
    final l = context.l10n;
    final selected =
        allPhotos.where((p) => _selectedIds.contains(p.id)).toList();
    if (selected.isEmpty) return;

    setState(() => _isExporting = true);

    try {
      // 파일 바이트 읽기 (I/O는 메인 스레드에서 — Dart는 비동기 I/O)
      final entries = <_ZipEntry>[];
      for (final photo in selected) {
        final file = File(photo.filePath);
        if (!await file.exists()) continue;
        final bytes = await file.readAsBytes();
        entries.add(_ZipEntry(name: p.basename(photo.filePath), bytes: bytes));
      }

      // ZIP 인코딩은 CPU 바운드 → compute()로 백그라운드 isolate에서 실행
      final zipBytes = await compute(_encodeZipIsolate, entries);

      final tempDir = await getTemporaryDirectory();
      final now = DateTime.now();
      final zipName =
          'exacta_${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}.zip';
      final zipPath = p.join(tempDir.path, zipName);
      await File(zipPath).writeAsBytes(zipBytes);

      await Share.shareXFiles([XFile(zipPath)]);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.exportZipDone),
            backgroundColor: context.accent,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.commonError),
            backgroundColor: context.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _exportPdf(List<Photo> allPhotos) async {
    final l = context.l10n;
    final selected =
        allPhotos.where((p) => _selectedIds.contains(p.id)).toList();
    if (selected.isEmpty) return;

    setState(() => _isExporting = true);

    try {
      final pdfPath = await PdfReportService.generate(
        photos: selected,
        projectName: '${l.homeTitle} Report',
        locale: Localizations.localeOf(context).languageCode,
      );
      await Share.shareXFiles([XFile(pdfPath)]);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.pdfReportGenerated),
            backgroundColor: context.accent,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.commonError),
            backgroundColor: context.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  /// 증거 팩 PDF 내보내기 — 사건명/작성자 입력 다이얼로그 → PDF 생성 → 공유
  Future<void> _exportEvidencePack(List<Photo> allPhotos) async {
    final l = context.l10n;
    final selected =
        allPhotos.where((p) => _selectedIds.contains(p.id)).toList();
    if (selected.isEmpty) return;

    // 해시가 없는 사진은 증거 팩에 포함할 수 없음 — v10 이전 촬영분 필터링
    final withHash = selected.where((p) => p.photoHash != null).toList();
    if (withHash.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.evidenceNoHash),
          backgroundColor: context.danger,
        ),
      );
      return;
    }

    final meta = await _promptEvidenceMeta();
    if (meta == null) return;

    setState(() => _isExporting = true);

    try {
      final strings = _evidenceStringsFor(l);
      final pdfPath = await EvidencePackService.generate(
        photos: withHash,
        caseName: meta.caseName,
        author: meta.author,
        strings: strings,
      );
      await Share.shareXFiles([XFile(pdfPath)]);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.evidencePackGenerated),
            backgroundColor: context.accent,
          ),
        );
      }
    } catch (e) {
      debugPrint('Evidence pack failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.commonError),
            backgroundColor: context.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<_EvidenceMeta?> _promptEvidenceMeta() async {
    final l = context.l10n;
    final caseCtrl = TextEditingController();
    final authorCtrl = TextEditingController();
    final result = await showDialog<_EvidenceMeta>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(LucideIcons.shieldCheck, size: 20, color: ctx.accent),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l.evidenceExportTitle,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: ctx.text1,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.evidenceExportDesc,
              style: TextStyle(fontSize: 12, color: ctx.text3),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: caseCtrl,
              maxLength: 80,
              decoration: InputDecoration(
                labelText: l.evidenceCaseNameLabel,
                hintText: l.evidenceCaseNamePlaceholder,
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: authorCtrl,
              maxLength: 40,
              decoration: InputDecoration(
                labelText: l.evidenceAuthorLabel,
                hintText: l.evidenceAuthorPlaceholder,
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            onPressed: () {
              final caseName = caseCtrl.text.trim();
              final author = authorCtrl.text.trim();
              if (caseName.isEmpty || author.isEmpty) return;
              Navigator.pop(
                ctx,
                _EvidenceMeta(caseName: caseName, author: author),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: ctx.accent,
              foregroundColor: ctx.onAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(l.evidenceGenerate),
          ),
        ],
      ),
    );
    caseCtrl.dispose();
    authorCtrl.dispose();
    return result;
  }

  EvidencePackStrings _evidenceStringsFor(dynamic l) {
    return EvidencePackStrings(
      cover: l.evidencePackCover,
      caseName: l.evidencePackCaseName,
      author: l.evidencePackAuthor,
      generatedAt: l.evidencePackGeneratedAt,
      photoCount: l.evidencePackPhotoCount,
      hashAlgo: l.evidencePackHashAlgo,
      ntpNote: l.evidencePackNtpNote,
      photoTitle: (i) => l.evidencePackPhotoTitle(i),
      timestamp: l.evidencePackTimestamp,
      gps: l.evidencePackGps,
      address: l.evidencePackAddress,
      project: l.evidencePackProject,
      memo: l.evidencePackMemo,
      photoHash: l.evidencePackPhotoHash,
      chainHash: l.evidencePackChainHash,
      prevHash: l.evidencePackPrevHash,
      verifyTitle: l.evidencePackVerifyTitle,
      verifyStep1: l.evidencePackVerifyStep1,
      verifyStep2: l.evidencePackVerifyStep2,
      verifyStep3: l.evidencePackVerifyStep3,
      verifyStep4: l.evidencePackVerifyStep4,
    );
  }
}

class _EvidenceMeta {
  final String caseName;
  final String author;
  const _EvidenceMeta({required this.caseName, required this.author});
}

class _ZipEntry {
  final String name;
  final Uint8List bytes;
  const _ZipEntry({required this.name, required this.bytes});
}

Uint8List _encodeZipIsolate(List<_ZipEntry> entries) {
  final archive = Archive();
  for (final entry in entries) {
    archive.addFile(ArchiveFile(entry.name, entry.bytes.length, entry.bytes));
  }
  return Uint8List.fromList(ZipEncoder().encode(archive));
}
