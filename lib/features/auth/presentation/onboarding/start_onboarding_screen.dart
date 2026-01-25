import 'package:flutter/material.dart';
import 'onboarding_1_screen.dart';
import 'onboarding_layout.dart';

class StartOnboardingScreen extends StatelessWidget {
  const StartOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      imageAsset: 'assets/images/onboarding.png',
      title: 'Học tập hiệu quả',
      description: 'Nâng cao kết quả học tập với các công cụ\n'
          'hỗ trợ học tập thông minh.',
      currentIndex: 0,
      buttonText: 'Tiếp tục',
      onContinue: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const Onboarding1Screen(),
          ),
        );
      },
    );
  }
}
