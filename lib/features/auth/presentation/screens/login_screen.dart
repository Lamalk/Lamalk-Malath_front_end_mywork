import 'package:flutter/material.dart';
import 'package:front_end/widgets/CustomTextField.dart';
import 'package:front_end/widgets/custom_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart'; // لإطلاق الرابط في المتصفح

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final supabase = Supabase.instance.client;

  // دالة إرسال رابط إعادة تعيين كلمة المرور
  Future<void> sendResetPassword(BuildContext context) async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال البريد الإلكتروني أولاً')),
      );
      return;
    }

    try {
      await supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'malath://reset-password', // الرابط الخاص بالتطبيق
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إرسال رابط إعادة التعيين إلى بريدك الإلكتروني'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 80),
              const Center(
                child: Text(
                  'أهلًا بك',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 60),

              // البريد الإلكتروني
              const Text("البريد الإلكتروني", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              CustomTextField(
                hintText: 'أدخل بريدك الإلكتروني',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // كلمة المرور
              const Text("كلمة المرور", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              CustomTextField(
                hintText: 'أدخل كلمة المرور',
                obscureText: true,
                controller: passwordController,
              ),
              const SizedBox(height: 8),

              // زر نسيت كلمة المرور
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => sendResetPassword(context),
                  child: const Text(
                    "نسيت كلمة المرور؟",
                    style: TextStyle(color: Color(0xFF4C5494)),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // زر الدخول
              CustomButton(
                text: 'تسجيل الدخول',
                onPressed: () async {
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();

                  if (email.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('الرجاء تعبئة جميع الحقول')),
                    );
                    return;
                  }

                  try {
                    final res = await supabase.auth.signInWithPassword(
                      email: email,
                      password: password,
                    );
                    final user = res.user;
                    if (user == null) throw "فشل تسجيل الدخول";

                    final userData = await supabase
                        .from('users')
                        .select()
                        .eq('id', user.id)
                        .maybeSingle();

                    if (userData == null) throw "لم يتم العثور على بيانات المستخدم";

                    final role = userData['role'] ?? 'user';

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم تسجيل الدخول بنجاح')),
                    );

                    if (role == 'admin') {
                      Navigator.pushReplacementNamed(
                        context,
                        '/admin_dashboard',
                      );
                    } else {
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                  } on AuthException catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(e.message)));
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("حدث خطأ: $e")));
                  }
                },
              ),

              const Spacer(),

              // رابط التسجيل
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "ليس لديك حساب؟ ",
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/signup');
                      },
                      child: const Text(
                        "إنشاء حساب",
                        style: TextStyle(
                          color: Color(0xFF4C5494),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}