import '../../../services/firestore/task_service.dart';

class TaskController {
  final TaskService _service = TaskService();

  Stream getTasks() => _service.getTasks();

  Future<void> add(
    String title, {
    DateTime? dueDate,
    DateTime? startTime,
    DateTime? endTime,
    String? subjectName,
  }) => _service.addTask(
    title,
    dueDate: dueDate,
    startTime: startTime,
    endTime: endTime,
    subjectName: subjectName,
  );

  Future<void> update(
    String id, {
    String? title,
    DateTime? dueDate,
    DateTime? startTime,
    DateTime? endTime,
    String? subjectName,
  }) => _service.updateTask(
    id,
    title: title,
    dueDate: dueDate,
    startTime: startTime,
    endTime: endTime,
    subjectName: subjectName,
  );

  Future<void> toggle(String id, bool value) => _service.toggleDone(id, value);

  Future<void> delete(String id) => _service.deleteTask(id);
}
