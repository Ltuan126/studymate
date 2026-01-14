import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  CollectionReference get _ref =>
      _db.collection('users')
         .doc(_auth.currentUser!.uid)
         .collection('tasks');

  Stream<QuerySnapshot> getTasks() {
    return _ref.snapshots();
  }

  Future<void> addTask(String title) async {
    await _ref.add({
      'title': title,
      'isDone': false,
    });
  }

  Future<void> toggleDone(String id, bool value) async {
    await _ref.doc(id).update({'isDone': value});
  }
}
