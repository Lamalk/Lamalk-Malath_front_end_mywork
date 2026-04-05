import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF4C5494)),
            onPressed: () {
              Navigator.pop(context); // العودة للصفحة السابقة (Profile)
            },
          ),
          title: const Text(
            'عن التطبيق',
            style: TextStyle(
              color: Color(0xFF4C5494),
              fontWeight: FontWeight.bold,
              fontSize: 36,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(height: 20),
              // عنوان التطبيق
              Text(
                'تطبيق ملاذ',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4C5494),
                ),
              ),
              SizedBox(height: 16),
              // وصف التطبيق
              Text(
                'يهدف ملاذ إلى أن يكون مساعدك القانوني الذكي لفهم القضايا الإلكترونية وفق نظام مكافحة الجرائم المعلوماتية في المملكة العربية السعودية. '
                'يعتمد التطبيق على تقنيات معالجة اللغة الطبيعية (NLP) لتحليل وصف المستخدم — سواء كان نصًا حرًا أو عبر اختيار نوع الجريمة — ثم يحدد نوع الجريمة، ويعرض المادة النظامية المرتبطة بها، والعقوبة، وخطوات الإبلاغ الرسمية، والنصائح الوقائية المناسبة. '
                'يوفر ملاذ طريقة مبسّطة وواضحة للمستخدمين لفهم القضايا الإلكترونية مثل الاختراق، الابتزاز، الاحتيال المالي، سرقة البيانات، وانتهاك الخصوصية، مع ضمان ارتباط النتائج بالمواد القانونية السعودية.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4C5494),
                  fontWeight: FontWeight.w400, // لايت
                  height: 1.5,
                ),
              ),
              SizedBox(height: 24),
              // معلومات عن المطورين
              Text(
                'تم تطوير هذا التطبيق بشغف من قبل:',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF731314),
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'لمى بندر الصاعدي\nجودي عاطف مليباري\nلمى محمد كديش\nريماس حسن الشهري ',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF731314),
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
