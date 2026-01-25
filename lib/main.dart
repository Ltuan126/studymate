import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';
// onboarding
import 'features/auth/presentation/onboarding/start_onboarding_screen.dart';

// auth
import 'features/auth/presentation/register_screen.dart';
import 'features/auth/presentation/login_screen.dart';

// home
import 'features/home/presentation/home_dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('vi_VN', null); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: const StartOnboardingScreen(),

      routes: {
        '/register': (_) => const RegisterScreen(),
        '/login': (_) => const LoginScreen(),
        '/home': (_) => const HomeDashboardScreen(),
      },
    );
  }
}
