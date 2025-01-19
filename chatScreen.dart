import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // JSON işlemleri için

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String otherUserId;

  ChatScreen({required this.currentUserId, required this.otherUserId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  List<Map<String, String>> messages = []; // Mesajları saklamak için liste

  @override
  void initState() {
    super.initState();
    loadMessages(); // Mesajları yükle
  }

  Future<void> loadMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedMessages = prefs.getString('messages');
    if (storedMessages != null) {
      List<dynamic> decodedMessages = jsonDecode(storedMessages);
      setState(() {
        messages = decodedMessages
            .map((message) => Map<String, String>.from(message))
            .toList();
      });
    }
  }

  Future<void> saveMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedMessages = jsonEncode(messages);
    await prefs.setString('messages', encodedMessages);
  }

  void sendMessage(String content) {
    setState(() {
      messages.add({
        "from": widget.currentUserId,
        "to": widget.otherUserId,
        "content": content,
      });
    });
    saveMessages(); // Mesajları kaydet
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mesajlaşma (${widget.currentUserId})"),
        backgroundColor: Colors.green, // Uygulama başlığı için yeşil renk
      ),
      body: Container(
        decoration: BoxDecoration(
          // Arka plan için renk
          color: Colors.blue[200],
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[messages.length - 1 - index];
                  bool isCurrentUserMessage =
                      message["from"] == widget.currentUserId;
                  return Align(
                    alignment: isCurrentUserMessage
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isCurrentUserMessage
                            ? Colors.green[700] // Giden mesaj: koyu yeşil
                            : Colors.green[400], // Gelen mesaj: açık yeşil
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        message["content"]!,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: "Mesaj yaz...",
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (content) {
                        if (content.isNotEmpty) {
                          sendMessage(content); // Enter tuşuna basınca mesaj gönder
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      if (messageController.text.isNotEmpty) {
                        sendMessage(messageController.text);
                      }
                    },
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
