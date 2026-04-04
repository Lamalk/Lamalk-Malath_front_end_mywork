import 'package:flutter/material.dart';

class FreeTextInputScreen extends StatefulWidget {
  const FreeTextInputScreen({super.key});

  @override
  State<FreeTextInputScreen> createState() => _FreeTextInputScreenState();
}

class _FreeTextInputScreenState extends State<FreeTextInputScreen> {
  final TextEditingController controller = TextEditingController();
  final List<Map<String, dynamic>> messages = [];
  final ScrollController scrollController = ScrollController();

  void sendMessage() {
    if (controller.text.trim().isEmpty) return;

    final text = controller.text.trim();

    setState(() {
      messages.add({"text": text, "isUser": true});
    });

    controller.clear();
    scrollToBottom();

    // رد تجريبي من البوت
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        messages.add({
          "text": "تم استلام رسالتك، جاري المساعدة...",
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
                  // 🔙 زر الرجوع
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

                  // ========= رسالة المستخدم =========
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
                        child: Text(
                          msg["text"],
                          textDirection: TextDirection.rtl, // عربي
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    );
                  }

                  // ========= رسالة البوت =========
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
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // ================= INPUT =================
            Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,

                      // ✅ يدعم العربي
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,

                      decoration: InputDecoration(
                        hintText: "اكتب مشكلتك...",
                        filled: true,
                        fillColor: const Color(0xFFEEEEEE),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: sendMessage,
                    icon: const Icon(Icons.send, color: Color(0xFF4C5494)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
