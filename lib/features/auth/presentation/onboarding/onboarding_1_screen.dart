import 'package:flutter/material.dart';
import 'onboarding_2_screen.dart';
import 'onboarding_layout.dart';

class Onboarding1Screen extends StatelessWidget {
  const Onboarding1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      imageAsset: 'assets/images/onboarding.png',
      title: 'Quản lý việc\nhọc dễ dàng',
      description: 'Sắp xếp thời khóa biểu và theo dõi\n'
          'tiến độ môn học của bạn.',
      currentIndex: 1,
      buttonText: 'Tiếp tục',
      onContinue: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const Onboarding2Screen(),
          ),
        );
      },
    );
  }
}
