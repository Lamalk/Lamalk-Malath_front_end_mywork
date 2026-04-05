import 'package:flutter/material.dart';

class ManageUsersScreen extends StatelessWidget {
  const ManageUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4C5494)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.grey[100],
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'إدارة المستخدمين',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildButton(context, 'قائمة المستخدمين', const UsersListPage()),
              const SizedBox(height: 20),
              buildButton(context, 'إضافة مستخدم', const AddUserPage()),
              const SizedBox(height: 20),
              buildButton(context, 'تعديل ملف المستخدم', const EditUserPage()),
              const SizedBox(height: 20),
              buildButton(context, 'حذف حساب مستخدم', const DeleteUserPage()),
            ],
          ),
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

class UsersListPage extends StatelessWidget {
  const UsersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة المستخدمين'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4C5494)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('صفحة قائمة المستخدمين - مؤقتة'),
      ),
    );
  }
}

class AddUserPage extends StatelessWidget {
  const AddUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة مستخدم'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4C5494)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('صفحة إضافة مستخدم - مؤقتة'),
      ),
    );
  }
}

class EditUserPage extends StatelessWidget {
  const EditUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل ملف المستخدم'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4C5494)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('صفحة تعديل المستخدم - مؤقتة'),
      ),
    );
  }
}

class DeleteUserPage extends StatelessWidget {
  const DeleteUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حذف حساب مستخدم'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4C5494)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('صفحة حذف حساب مستخدم - مؤقتة'),
      ),
    );
  }
}