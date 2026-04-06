/// GitHub 잔디 스타일 촬영 활동 캘린더
import 'package:flutter/material.dart';
import 'package:exacta/data/database.dart';

class PhotoCalendar extends StatefulWidget {
  const PhotoCalendar({super.key, required this.accentColor});
  final Color accentColor;

  @override
  State<PhotoCalendar> createState() => _PhotoCalendarState();
}

class _PhotoCalendarState extends State<PhotoCalendar> {
  Map<int, int> _counts = {};
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final now = DateTime.now();
    final counts = await AppDatabase.instance.getDailyPhotoCounts(now.year, now.month);
    if (mounted) setState(() { _counts = counts; _loaded = true; });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) return const SizedBox(height: 120);

    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    // 1일의 요일 (0=월 ~ 6=일)
    final firstWeekday = DateTime(now.year, now.month, 1).weekday - 1;
    final maxCount = _counts.values.fold<int>(0, (a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 요일 헤더
        Row(
          children: ['일', '월', '화', '수', '목', '금', '토']
              .map((d) => Expanded(
                    child: Center(
                      child: Text(d,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.4),
                          )),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 4),
        // 날짜 그리드
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 3,
            crossAxisSpacing: 3,
          ),
          // 일요일 시작 보정: firstWeekday(월=0) → 일요일 기준으로 변환
          itemCount: ((firstWeekday % 7 + 6) % 7) + daysInMonth,
          itemBuilder: (ctx, index) {
            final sunOffset = (firstWeekday + 1) % 7; // 일요일 기준 offset
            if (index < sunOffset) return const SizedBox();
            final day = index - sunOffset + 1;
            if (day > daysInMonth) return const SizedBox();

            final count = _counts[day] ?? 0;
            final isToday = day == now.day;
            final intensity = maxCount > 0 ? (count / maxCount).clamp(0.0, 1.0) : 0.0;

            return Container(
              decoration: BoxDecoration(
                color: count > 0
                    ? widget.accentColor.withValues(alpha: 0.15 + intensity * 0.65)
                    : Theme.of(context).dividerColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
                border: isToday
                    ? Border.all(color: widget.accentColor, width: 1.5)
                    : null,
              ),
              child: Center(
                child: Text(
                  '$day',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                    color: count > 0
                        ? widget.accentColor
                        : Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.3),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
