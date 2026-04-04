import 'package:flutter/material.dart';
import 'package:front_end/features/auth/presentation/screens/verification_screen.dart';
import 'package:front_end/widgets/CustomTextField.dart';
import 'package:front_end/widgets/custom_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 50),

                  const Center(
                    child: Text(
                      'انشاء حساب جديد',
                      style: TextStyle(
                        fontSize: 24,
                        color: Color(0xFF4C5494),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  /// الاسم
                  const Text("الاسم الكامل"),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hintText: 'ادخل اسمك الكامل',
                    controller: nameController,
                  ),

                  const SizedBox(height: 16),

                  /// رقم الجوال
                  const Text("رقم الجوال"),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hintText: 'ادخل رقم جوالك',
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 16),

                  /// البريد الالكتروني
                  const Text("البريد الالكتروني"),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hintText: 'ادخل بريدك الالكتروني',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 16),

                  /// كلمة المرور (اختياري - OTP ما يحتاجها)
                  const Text("كلمة المرور "),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hintText: 'ادخل كلمة المرور',
                    obscureText: true,
                    controller: passwordController,
                  ),

                  const SizedBox(height: 40),

                  /// زر التسجيل
                  CustomButton(
                    text: 'تسجيل',
                    onPressed: () async {
                      final supabase = Supabase.instance.client;

                      final email = emailController.text.trim();
                      final name = nameController.text.trim();
                      final phone = phoneController.text.trim();

                      if (email.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("الرجاء إدخال البريد الإلكتروني"),
                          ),
                        );
                        return;
                      }

                      try {
                        /// ① إرسال OTP إلى الإيميل
                        await supabase.auth.signInWithOtp(
                          email: email,
                          data: {'full_name': name, 'phone_number': phone},
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "تم إرسال رمز التحقق إلى بريدك الإلكتروني",
                            ),
                          ),
                        );

                        /// ② الانتقال لصفحة التحقق
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VerificationCode(email: email),
                          ),
                        );
                      } on AuthException catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(e.message)));
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("Error: $e")));
                      }
                    },
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
