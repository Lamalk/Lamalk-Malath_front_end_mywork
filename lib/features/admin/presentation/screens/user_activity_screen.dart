import 'package:flutter/material.dart';

class UserActivityScreen extends StatelessWidget {
  const UserActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4C5494)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'مراجعة أنشطة المستخدم',
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
              buildButton(context, 'القضايا', const CasesActivityPage()),
              const SizedBox(height: 20),
              buildButton(
                context,
                'عمليات تسجيل الدخول',
                const LoginActivityPage(),
              ),
              const SizedBox(height: 20),
              buildButton(context, 'التعديلات', const EditsActivityPage()),
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

class CasesActivityPage extends StatelessWidget {
  const CasesActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('القضايا'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4C5494)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('صفحة القضايا - مؤقتة'),
      ),
    );
  }
}

class LoginActivityPage extends StatelessWidget {
  const LoginActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('عمليات تسجيل الدخول'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4C5494)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('صفحة عمليات تسجيل الدخول - مؤقتة'),
      ),
    );
  }
}

class EditsActivityPage extends StatelessWidget {
  const EditsActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التعديلات'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4C5494)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('صفحة التعديلات - مؤقتة'),
      ),
    );
  }
}