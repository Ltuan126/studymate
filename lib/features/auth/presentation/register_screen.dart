import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studymate/core/theme/app_theme.dart';
import 'package:studymate/shared/widgets/rounded_text_field.dart';
import 'package:studymate/shared/widgets/primary_button.dart';
import '../state/auth_controller.dart';

import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final rePassCtrl = TextEditingController();
  final _authController = AuthController();

  bool isLoading = false;

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    rePassCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final email = emailCtrl.text.trim();
    final password = passCtrl.text;
    final rePassword = rePassCtrl.text;

    if (email.isEmpty || password.isEmpty || rePassword.isEmpty) {
      _showSnack('Vui lòng điền đầy đủ thông tin');
      return;
    }

    if (password != rePassword) {
      _showSnack('Mật khẩu không trùng khớp');
      return;
    }

    if (password.length < 6) {
      _showSnack('Mật khẩu phải ít nhất 6 ký tự');
      return;
    }

    setState(() => isLoading = true);

    try {
      await _authController.register(email, password);

      if (!mounted) return;

      _showSnack('Đăng ký thành công');

      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    } catch (e) {
      _showSnack(_getErrorMessage(e.toString()));
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  String _getErrorMessage(String error) {
    if (error.contains('email-already-in-use')) {
      return 'Email đã được sử dụng';
    } else if (error.contains('invalid-email')) {
      return 'Email không hợp lệ';
    } else if (error.contains('weak-password')) {
      return 'Mật khẩu quá yếu';
    }
    return 'Đăng ký thất bại';
  }

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                children: [
                  const SizedBox(height: 70),
                  Text(
                    'Tạo tài khoản mới',
                    style: GoogleFonts.manrope(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Đăng ký để bắt đầu\nquản lý tiến trình học tập',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      fontSize: 14.5,
                      height: 1.4,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 80),

                  RoundedTextField(controller: emailCtrl, hint: 'Email'),
                  const SizedBox(height: 20),

                  RoundedTextField(
                    controller: passCtrl,
                    hint: 'Mật khẩu',
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),

                  RoundedTextField(
                    controller: rePassCtrl,
                    hint: 'Nhập lại mật khẩu',
                    obscureText: true,
                  ),
                  const SizedBox(height: 32),

                  PrimaryButton(
                    text: 'Đăng ký',
                    isLoading: isLoading,
                    onPressed: _register,
                    height: 60,
                  ),

                  const SizedBox(height: 20),

                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                      children: [
                        const TextSpan(text: 'Đã có tài khoản? '),
                        TextSpan(
                          text: 'Đăng nhập',
                          style: const TextStyle(fontWeight: FontWeight.w800),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
