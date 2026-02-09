import 'package:flutter/material.dart';
import 'package:front_end/features/auth/presentation/screens/login_screen.dart';
import 'package:front_end/features/auth/presentation/screens/signup_screen.dart';
import 'package:front_end/features/auth/presentation/screens/verification_screen.dart';
import 'package:front_end/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:front_end/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:front_end/features/profile/presentation/screens/profile_screen.dart';
import 'package:front_end/features/report/presentation/screens/home_screen.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:front_end/features/profile/presentation/screens/case_history_screen.dart';
void main() {
  runApp(const MalathApp());
}

class MalathApp extends StatelessWidget {
  const MalathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Malath',
      debugShowCheckedModeBanner: false,

      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: const EditProfileScreen(),


      


      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
