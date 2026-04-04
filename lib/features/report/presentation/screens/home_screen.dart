import 'package:flutter/material.dart';
import 'package:front_end/widgets/custom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // مؤشر الصفحة الحالية

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          // كل المحتوى في الوسط
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'اختر طريقة إدخال الحالة',
                style: TextStyle(
                  color: Color(0xFF818898),
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 100),
              CustomButton(
                text: 'إدخال نص حر',
                onPressed: () {
                  Navigator.pushNamed(context, '/free_text_input');
                },
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'اختيار من قائمة',
                onPressed: () {
                  Navigator.pushNamed(context, '/guided_select');
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.white,
          unselectedItemColor: const Color(0xFF666D80),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });

            // التنقل حسب أيقونة البار
            if (index == 0) {
              // الرئيسية، ممكن تظل في نفس الصفحة أو تنقل لصفحة أخرى
            } else if (index == 1) {
              Navigator.pushNamed(context, '/profile'); // رابط صفحة البروفايل
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      _currentIndex == 0
                          ? const Color(0xFF4C5494)
                          : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.home, color: Color(0xFF666D80)),
              ),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      _currentIndex == 1
                          ? const Color(0xFF4C5494)
                          : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Color(0xFF666D80)),
              ),
              label: 'حسابي',
            ),
          ],
        ),
      ),
    );
  }
}
