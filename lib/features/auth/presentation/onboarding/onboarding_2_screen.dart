import 'package:flutter/material.dart';
import '../register_screen.dart';
import 'onboarding_layout.dart';

class Onboarding2Screen extends StatelessWidget {
  const Onboarding2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      imageAsset: 'assets/images/onboarding.png',
      title: 'Theo dõi tiến \nđộ',
      description: 'Sắp xếp thời khóa biểu và theo dõi\n'
          'tiến độ môn học của bạn.',
      currentIndex: 2,
      buttonText: 'Tiếp tục',
      onContinue: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const RegisterScreen(),
          ),
        );
      },
    );
  }
}
