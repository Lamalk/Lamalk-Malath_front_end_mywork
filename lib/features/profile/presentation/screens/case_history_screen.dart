import 'package:flutter/material.dart';

class CaseHistoryScreen extends StatelessWidget {
  const CaseHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4C5494)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'سجل القضايا',
          style: TextStyle(
            color: Color(0xFF4C5494),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          CaseCard(
            crimeType: 'ابتزاز إلكتروني',
            caseNumber: '2024011',
            date: '2025 / 01 / 12',
          ),
          CaseCard(
            crimeType: 'اختراق حساب',
            caseNumber: '2024012',
            date: '2025 / 01 / 15',
          ),
          CaseCard(
            crimeType: 'احتيال مالي',
            caseNumber: '2024013',
            date: '2025 / 01 / 17',
          ),
        ],
      ),
    );
  }
}

class CaseCard extends StatelessWidget {
  final String crimeType;
  final String caseNumber;
  final String date;

  const CaseCard({
    super.key,
    required this.crimeType,
    required this.caseNumber,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4C5494);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: primaryColor),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'نوع الجريمة: $crimeType',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'رقم القضية: $caseNumber',
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 8),
          Text(
            'التاريخ: $date',
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 3,
              ),
              onPressed: () {},
              child: const Text(
                'عرض التفاصيل',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}