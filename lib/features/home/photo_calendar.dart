/// 이번 주 촬영 활동 스트립 (일~토, 월 라벨 포함)
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:exacta/data/database.dart';

class PhotoCalendar extends StatefulWidget {
  const PhotoCalendar({super.key, required this.accentColor});
  final Color accentColor;

  @override
  State<PhotoCalendar> createState() => _PhotoCalendarState();
}

class _PhotoCalendarState extends State<PhotoCalendar> {
  Map<DateTime, int> _counts = {};
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final now = DateTime.now();
    // 이번 주 일요일 (DateTime.weekday: Mon=1..Sun=7 → Sun=0 보정)
    final sunday = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday % 7));

    final byDate = <DateTime, int>{};
    final currentCounts = await AppDatabase.instance
        .getDailyPhotoCounts(now.year, now.month);
    currentCounts.forEach((day, c) {
      byDate[DateTime(now.year, now.month, day)] = c;
    });
    // 주가 전월에 걸치면 전월 데이터도 가져온다
    if (sunday.month != now.month) {
      final prevCounts = await AppDatabase.instance
          .getDailyPhotoCounts(sunday.year, sunday.month);
      prevCounts.forEach((day, c) {
        byDate[DateTime(sunday.year, sunday.month, day)] = c;
      });
    }
    if (mounted) setState(() { _counts = byDate; _loaded = true; });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) return const SizedBox(height: 80);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sunday = today.subtract(Duration(days: now.weekday % 7));
    final week = List.generate(7, (i) => sunday.add(Duration(days: i)));

    final maxCount = _counts.values.fold<int>(0, (a, b) => a > b ? a : b);
    final locale = Localizations.localeOf(context).toString();
    // 주가 두 달에 걸치면 "3월 ~ 4월" 형태로
    final saturday = week.last;
    final monthFmt = DateFormat.MMMM(locale);
    final monthLabel = sunday.month == saturday.month
        ? monthFmt.format(today)
        : '${monthFmt.format(sunday)} ~ ${monthFmt.format(saturday)}';
    final weekdayFmt = DateFormat.E(locale);
    final mutedColor = Theme.of(context).textTheme.bodySmall?.color
        ?.withValues(alpha: 0.45);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            monthLabel,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ),
        Row(
          children: week.map((date) {
            final count = _counts[date] ?? 0;
            final isToday = date == today;
            final intensity = maxCount > 0 ? (count / maxCount).clamp(0.0, 1.0) : 0.0;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Column(
                  children: [
                    Text(
                      weekdayFmt.format(date),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: mutedColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: count > 0
                            ? widget.accentColor.withValues(alpha: 0.15 + intensity * 0.65)
                            : Theme.of(context).dividerColor.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(10),
                        border: isToday
                            ? Border.all(color: widget.accentColor, width: 1.5)
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                            color: count > 0
                                ? widget.accentColor
                                : Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
