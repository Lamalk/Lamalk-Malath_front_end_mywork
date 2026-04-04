import 'package:flutter/material.dart';
import 'manage_users_screen.dart';
import 'manage_cases_screen.dart';
import 'user_activity_screen.dart';
import 'admin_profile_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        centerTitle: true,
        title: Text(
          selectedIndex == 0 ? 'لوحة التحكم' : 'الملف الشخصي',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: selectedIndex == 0
          ? const DashboardBody()
          : const AdminProfileScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF4C5494),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          _buildNavItem(Icons.home, 0),
          _buildNavItem(Icons.person, 1),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, int index) {
    return BottomNavigationBarItem(
      icon: CircleAvatar(
        radius: 20,
        backgroundColor: selectedIndex == index
            ? const Color(0xFF4C5494)
            : Colors.grey[300],
        child: Icon(
          icon,
          color: selectedIndex == index ? Colors.white : Colors.grey,
        ),
      ),
      label: '',
    );
  }
}

class DashboardBody extends StatelessWidget {
  const DashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildButton(context, 'إدارة المستخدمين', const ManageUsersScreen()),
            const SizedBox(height: 20),
            buildButton(
              context,
              'إدارة المواد القانونية',
              const ManageCasesScreen(),
            ),
            const SizedBox(height: 20),
            buildButton(
              context,
              'مراجعة أنشطة المستخدم',
              const UserActivityScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context, String text, Widget page) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4C5494),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}