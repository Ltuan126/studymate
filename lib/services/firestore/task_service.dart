import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class TaskService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  CollectionReference get _ref {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw Exception('User chưa đăng nhập');
    }
    return _db.collection('users').doc(uid).collection('tasks');
  }

  Stream<QuerySnapshot> getTasks() {
    try {
      return _ref.snapshots();
    } catch (e) {
      throw Exception('Lỗi tải task: $e');
    }
  }

  Future<void> addTask(
    String title, {
    DateTime? dueDate,
    DateTime? startTime,
    DateTime? endTime,
    String? subjectId,
  }) async {
    if (title.trim().isEmpty) {
      throw Exception('Tiêu đề không được để trống');
    }

    // Create dateKey for calendar query (format: yyyy-MM-dd)
    String? dateKey;
    if (dueDate != null) {
      dateKey = DateFormat('yyyy-MM-dd').format(dueDate);
    }

    try {
      await _ref.add({
        'title': title.trim(),
        'isDone': false,
        'createdAt': FieldValue.serverTimestamp(),
        'dueDate': dueDate != null ? Timestamp.fromDate(dueDate) : null,
        'startTime': startTime != null ? Timestamp.fromDate(startTime) : null,
        'endTime': endTime != null ? Timestamp.fromDate(endTime) : null,
        'subjectId': subjectId,
        'dateKey': dateKey, // Added for calendar filtering
      });
    } catch (e) {
      throw Exception('Lỗi thêm task: $e');
    }
  }

  Future<void> updateTask(
    String id, {
    String? title,
    DateTime? dueDate,
    DateTime? startTime,
    DateTime? endTime,
    String? subjectId,
  }) async {
    final update = <String, dynamic>{};
    if (title != null && title.trim().isNotEmpty) {
      update['title'] = title.trim();
    }
    if (dueDate != null) {
      update['dueDate'] = Timestamp.fromDate(dueDate);
      update['dateKey'] = DateFormat('yyyy-MM-dd').format(dueDate);
    }
    if (startTime != null) {
      update['startTime'] = Timestamp.fromDate(startTime);
    }
    if (endTime != null) {
      update['endTime'] = Timestamp.fromDate(endTime);
    }
    if (subjectId != null) {
      update['subjectId'] = subjectId;
    }

    if (update.isEmpty) {
      throw Exception('Phải cập nhật ít nhất 1 trường');
    }

    try {
      await _ref.doc(id).update(update);
    } catch (e) {
      throw Exception('Lỗi cập nhật task: $e');
    }
  }

  Future<void> toggleDone(String id, bool value) async {
    try {
      await _ref.doc(id).update({'isDone': value});
    } catch (e) {
      throw Exception('Lỗi cập nhật task: $e');
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _ref.doc(id).delete();
    } catch (e) {
      throw Exception('Lỗi xóa task: $e');
    }
  }
}
