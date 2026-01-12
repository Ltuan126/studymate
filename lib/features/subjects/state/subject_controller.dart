import '../../../services/firestore/subject_service.dart';

class SubjectController {
  final SubjectService _service = SubjectService();

  Stream getSubjects() => _service.getSubjects();

  Future<void> add(String name) => _service.addSubject(name);

  Future<void> delete(String id) => _service.deleteSubject(id);
}
