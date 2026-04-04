import 'package:flutter/material.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4C5494);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4C5494)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'الملف الشخصي',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'صفحة الملف الشخصي',
          style: TextStyle(
            fontSize: 20,
            color: primaryColor,
          ),
        ),
      ),
    );
  }
}