import '../../../services/auth/firebase_auth_service.dart';

class AuthController {
  final FirebaseAuthService _service = FirebaseAuthService();

  Future<void> login(String email, String password) async {
    await _service.login(email, password);
  }

  Future<void> register(String email, String password) async {
    await _service.register(email, password);
  }

  Future<void> logout() async {
    await _service.logout();
  }
}
