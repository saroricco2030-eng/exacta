/// Stamp editor - 12 preset templates + individual toggles + memo/tags + project select
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:exacta/core/enums.dart';
import 'package:exacta/core/extensions/build_context_ext.dart';
import 'package:exacta/core/theme/app_colors.dart';
import 'package:exacta/data/database.dart';
import 'package:exacta/features/camera/widgets/toggle_chip.dart';

class StampEditSheet extends StatefulWidget {
  const StampEditSheet({
    super.key,
    required this.showTime,
    required this.showDate,
    required this.showAddress,
    required this.showGps,
    required this.memo,
    required this.tags,
    required this.showCompass,
    required this.showAltitude,
    required this.showSpeed,
    required this.isSecureMode,
    required this.onChanged,
    this.selectedProjectId,
    this.onProjectChanged,
  });

  final bool showTime;
  final bool showDate;
  final bool showAddress;
  final bool showGps;
  final String memo;
  final String tags;
  final bool showCompass;
  final bool showAltitude;
  final bool showSpeed;
  final bool isSecureMode;
  final int? selectedProjectId;
  final ValueChanged<int?>? onProjectChanged;
  final void Function({
    bool? showTime,
    bool? showDate,
    bool? showAddress,
    bool? showGps,
    String? memo,
    String? tags,
    bool? showCompass,
    bool? showAltitude,
    bool? showSpeed,
  }) onChanged;

  @override
  State<StampEditSheet> createState() => _StampEditSheetState();
}

class _StampEditSheetState extends State<StampEditSheet> {
  late bool _showTime;
  late bool _showDate;
  late bool _showAddress;
  late bool _showGps;
  late bool _showCompass;
  late bool _showAltitude;
  late bool _showSpeed;
  late final TextEditingController _memoController;
  late final TextEditingController _tagsController;
  List<Project> _projects = [];

  @override
  void initState() {
    super.initState();
    _showTime = widget.showTime;
    _showDate = widget.showDate;
    _showAddress = widget.showAddress;
    _showGps = widget.showGps;
    _showCompass = widget.showCompass;
    _showAltitude = widget.showAltitude;
    _showSpeed = widget.showSpeed;
    _memoController = TextEditingController(text: widget.memo);
    _tagsController = TextEditingController(text: widget.tags);
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    final projects = await AppDatabase.instance.getProjectsByStatus(ProjectStatus.active.value);
    if (mounted) setState(() => _projects = projects);
  }

  @override
  void dispose() {
    _memoController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _applyPreset(_StampPreset p) {
    setState(() {
      _showTime = p.time; _showDate = p.date; _showAddress = p.address;
      _showGps = p.gps; _showCompass = p.compass; _showAltitude = p.altitude; _showSpeed = p.speed;
    });
    widget.onChanged(
      showTime: _showTime, showDate: _showDate, showAddress: _showAddress,
      showGps: _showGps, showCompass: _showCompass, showAltitude: _showAltitude, showSpeed: _showSpeed,
    );
    HapticFeedback.mediumImpact();
  }

  static final _presets = [
    _StampPreset('Full',        LucideIcons.layers,      time: true,  date: true,  address: true,  gps: true,  compass: true,  altitude: true,  speed: true),
    _StampPreset('Construction',LucideIcons.hardHat,     time: true,  date: true,  address: true,  gps: true,  compass: false, altitude: false, speed: false),
    _StampPreset('Inspection',  LucideIcons.clipboardCheck, time: true, date: true, address: true,  gps: true,  compass: true,  altitude: true,  speed: false),
    _StampPreset('Delivery',    LucideIcons.truck,       time: true,  date: true,  address: true,  gps: true,  compass: false, altitude: false, speed: true),
    _StampPreset('Real Estate', LucideIcons.house,       time: true,  date: true,  address: true,  gps: true,  compass: true,  altitude: true,  speed: false),
    _StampPreset('Outdoor',     LucideIcons.mountain,    time: true,  date: true,  address: false, gps: true,  compass: true,  altitude: true,  speed: true),
    _StampPreset('Navigation',  LucideIcons.compass,     time: true,  date: false, address: true,  gps: true,  compass: true,  altitude: false, speed: true),
    _StampPreset('Location',    LucideIcons.mapPin,      time: true,  date: true,  address: true,  gps: true,  compass: false, altitude: false, speed: false),
    _StampPreset('Minimal',     LucideIcons.minus,       time: true,  date: true,  address: false, gps: false, compass: false, altitude: false, speed: false),
    _StampPreset('Time Only',   LucideIcons.clock,       time: true,  date: false, address: false, gps: false, compass: false, altitude: false, speed: false),
    _StampPreset('GPS Only',    LucideIcons.satellite,   time: false, date: false, address: false, gps: true,  compass: false, altitude: false, speed: false),
    _StampPreset('Clean',       LucideIcons.sparkles,    time: true,  date: true,  address: false, gps: false, compass: false, altitude: false, speed: false),
  ];

  void _toggle(String field) {
    setState(() {
      switch (field) {
        case 'time':
          _showTime = !_showTime;
          widget.onChanged(showTime: _showTime);
        case 'date':
          _showDate = !_showDate;
          widget.onChanged(showDate: _showDate);
        case 'address':
          if (!widget.isSecureMode) {
            _showAddress = !_showAddress;
            widget.onChanged(showAddress: _showAddress);
          }
        case 'gps':
          if (!widget.isSecureMode) {
            _showGps = !_showGps;
            widget.onChanged(showGps: _showGps);
          }
        case 'compass':
          if (!widget.isSecureMode) {
            _showCompass = !_showCompass;
            widget.onChanged(showCompass: _showCompass);
          }
        case 'altitude':
          if (!widget.isSecureMode) {
            _showAltitude = !_showAltitude;
            widget.onChanged(showAltitude: _showAltitude);
          }
        case 'speed':
          if (!widget.isSecureMode) {
            _showSpeed = !_showSpeed;
            widget.onChanged(showSpeed: _showSpeed);
          }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
        child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 드래그 핸들
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.darkBorderHi,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // 타이틀
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Text(
                  l.stampEditTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkText1,
                  ),
                ),
                const Spacer(),
                Semantics(
                  button: true,
                  label: 'Close',
                  child: GestureDetector(
                  onTap: () { HapticFeedback.lightImpact(); Navigator.of(context).pop(); },
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: Center(child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.darkSurfaceHi,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.x,
                      size: 18,
                      color: AppColors.darkText2,
                    ),
                  )), // Center+Container
                  ), // SizedBox
                  ), // GestureDetector
                ), // Semantics
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── 메모 입력 — M5: 최대 500자 제한 ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: TextField(
              controller: _memoController,
              onChanged: (v) => widget.onChanged(memo: v),
              maxLength: 500,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.darkText1,
              ),
              maxLines: 3,
              minLines: 1,
              decoration: InputDecoration(
                hintText: l.stampMemoPlaceholder,
                hintStyle: const TextStyle(color: AppColors.darkText3),
                counterStyle: const TextStyle(color: AppColors.darkText3, fontSize: 10),
                filled: true,
                fillColor: AppColors.darkSurfaceHi,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ── 태그 입력 — M5: 최대 200자 제한 ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: TextField(
              controller: _tagsController,
              onChanged: (v) => widget.onChanged(tags: v),
              maxLength: 200,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.darkText1,
              ),
              decoration: InputDecoration(
                hintText: l.stampTagsPlaceholder,
                hintStyle: const TextStyle(color: AppColors.darkText3),
                counterText: '',
                filled: true,
                fillColor: AppColors.darkSurfaceHi,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ── 프로젝트 선택 ──
          if (_projects.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                l.stampProject,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkText2,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _projects.length + 1, // +1 for "없음"
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    final isActive = widget.selectedProjectId == null;
                    return GestureDetector(
                      onTap: () => widget.onProjectChanged?.call(null),
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.darkAccentDim
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isActive
                                ? AppColors.darkAccent.withValues(alpha: 0.3)
                                : AppColors.darkBorder,
                          ),
                        ),
                        child: Text(
                          l.galleryNoProject,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                isActive ? FontWeight.w600 : FontWeight.w400,
                            color: isActive
                                ? AppColors.darkAccent
                                : AppColors.darkText3,
                          ),
                        ),
                      ),
                    );
                  }
                  final project = _projects[index - 1];
                  final isActive = widget.selectedProjectId == project.id;
                  final projectColor = project.color != null
                      ? Color(
                          int.parse(project.color!.replaceFirst('#', '0xFF')))
                      : AppColors.darkAccent;
                  return GestureDetector(
                    onTap: () => widget.onProjectChanged?.call(project.id),
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isActive
                            ? projectColor.withValues(alpha: 0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isActive
                              ? projectColor.withValues(alpha: 0.5)
                              : AppColors.darkBorder,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: projectColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            project.name,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isActive
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isActive
                                  ? projectColor
                                  : AppColors.darkText3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],

          // ── 워터마크 프리셋 ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Stamp Preset',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.darkText2,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _presets.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final p = _presets[i];
                return _PresetChip(label: p.name, icon: p.icon, onTap: () => _applyPreset(p));
              },
            ),
          ),
          const SizedBox(height: 24),

          // ── 표시 항목 토글 ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              l.stampDisplayItems,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.darkText2,
              ),
            ),
          ),
          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ToggleChip(
                  icon: LucideIcons.clock,
                  label: l.stampTime,
                  isActive: _showTime,
                  onTap: () => _toggle('time'),
                ),
                ToggleChip(
                  icon: LucideIcons.calendar,
                  label: l.stampDate,
                  isActive: _showDate,
                  onTap: () => _toggle('date'),
                ),
                ToggleChip(
                  icon: LucideIcons.mapPin,
                  label: l.stampAddress,
                  isActive: _showAddress,
                  isLocked: widget.isSecureMode,
                  onTap: () => _toggle('address'),
                ),
                ToggleChip(
                  icon: LucideIcons.satellite,
                  label: l.stampGps,
                  isActive: _showGps,
                  isLocked: widget.isSecureMode,
                  onTap: () => _toggle('gps'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── 오버레이 항목 ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              l.stampOverlays,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.darkText2,
              ),
            ),
          ),
          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ToggleChip(
                  icon: LucideIcons.compass,
                  label: l.stampCompass,
                  isActive: _showCompass,
                  isLocked: widget.isSecureMode,
                  onTap: () => _toggle('compass'),
                ),
                ToggleChip(
                  icon: LucideIcons.mountain,
                  label: l.stampAltitude,
                  isActive: _showAltitude,
                  isLocked: widget.isSecureMode,
                  onTap: () => _toggle('altitude'),
                ),
                ToggleChip(
                  icon: LucideIcons.gauge,
                  label: l.stampSpeed,
                  isActive: _showSpeed,
                  isLocked: widget.isSecureMode,
                  onTap: () => _toggle('speed'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
      ),
      ),
    );
  }
}

class _StampPreset {
  final String name;
  final IconData icon;
  final bool time, date, address, gps, compass, altitude, speed;
  const _StampPreset(this.name, this.icon, {
    required this.time, required this.date, required this.address,
    required this.gps, required this.compass, required this.altitude, required this.speed,
  });
}

class _PresetChip extends StatelessWidget {
  const _PresetChip({required this.label, required this.icon, required this.onTap});
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.darkSurfaceHi,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.darkAccent),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.darkText2)),
          ],
        ),
      ),
    );
  }
}
