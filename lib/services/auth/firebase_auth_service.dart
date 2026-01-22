import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> login(String email, String password) async {
    if (email.trim().isEmpty || password.isEmpty) {
      throw Exception('Email và mật khẩu không được để trống');
    }

    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } catch (e) {
      throw Exception('Lỗi đăng nhập: $e');
    }
  }

  Future<void> register(String email, String password) async {
    if (email.trim().isEmpty || password.isEmpty) {
      throw Exception('Email và mật khẩu không được để trống');
    }

    if (password.length < 6) {
      throw Exception('Mật khẩu tối thiểu 6 ký tự');
    }

    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } catch (e) {
      throw Exception('Lỗi đăng ký: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Lỗi đăng xuất: $e');
    }
  }

  Future<void> resetPassword(String email) async {
    if (email.trim().isEmpty) {
      throw Exception('Email không được để trống');
    }

    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } catch (e) {
      throw Exception('Lỗi gửi email reset: $e');
    }
  }
}
