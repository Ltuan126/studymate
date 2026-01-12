import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SubjectService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  CollectionReference get _ref =>
      _db.collection('users')
         .doc(_auth.currentUser!.uid)
         .collection('subjects');

  Stream<QuerySnapshot> getSubjects() {
    return _ref.snapshots();
  }

  Future<void> addSubject(String name) async {
    await _ref.add({'name': name});
  }

  Future<void> deleteSubject(String id) async {
    await _ref.doc(id).delete();
  }
}
