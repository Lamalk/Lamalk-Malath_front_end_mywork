import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GuidedSelectionScreen extends StatefulWidget {
  const GuidedSelectionScreen({super.key});

  @override
  State<GuidedSelectionScreen> createState() => _GuidedSelectionScreenState();
}

class _GuidedSelectionScreenState extends State<GuidedSelectionScreen> {
  final ScrollController scrollController = ScrollController();

  final List<Map<String, dynamic>> messages = [];
  String currentNode = "start";
  List<String> options = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    messages.add({
      "text":
          "مرحبًا بك في ملاذ.\nحتى أساعدك في تصنيف حالتك، اختر نوع المشكلة التي تواجهها:",
      "isUser": false,
    });

    loadStart();
  }

  Future<void> loadStart() async {
    try {
      final res = await http.get(Uri.parse('http://10.0.2.2:8000/start'));
      final data = jsonDecode(res.body);

      setState(() {
        currentNode = data['node_id'];
        options = List<String>.from(data['options']);
      });

      scrollToBottom();
    } catch (e) {
      setState(() {
        messages.add({
          "text": "تعذر الاتصال بالخادم. تأكد من تشغيل الباك إند.",
          "isUser": false,
        });
      });
    }
  }

  Future<void> sendAnswer(String selected) async {
    if (isLoading) return;

    setState(() {
      messages.add({"text": selected, "isUser": true});
      isLoading = true;
      options = [];
    });

    scrollToBottom();

    try {
      final res = await http.post(
        Uri.parse('http://10.0.2.2:8000/next'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "current_node": currentNode,
          "selected_option": selected,
        }),
      );

      final data = jsonDecode(res.body);

      setState(() {
        if (data.containsKey("message")) {
          messages.add({
            "text": data["message"],
            "isUser": false,
          });

          options = ["إعادة البدء"];
        } else if (data.containsKey("question")) {
          currentNode = data['node_id'];
          messages.add({
            "text": data['question'],
            "isUser": false,
          });
          options = List<String>.from(data['options']);
        } else {
          messages.add({
            "text": "حدث خطأ غير متوقع.",
            "isUser": false,
          });
          options = ["إعادة البدء"];
        }

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        messages.add({
          "text": "تعذر الاتصال بالخادم. حاول مرة أخرى.",
          "isUser": false,
        });
        isLoading = false;
        options = ["إعادة البدء"];
      });
    }

    scrollToBottom();
  }

  Future<void> restartFlow() async {
    setState(() {
      messages.clear();
      messages.add({
        "text":
            "مرحبًا بك في ملاذ.\nحتى أساعدك في تصنيف حالتك، اختر نوع المشكلة التي تواجهها:",
        "isUser": false,
      });
      currentNode = "start";
      options = [];
      isLoading = false;
    });

    await loadStart();
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!scrollController.hasClients) return;

      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Widget buildUserMessage(String text) {
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
        child: Text(text),
      ),
    );
  }

  Widget buildBotMessage(String text) {
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
            constraints: const BoxConstraints(maxWidth: 280),
            decoration: BoxDecoration(
              color: const Color(0xFF4C5494),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOptionButton(String option) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFEEEEEE),
        foregroundColor: const Color(0xFF4C5494),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
onPressed: () {
  if (option == "إعادة البدء") {
    restartFlow();
  } else if (option == "أخرى") {
    Navigator.pushReplacementNamed(context, '/free_text_input');
  } else {
    sendAnswer(option);
  }
},
      child: Text(option),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
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

            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  return msg["isUser"] == true
                      ? buildUserMessage(msg["text"])
                      : buildBotMessage(msg["text"]);
                },
              ),
            ),

            if (isLoading)
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: CircularProgressIndicator(),
              ),

            Container(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: options.map(buildOptionButton).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}