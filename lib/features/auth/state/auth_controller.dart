import '../../../services/auth/firebase_auth_service.dart';

class AuthController {
  final FirebaseAuthService _service = FirebaseAuthService();

  Stream get authStateChanges => _service.authStateChanges;

  bool get isLoggedIn => _service.currentUser != null;

  String? get currentUserId => _service.currentUser?.uid;

  String? get currentUserEmail => _service.currentUser?.email;

  Future<void> login(String email, String password) {
    return _service.login(email, password);
  }

  Future<void> register(String email, String password) {
    return _service.register(email, password);
  }

  Future<void> logout() {
    return _service.logout();
  }

  Future<void> resetPassword(String email) {
    return _service.resetPassword(email);
  }
}
