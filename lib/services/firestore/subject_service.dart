import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SubjectService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  CollectionReference get _ref {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw Exception('User chưa đăng nhập');
    }
    return _db.collection('users').doc(uid).collection('subjects');
  }

  Stream<QuerySnapshot> getSubjects() {
    try {
      return _ref.snapshots();
    } catch (e) {
      throw Exception('Lỗi tải môn học: $e');
    }
  }

  Future<void> addSubject(String name) async {
    if (name.trim().isEmpty) {
      throw Exception('Tên môn học không được để trống');
    }

    try {
      await _ref.add({
        'name': name.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Lỗi thêm môn học: $e');
    }
  }

  Future<void> updateSubject(String id, String name) async {
    if (name.trim().isEmpty) {
      throw Exception('Tên môn học không được để trống');
    }

    try {
      await _ref.doc(id).update({'name': name.trim()});
    } catch (e) {
      throw Exception('Lỗi cập nhật môn học: $e');
    }
  }

  Future<void> deleteSubject(String id) async {
    try {
      await _ref.doc(id).delete();
    } catch (e) {
      throw Exception('Lỗi xóa môn học: $e');
    }
  }
}
