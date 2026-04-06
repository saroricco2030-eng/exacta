/// Project create/edit form - full screen with Scaffold keyboard handling
import 'dart:math';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:exacta/core/enums.dart';
import 'package:exacta/core/extensions/build_context_ext.dart';
import 'package:exacta/data/database.dart';

class ProjectFormSheet extends StatefulWidget {
  const ProjectFormSheet({super.key, this.project});
  final Project? project;

  @override
  State<ProjectFormSheet> createState() => _ProjectFormSheetState();
}

class _ProjectFormSheetState extends State<ProjectFormSheet> {
  late final TextEditingController _nameController;
  int _selectedColorIndex = 0;
  bool _isSaving = false;

  bool get _isEdit => widget.project != null;

  static const _colorOptions = [
    '#FF9B7B', '#B8A0E8', '#7ECBB4', '#F0C078',
    '#EF5350', '#42A5F5', '#66BB6A', '#AB47BC',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project?.name ?? '');
    if (_isEdit && widget.project!.color != null) {
      final idx = _colorOptions.indexOf(widget.project!.color!);
      if (idx >= 0) _selectedColorIndex = idx;
    } else {
      // 신규 프로젝트: 기존 프로젝트와 겹치지 않는 색 자동 선택
      _autoPickUnusedColor();
    }
  }

  Future<void> _autoPickUnusedColor() async {
    final all = await AppDatabase.instance.getAllProjects();
    final used = all.map((p) => p.color).whereType<String>().toSet();
    final unusedIndexes = <int>[];
    for (var i = 0; i < _colorOptions.length; i++) {
      if (!used.contains(_colorOptions[i])) unusedIndexes.add(i);
    }
    if (unusedIndexes.isEmpty) {
      // 모든 색이 사용 중 — 랜덤
      final rand = Random();
      if (mounted) {
        setState(() => _selectedColorIndex = rand.nextInt(_colorOptions.length));
      }
    } else {
      final rand = Random();
      if (mounted) {
        setState(() =>
            _selectedColorIndex = unusedIndexes[rand.nextInt(unusedIndexes.length)]);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final l = context.l10n;

    // 이름 검증 — 공백 제거 후 1~50자
    if (name.isEmpty) {
      _showError(l.projectNameTooShort);
      return;
    }
    if (name.length > 50) {
      _showError(l.projectNameTooLong);
      return;
    }

    setState(() => _isSaving = true);

    final db = AppDatabase.instance;

    // 중복 이름 검증 (자기 자신 제외)
    try {
      final dup = await db.getProjectByName(name,
          excludeId: _isEdit ? widget.project!.id : null);
      if (dup != null) {
        if (mounted) {
          setState(() => _isSaving = false);
          _showError(l.projectNameDuplicate);
        }
        return;
      }
    } catch (e) {
      debugPrint('Project duplicate check failed: $e');
      // 중복 검사 실패 시 저장은 계속 진행 (비치명적)
    }

    final now = DateTime.now().toIso8601String();
    final color = _colorOptions[_selectedColorIndex];

    try {
      if (_isEdit) {
        await db.updateProject(ProjectsCompanion(
          id: Value(widget.project!.id),
          name: Value(name),
          color: Value(color),
          startDate: Value(widget.project!.startDate),
          endDate: Value(widget.project!.endDate),
          status: Value(widget.project!.status),
          createdAt: Value(widget.project!.createdAt),
          updatedAt: Value(now),
        ));
      } else {
        await db.insertProject(ProjectsCompanion.insert(
          name: name,
          color: Value(color),
          startDate: Value(now),
          status: Value(ProjectStatus.active.value),
          createdAt: now,
          updatedAt: now,
        ));
      }
      HapticFeedback.mediumImpact();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      debugPrint('Project save failed: $e');
      if (mounted) {
        setState(() => _isSaving = false);
        _showError(_isEdit ? l.updateError : l.saveError);
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: context.danger,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;

    // Scaffold가 키보드를 네이티브 레벨에서 처리 — Flutter rebuild 없음
    return Scaffold(
      backgroundColor: context.bg,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: context.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.x, color: context.text1),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isEdit ? l.commonEdit : l.projectsNew,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.text1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              autofocus: true,
              maxLength: 50,
              style: TextStyle(fontSize: 15, color: context.text1),
              decoration: InputDecoration(
                hintText: l.projectNameHint,
                counterText: '',
                contentPadding: const EdgeInsets.all(16),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: Icon(LucideIcons.folderOpen, size: 18, color: context.text3),
                ),
                prefixIconConstraints: const BoxConstraints(minWidth: 42, minHeight: 0),
              ),
            ),
            const SizedBox(height: 24),

            Wrap(
              spacing: 12, runSpacing: 12,
              children: List.generate(_colorOptions.length, (i) {
                final hex = _colorOptions[i];
                final color = Color(int.parse(hex.replaceFirst('#', '0xFF')));
                final isActive = i == _selectedColorIndex;
                return GestureDetector(
                  onTap: () { HapticFeedback.selectionClick(); setState(() => _selectedColorIndex = i); },
                  child: Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: color, shape: BoxShape.circle,
                      border: isActive
                          ? Border.all(color: context.text1, width: 3)
                          : (color.computeLuminance() > 0.8
                              ? Border.all(color: context.border, width: 1.5) : null),
                    ),
                    child: isActive
                        ? Icon(LucideIcons.check, size: 18,
                            color: color.computeLuminance() > 0.5 ? Colors.black87 : Colors.white)
                        : null,
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity, height: 56,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: context.btnGradient),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: _isSaving ? null : _save,
                    child: Center(
                      child: _isSaving
                          ? SizedBox(width: 20, height: 20,
                              child: CircularProgressIndicator(color: context.onAccent, strokeWidth: 2))
                          : Text(l.commonSave,
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.onAccent)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
