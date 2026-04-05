import 'dart:async';
import 'package:flutter/material.dart';
import 'package:front_end/widgets/custom_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VerificationCode extends StatefulWidget {
  final String email;
  const VerificationCode({super.key, required this.email});

  @override
  State<VerificationCode> createState() => _VerificationCodeViewState();
}

class _VerificationCodeViewState extends State<VerificationCode> {
  int _secondsRemaining = 60;
  Timer? _timer;
  String otpCode = "";

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = 60;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _resendCode() async {
    if (_secondsRemaining > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('يمكنك إعادة الإرسال بعد $_secondsRemaining ثانية'),
        ),
      );
      return;
    }
    try {
      await Supabase.instance.client.auth.resend(
        type: OtpType.signup,
        email: widget.email,
      );

      _startTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إعادة إرسال الرمز بنجاح')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل إعادة إرسال الرمز: $e')));
    }
  }

  Future<void> _verifyCode() async {
    if (otpCode.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال الرمز بالكامل')),
      );
      return;
    }

    try {
      final supabase = Supabase.instance.client;

      /// ① التحقق من الرمز
      await supabase.auth.verifyOTP(
        email: widget.email,
        token: otpCode.trim(),
        type: OtpType.signup,
      );

      /// ② جلب المستخدم الحالي
      final user = supabase.auth.currentUser;

      /// ③ إدخال البيانات في جدول users
      await supabase.from('users').insert({
        'id': user!.id,
        'email': user.email,
        'full_name': user.userMetadata?['full_name'],
        'phone_number': user.userMetadata?['phone_number'],
      });

      /// ④ الانتقال للصفحة الرئيسية
      Navigator.pushReplacementNamed(context, '/home');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم التحقق وحفظ البيانات بنجاح!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل التحقق: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // RTL
      child: Scaffold(
        backgroundColor: Colors.white, // الخلفية بيضاء
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              const Text(
                'ادخل رمز التحقق',
                style: TextStyle(
                  color: Color(0xFF818898),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 85),
              PinCodeTextField(
                appContext: context,
                length: 6,
                onChanged: (value) => otpCode = value,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box, // مربع
                  borderRadius: BorderRadius.circular(10),
                  fieldHeight: 48,
                  fieldWidth: 48,
                  activeColor: Colors.blue,
                  selectedColor: Colors.blue,
                  inactiveColor: Colors.grey.shade400,
                  activeFillColor: Colors.blue.withOpacity(0.1),
                  selectedFillColor: Colors.blue.withOpacity(0.1),
                  inactiveFillColor: Colors.grey.shade200,
                ),
                keyboardType: TextInputType.number,
                textStyle: const TextStyle(color: Colors.black),
                enableActiveFill: true,
              ),
              const SizedBox(height: 48),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'يمكنك إعادة إرسال الرمز بعد  ',
                      style: TextStyle(color: Color(0xFF818898), fontSize: 16),
                    ),
                    TextSpan(
                      text: '$_secondsRemaining',
                      style: const TextStyle(
                        color: Color(0xFF731314),
                        fontSize: 16,
                      ),
                    ),
                    const TextSpan(
                      text: ' ثانية',
                      style: TextStyle(color: Color(0xFF818898), fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _resendCode,
                child: const Text(
                  'إعادة إرسال الرمز',
                  style: TextStyle(color: Color(0xFF731314), fontSize: 16),
                ),
              ),
              const SizedBox(height: 32),
              CustomButton(text: "تأكيد الرمز", onPressed: _verifyCode),
            ],
          ),
        ),
      ),
    );
  }
}
