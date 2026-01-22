import 'package:flutter/material.dart';
import '../../../services/firestore/task_service.dart';

class CalendarController extends ChangeNotifier {
  final TaskService _taskService = TaskService();

  DateTime selectedDate = DateTime.now();

  void selectDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  Stream getTasksByDate(DateTime date) {
    try {
      return _taskService.getTasks().map((snapshot) {
        final tasks = snapshot.docs.where((task) {
          final taskData = task.data() as Map<String, dynamic>;
          final dueDate = taskData['dueDate'];

          if (dueDate == null) return false;

          final taskDate = (dueDate as dynamic).toDate();
          return taskDate.year == date.year &&
              taskDate.month == date.month &&
              taskDate.day == date.day;
        }).toList();

        return tasks;
      });
    } catch (e) {
      throw Exception('Lỗi tải tasks: $e');
    }
  }

  Stream getTasksByMonth(int month, int year) {
    try {
      return _taskService.getTasks().map((snapshot) {
        final tasks = snapshot.docs.where((task) {
          final taskData = task.data() as Map<String, dynamic>;
          final dueDate = taskData['dueDate'];

          if (dueDate == null) return false;

          final taskDate = (dueDate as dynamic).toDate();
          return taskDate.year == year && taskDate.month == month;
        }).toList();

        return tasks;
      });
    } catch (e) {
      throw Exception('Lỗi tải tasks tháng: $e');
    }
  }
}
