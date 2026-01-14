import '../../../services/firestore/task_service.dart';

class TaskController {
  final TaskService _service = TaskService();

  Stream getTasks() => _service.getTasks();

  Future<void> add(String title) => _service.addTask(title);

  Future<void> toggle(String id, bool value) =>
      _service.toggleDone(id, value);
}
