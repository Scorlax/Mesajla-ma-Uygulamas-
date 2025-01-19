import 'package:flutter/material.dart';
import 'chatScreen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Giriş Yap")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      currentUserId: "User: 00000001",
                      otherUserId: "User: 00000010",
                    ),
                  ),
                );
              },
              child: Text("00000001 olarak giriş yap"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      currentUserId: "User: 00000010",
                      otherUserId: "User: 00000001",
                    ),
                  ),
                );
              },
              child: Text("00000010 olarak giriş yap"),
            ),
          ],
        ),
      ),
    );
  }
}
