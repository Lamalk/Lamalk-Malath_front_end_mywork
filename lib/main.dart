import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:front_end/features/admin/presentation/screens/admin_dashboard.dart';
import 'package:front_end/features/admin/presentation/screens/manage_users_screen.dart';
import 'package:front_end/features/auth/presentation/screens/login_screen.dart';
import 'package:front_end/features/auth/presentation/screens/resetpassword_screen.dart';
import 'package:front_end/features/auth/presentation/screens/signup_screen.dart';
import 'package:front_end/features/auth/presentation/screens/verification_screen.dart';
import 'package:front_end/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:front_end/features/profile/presentation/screens/AboutApp_screen.dart';
import 'package:front_end/features/profile/presentation/screens/case_history_screen.dart';
import 'package:front_end/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:front_end/features/profile/presentation/screens/profile_screen.dart';
import 'package:front_end/features/report/presentation/screens/free_text_input_screen.dart';
import 'package:front_end/features/report/presentation/screens/guided_selection_screen.dart';
import 'package:front_end/features/report/presentation/screens/home_screen.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://heveethekowijnedfxzg.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhldmVldGhla293aWpuZWRmeHpnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzAzMDM3MDksImV4cCI6MjA4NTg3OTcwOX0.dLdI_dScp6dEdVwrkPq3ACx-kKfE61l9yD1CTjXVJCY',
  );

  runApp(const MalathApp());
}

class MalathApp extends StatefulWidget {
  const MalathApp({super.key});

  @override
  State<MalathApp> createState() => _MalathAppState();
}

class _MalathAppState extends State<MalathApp> {
  @override
  void initState() {
    super.initState();

    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;

      if (event == AuthChangeEvent.passwordRecovery) {
        navigatorKey.currentState?.pushNamed('/reset_password');
      }

      final user = Supabase.instance.client.auth.currentUser;
      print('USER ID: ${user?.id}');
      print('EMAIL: ${user?.email}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Malath',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SplashScreen(),
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/about': (context) => const AboutAppScreen(),
        '/free_text_input': (context) => const FreeTextInputScreen(),
        '/guided_select': (context) => const GuidedSelectionScreen(),
        '/edit_profile': (context) => const EditProfileScreen(),
        '/case_history': (context) => const CaseHistoryScreen(),
        '/admin_dashboard': (context) => const AdminDashboard(),
        '/manage_users': (context) => const ManageUsersScreen(),
        '/reset_password': (context) => const ResetPasswordScreen(),
      },
    );
  }
}