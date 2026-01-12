import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/auth/presentation/onboarding/onboarding_1_screen.dart';
import 'features/auth/presentation/onboarding/onboarding_layout.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: Re-enable after Firebase setup is added.
  // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartOnboardingScreen(),
    );
  }
}

class StartOnboardingScreen extends StatelessWidget {
  const StartOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      imageAsset: 'assets/images/onboarding.png',
      title: 'Quản lý việc\nhọc dễ dàng',
      description: 'Sắp xếp thời khóa biểu và theo dõi\n'
          'tiến độ môn học của bạn.',
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
