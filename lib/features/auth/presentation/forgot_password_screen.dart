import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studymate/core/theme/app_theme.dart';
import 'package:studymate/shared/widgets/rounded_text_field.dart';
import 'package:studymate/shared/widgets/primary_button.dart';
import '../state/auth_controller.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailCtrl = TextEditingController();
  final _authController = AuthController();
  bool isLoading = false;

  @override
  void dispose() {
    emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    final email = emailCtrl.text.trim();

    if (email.isEmpty) {
      _showSnack('Vui lòng nhập email');
      return;
    }

    setState(() => isLoading = true);

    try {
      await _authController.resetPassword(email);

      if (!mounted) return;

      _showSnack('Đã gửi email đặt lại mật khẩu');

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
    if (error.contains('user-not-found')) {
      return 'Không tìm thấy email này';
    } else if (error.contains('invalid-email')) {
      return 'Email không hợp lệ';
    }
    return 'Có lỗi xảy ra';
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
                  const SizedBox(height: 80),
                  Text(
                    'Quên mật khẩu',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'Nhập email để nhận liên kết\nđặt lại mật khẩu',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      fontSize: 14.5,
                      height: 1.35,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 90),

                  RoundedTextField(controller: emailCtrl, hint: 'Email'),
                  const SizedBox(height: 32),

                  PrimaryButton(
                    text: 'Gửi yêu cầu',
                    isLoading: isLoading,
                    onPressed: _resetPassword,
                    height: 60,
                  ),

                  const SizedBox(height: 18),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: Text(
                      'Quay lại đăng nhập',
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
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
