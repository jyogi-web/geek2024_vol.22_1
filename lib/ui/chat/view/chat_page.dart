import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import '../view_model/chat_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aicharamaker/ui/auth/view/auth_page.dart';
import 'package:aicharamaker/ui/home/ProfileListScreen.dart';

class ChatPage extends StatefulWidget {
  final Map<String, dynamic>? profile;

  const ChatPage({super.key, this.profile});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatController _chatController = ChatController();
  late types.User _user;
  late types.User _gemini;

  @override
  void initState() {
    super.initState();
    _chatController.initialize();

    // Firebaseのユーザー情報を取得
    final firebaseUser = FirebaseAuth.instance.currentUser;

    // 自分のユーザー情報を設定
    _user = types.User(
      id: firebaseUser?.uid ?? 'unknown_user',
      firstName: firebaseUser?.displayName ?? 'ゲスト',
      imageUrl: firebaseUser?.photoURL, // 自分のアイコン画像を設定
    );

    // Gemini（キャラ）のユーザー情報を設定
    _gemini = types.User(
      id: 'gemini',
      firstName: widget.profile?['name'] ?? 'Gemini',
      imageUrl: widget.profile?['imageUrl'], // Geminiのアイコン画像を設定
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // 1. **ログインしていない場合**
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text("ログインが必要です")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 100, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                "ログインしてください",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AuthPage()),
                  );
                },
                child: Text("ログイン"),
              ),
            ],
          ),
        ),
      );
    }

    // 2. **キャラが設定されていない場合**
    if (widget.profile == null) {
      return Scaffold(
        appBar: AppBar(title: Text("キャラを選択")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_outline, size: 100, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                "キャラクターを選択してください",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileListScreen()),
                  );
                },
                child: Text("キャラクターを選ぶ"),
              ),
            ],
          ),
        ),
      );
    }

    // **キャラの情報を取得**
    final String profileName = widget.profile!['name'] ?? "キャラ名なし";
    final String? profileImageUrl = widget.profile!['imageUrl'];

    final chatMessages = _chatController.messages.map((m) {
      return types.TextMessage(
        id: m.id.toString(),
        author: m.sender == 'User' ? _user : _gemini, // **送信者を区別**
        createdAt: m.createdAt.millisecondsSinceEpoch,
        text: m.text,
      ) as types.Message;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: profileImageUrl != null && profileImageUrl.isNotEmpty
                  ? NetworkImage(profileImageUrl)
                  : null,
              child: (profileImageUrl == null || profileImageUrl.isEmpty)
                  ? Icon(Icons.person, size: 24)
                  : null,
            ),
            SizedBox(width: 10),
            Text(profileName),
          ],
        ),
      ),
      body: Chat(
        user: _user,
        messages: chatMessages.reversed.toList(),
        showUserAvatars: true,
        showUserNames: true,
        avatarBuilder: (user) {
          if (user.id == _user.id) {
            // **自分のアイコン**
            return CircleAvatar(
              backgroundImage: _user.imageUrl != null
                  ? NetworkImage(_user.imageUrl!)
                  : null,
              child: _user.imageUrl == null
                  ? Icon(Icons.person, size: 24)
                  : null,
            );
          }

          // **相手（Gemini）のアイコン**
          return CircleAvatar(
            backgroundImage: _gemini.imageUrl != null
                ? NetworkImage(_gemini.imageUrl!)
                : null,
            child: _gemini.imageUrl == null
                ? Icon(Icons.person, size: 24)
                : null,
          );
        },
        onSendPressed: (types.PartialText partialText) {
          _chatController.onSendPressed(setState, partialText.text, widget.profile!);
        },
      ),
    );
  }
}
