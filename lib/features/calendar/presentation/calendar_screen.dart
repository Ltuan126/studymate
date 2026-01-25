import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

/* =======================
   MODEL (đặt chung cho đỡ đỏ)
======================= */
class Task {
  final String id;
  String title;
  DateTime date;
  TimeOfDay start;
  TimeOfDay end;
  Color color;

  Task({
    required this.id,
    required this.title,
    required this.date,
    required this.start,
    required this.end,
    required this.color,
  });
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDate = DateTime.now();

  final Map<DateTime, List<Task>> tasksByDate = {};

  List<Task> get tasksOfSelectedDay {
    final key = DateUtils.dateOnly(selectedDate);
    return tasksByDate[key] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final monthTitle = DateFormat('MMMM yyyy', 'vi').format(selectedDate);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6FB),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          monthTitle,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: _addTask,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDaySelector(),
            const SizedBox(height: 24),
            Expanded(child: _buildTaskList()),
          ],
        ),
      ),
    );
  }

  /* =======================
     DAY SELECTOR (REAL TIME)
  ======================= */
  Widget _buildDaySelector() {
    final startWeek =
        selectedDate.subtract(Duration(days: selectedDate.weekday - 1));

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (_, i) {
          final day = startWeek.add(Duration(days: i));
          final isSelected = DateUtils.isSameDay(day, selectedDate);

          return GestureDetector(
            onTap: () => setState(() => selectedDate = day),
            child: Container(
              width: 60,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.deepPurple : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE', 'vi').format(day),
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    day.day.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /* =======================
     TASK LIST
  ======================= */
  Widget _buildTaskList() {
    if (tasksOfSelectedDay.isEmpty) {
      return const Center(
        child: Text(
          'Chưa có lịch cho ngày này',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: tasksOfSelectedDay.length,
      itemBuilder: (_, index) {
        final task = tasksOfSelectedDay[index];
        return _TaskCard(
          task: task,
          onEdit: () => _editTask(task),
          onDelete: () => _deleteTask(task),
        );
      },
    );
  }

  /* =======================
     ADD / EDIT / DELETE
  ======================= */
  void _addTask() async {
    final task = await _openTaskDialog();
    if (task == null) return;

    final key = DateUtils.dateOnly(task.date);
    setState(() {
      tasksByDate.putIfAbsent(key, () => []);
      tasksByDate[key]!.add(task);
    });
  }

  void _editTask(Task task) async {
    final updated = await _openTaskDialog(oldTask: task);
    if (updated == null) return;

    setState(() {
      task.title = updated.title;
      task.start = updated.start;
      task.end = updated.end;
      task.color = updated.color;
    });
  }

  void _deleteTask(Task task) {
    final key = DateUtils.dateOnly(task.date);
    setState(() {
      tasksByDate[key]?.remove(task);
    });
  }

  /* =======================
     ADD / EDIT DIALOG
  ======================= */
  Future<Task?> _openTaskDialog({Task? oldTask}) async {
    final titleCtrl =
        TextEditingController(text: oldTask?.title ?? '');

    TimeOfDay start =
        oldTask?.start ?? const TimeOfDay(hour: 8, minute: 0);
    TimeOfDay end =
        oldTask?.end ?? const TimeOfDay(hour: 9, minute: 30);

    return showDialog<Task>(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(oldTask == null
                  ? 'Thêm bài tập mới'
                  : 'Chỉnh sửa bài tập'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleCtrl,
                    decoration:
                        const InputDecoration(hintText: 'Tên môn học'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () async {
                          final t = await showTimePicker(
                            context: context,
                            initialTime: start,
                          );
                          if (t != null) {
                            setDialogState(() => start = t);
                          }
                        },
                        child: Text('Bắt đầu: ${start.format(context)}'),
                      ),
                      TextButton(
                        onPressed: () async {
                          final t = await showTimePicker(
                            context: context,
                            initialTime: end,
                          );
                          if (t != null) {
                            setDialogState(() => end = t);
                          }
                        },
                        child: Text('Kết thúc: ${end.format(context)}'),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Huỷ'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleCtrl.text.trim().isEmpty) return;

                    Navigator.pop(
                      context,
                      Task(
                        id: oldTask?.id ??
                            DateTime.now().millisecondsSinceEpoch.toString(),
                        title: titleCtrl.text.trim(),
                        date: selectedDate,
                        start: start,
                        end: end,
                        color: Colors.primaries[
                            DateTime.now().millisecond %
                                Colors.primaries.length],
                      ),
                    );
                  },
                  child: const Text('Lưu'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

/* =======================
   TASK CARD UI
======================= */
class _TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TaskCard({
    required this.task,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(
            width: 52,
            child: Text(
              task.start.format(context),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: task.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${task.start.format(context)} - ${task.end.format(context)}',
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, size: 18),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 18),
                    onPressed: onDelete,
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
