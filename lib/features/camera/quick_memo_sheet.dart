/// Quick memo input sheet — 카메라 뷰파인더에서 한 번의 탭으로 진입.
/// 단일 TextField + autofocus + 저장 버튼만. 전체 StampEditSheet보다 가볍고 빠름.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:exacta/core/extensions/build_context_ext.dart';
import 'package:exacta/core/theme/app_colors.dart';

/// 바텀시트로 표시. 사용자가 저장 버튼을 누르면 새 메모 문자열을 반환,
/// 취소 또는 뒤로 가기면 null 반환.
Future<String?> showQuickMemoSheet({
  required BuildContext context,
  required String initialMemo,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: true,
    builder: (ctx) => _QuickMemoSheetContent(initialMemo: initialMemo),
  );
}

class _QuickMemoSheetContent extends StatefulWidget {
  const _QuickMemoSheetContent({required this.initialMemo});
  final String initialMemo;

  @override
  State<_QuickMemoSheetContent> createState() => _QuickMemoSheetContentState();
}

class _QuickMemoSheetContentState extends State<_QuickMemoSheetContent> {
  late final TextEditingController _controller;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialMemo);
    _controller.selection = TextSelection.collapsed(
      offset: _controller.text.length,
    );
    // 키보드 자동 열기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _save() {
    HapticFeedback.lightImpact();
    Navigator.of(context).pop(_controller.text.trim());
  }

  void _clear() {
    HapticFeedback.selectionClick();
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.darkBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 드래그 핸들
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: AppColors.darkBorderHi,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // 타이틀
                Row(
                  children: [
                    const Icon(LucideIcons.pencil,
                        size: 18, color: AppColors.darkAccent),
                    const SizedBox(width: 8),
                    Text(
                      widget.initialMemo.isEmpty
                          ? l.cameraMemoAdd
                          : l.cameraMemoEdit,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkText1,
                      ),
                    ),
                    const Spacer(),
                    if (_controller.text.isNotEmpty)
                      Semantics(
                        button: true,
                        label: l.commonDelete,
                        child: GestureDetector(
                          onTap: _clear,
                          behavior: HitTestBehavior.opaque,
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: Center(
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: AppColors.darkSurfaceHi,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(LucideIcons.x,
                                    size: 14, color: AppColors.darkText2),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // 입력 필드
                TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  maxLines: 4,
                  minLines: 3,
                  maxLength: 500,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) => _save(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.darkText1,
                    height: 1.4,
                  ),
                  decoration: InputDecoration(
                    hintText: l.cameraMemoPlaceholder,
                    hintStyle: const TextStyle(
                      color: AppColors.darkText3,
                      fontSize: 14,
                    ),
                    counterStyle: const TextStyle(
                      color: AppColors.darkText3,
                      fontSize: 10,
                    ),
                    filled: true,
                    fillColor: AppColors.darkSurfaceHi,
                    contentPadding: const EdgeInsets.all(14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: AppColors.darkAccent,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // 저장 버튼 (하단 전폭, 72dp CTA)
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Material(
                    color: AppColors.darkAccent,
                    borderRadius: BorderRadius.circular(16),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: _save,
                      child: Center(
                        child: Text(
                          l.commonSave,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
