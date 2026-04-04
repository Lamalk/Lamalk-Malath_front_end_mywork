import 'package:flutter/material.dart';

class GuidedSelectionScreen extends StatefulWidget {
  const GuidedSelectionScreen({super.key});

  @override
  State<GuidedSelectionScreen> createState() => _GuidedSelectionScreenState();
}

class _GuidedSelectionScreenState extends State<GuidedSelectionScreen> {
  final ScrollController scrollController = ScrollController();

  final List<Map<String, dynamic>> messages = [];

  final List<String> options = [
    "اختراق حساب",
    "ابتزاز إلكتروني",
    "تهديد إلكتروني",
    "سرقة بيانات",
    "احتيال مالي",
    "انتحال شخصية",
    "أخرى",
  ];

  @override
  void initState() {
    super.initState();

    // رسالة البداية من النظام
    messages.add({
      "text":
          "مرحبًا بك في ملاذ.\nحتى أساعدك في تصنيف حالتك، اختر نوع المشكلة التي تواجهها:",
      "isUser": false,
    });
  }

  void selectOption(String text) {
    setState(() {
      // رسالة المستخدم
      messages.add({"text": text, "isUser": true});
    });

    scrollToBottom();

    // رد النظام
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        messages.add({
          "text": "تم اختيار \"$text\" ✅\nسأقوم بتحليل حالتك الآن...",
          "isUser": false,
        });
      });
      scrollToBottom();
    });
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,

        body: Column(
          children: [
            // ================= HEADER =================
            const SizedBox(height: 50),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Color(0xFF4C5494),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Image.asset("assets/images/logo.png", width: 28),
                      const SizedBox(width: 6),
                      const Text(
                        "ملاذ",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4C5494),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              "online",
              style: TextStyle(color: Color(0xFF3ABF38), fontSize: 14),
            ),

            const SizedBox(height: 12),
            const Divider(thickness: 1),

            // ================= MESSAGES =================
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];

                  if (msg["isUser"]) {
                    return Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        constraints: const BoxConstraints(maxWidth: 260),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(msg["text"]),
                      ),
                    );
                  }

                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.asset("assets/images/logo.png", width: 22),
                        const SizedBox(width: 6),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          constraints: const BoxConstraints(maxWidth: 260),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4C5494),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            msg["text"],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // ================= OPTIONS =================
            Container(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    options
                        .map(
                          (option) => ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFEEEEEE),
                              foregroundColor: const Color(0xFF4C5494),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => selectOption(option),
                            child: Text(option),
                          ),
                        )
                        .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
