import 'package:flutter/material.dart';
import 'admin_dashboard.dart';
import 'admin_profile_screen.dart';

class ManageCasesScreen extends StatelessWidget {
  const ManageCasesScreen({super.key});

  final Color primaryColor = const Color(0xFF4C5494);

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
          "إدارة المواد القانونية",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            buildButton(
              context,
              "تحديث قاعدة البيانات القانونية",
              const UpdateLegalDatabasePage(),
            ),

            const SizedBox(height: 20),

            buildButton(
              context,
              "تعديل المعاملات القانونية",
              const EditLegalArticlesPage(),
            ),

          ],
        ),
      ),


    );
  }

  Widget buildButton(
      BuildContext context,
      String text,
      Widget page,
      ) {

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

  Widget buildCircleIcon({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {

    return GestureDetector(

      onTap: onTap,

      child: CircleAvatar(

        radius: 24,

        backgroundColor:
        isActive
            ? const Color(0xFF4C5494)
            : Colors.grey[300],

        child: Icon(
          icon,
          color:
          isActive
              ? Colors.white
              : Colors.grey[700],
        ),
      ),
    );
  }
}







/// الصفحات الفارغة


class UpdateLegalDatabasePage extends StatelessWidget {
  const UpdateLegalDatabasePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("تحديث قاعدة البيانات القانونية"),
      ),

      body: const Center(
        child: Text("صفحة فارغة مؤقتاً"),
      ),

    );

  }
}



class EditLegalArticlesPage extends StatelessWidget {
  const EditLegalArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("تعديل المعاملات القانونية"),
      ),

      body: const Center(
        child: Text("صفحة فارغة مؤقتاً"),
      ),

    );

  }
}