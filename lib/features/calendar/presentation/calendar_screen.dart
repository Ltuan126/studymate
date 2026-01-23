import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tháng 12, 2025'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =====================
            // Day selector (UI only)
            // =====================
            SizedBox(
              height: 72,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  _DayItem(day: 'Thứ 2', date: '08'),
                  _DayItem(day: 'Thứ 3', date: '09', isSelected: true),
                  _DayItem(day: 'Thứ 4', date: '10'),
                  _DayItem(day: 'Thứ 5', date: '11'),
                  _DayItem(day: 'Thứ 6', date: '12'),
                  _DayItem(day: 'Thứ 7', date: '13'),
                  _DayItem(day: 'CN', date: '14'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // =====================
            // Task list (demo data)
            // =====================
            const _TaskCard(
              time: '08:00',
              title: 'Lập trình web',
              duration: '08:00 - 09:30',
              color: Colors.red,
            ),
            const _TaskCard(
              time: '09:40',
              title: 'Cấu trúc dữ liệu & giải thuật',
              duration: '09:40 - 11:10',
              color: Colors.green,
            ),
            const _TaskCard(
              time: '11:20',
              title: 'Cơ sở dữ liệu',
              duration: '11:20 - 12:50',
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}

// ===================================================
// Widget con: Day item (chọn ngày trong tuần)
// ===================================================
class _DayItem extends StatelessWidget {
  final String day;
  final String date;
  final bool isSelected;

  const _DayItem({
    required this.day,
    required this.date,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      width: 56,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: isSelected ? primaryColor : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// ===================================================
// Widget con: Task card (UI bài tập theo giờ)
// ===================================================
class _TaskCard extends StatelessWidget {
  final String time;
  final String title;
  final String duration;
  final Color color;

  const _TaskCard({
    required this.time,
    required this.title,
    required this.duration,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time column
          SizedBox(
            width: 48,
            child: Text(
              time,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),

          const SizedBox(width: 12),

          // Task card
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    duration,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
