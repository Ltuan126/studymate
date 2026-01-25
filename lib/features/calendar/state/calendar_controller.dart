import 'package:flutter/material.dart';
import '../../tasks/task_model.dart';

class CalendarController extends ChangeNotifier {
  DateTime selectedDate = DateTime.now();

  final Map<DateTime, List<TaskModel>> _tasks = {};

  DateTime _key(DateTime d) => DateTime(d.year, d.month, d.day);

  List<TaskModel> get tasksOfDay {
    return _tasks[_key(selectedDate)] ?? [];
  }

  void selectDate(DateTime date) {
    selectedDate = _key(date);
    notifyListeners();
  }

  void addTask(TaskModel task) {
    final key = _key(task.date);
    _tasks.putIfAbsent(key, () => []);
    _tasks[key]!.add(task);
    notifyListeners();
  }

  void updateTask(TaskModel oldTask, TaskModel newTask) {
    final key = _key(oldTask.date);
    final list = _tasks[key];
    if (list == null) return;
    final index = list.indexOf(oldTask);
    list[index] = newTask;
    notifyListeners();
  }

  void deleteTask(TaskModel task) {
    _tasks[_key(task.date)]?.remove(task);
    notifyListeners();
  }
}
