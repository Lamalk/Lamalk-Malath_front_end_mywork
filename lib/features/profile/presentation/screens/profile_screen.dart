import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // خلفية بيضاء
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),

            // ===== صورة الحساب والاسم والايميل =====
            Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(
                    'assets/images/user_avatar.png',
                  ), // صورة الحساب
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'اسم المستخدم',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'user@email.com',
                      style: TextStyle(fontSize: 16, color: Color(0xFF666D80)),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 40),

            // ===== المعلومات الشخصية =====
            const Text(
              'المعلومات الشخصية',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4C5494),
              ),
            ),
            const SizedBox(height: 16),

            // ===== الملف الشخصي وسجل القضايا =====
            ListTile(
              leading: const Icon(Icons.person, color: Color(0xFF4C5494)),
              title: const Text(
                'الملف الشخصي',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4C5494),
                ),
              ),
              onTap: () {
                // هنا تضع التنقل إلى صفحة الملف الشخصي إذا كان هناك صفحة فرعية
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder_open, color: Color(0xFF4C5494)),
              title: const Text(
                'سجل القضايا',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4C5494),
                ),
              ),
              onTap: () {
                // هنا تضع التنقل إلى صفحة سجل القضايا
              },
            ),

            const SizedBox(height: 40),

            // ===== الإعدادات =====
            const Text(
              'الإعدادات',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4C5494),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Color(0xFF4C5494)),
              title: const Text(
                'عن التطبيق',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4C5494),
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Color(0xFF4C5494)),
              title: const Text(
                'تسجيل الخروج',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4C5494),
                ),
              ),
              onTap: () {
                // هنا تضيف خروج المستخدم
              },
            ),
          ],
        ),
      ),
    );
  }
}
