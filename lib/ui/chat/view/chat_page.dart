import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import '../view_model/chat_view_model.dart';

class ChatPage extends StatefulWidget {
  final Map<String, dynamic> profile;

  const ChatPage({super.key, required this.profile});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatController _chatController = ChatController();
  final _user = types.User(id: 'my_user_id');

  @override
  void initState() {
    super.initState();
    _chatController.initialize();
  }

  @override
  Widget build(BuildContext context) {
    final chatMessages = _chatController.messages.map((m) {
      return types.TextMessage(
        id: m.id.toString(),
        author: types.User(id: m.sender),
        createdAt: m.createdAt.millisecondsSinceEpoch,
        text: m.text,
      ) as types.Message;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with ${widget.profile['name']}"),
      ),
      body: Chat(
        user: _user,
        messages: chatMessages.reversed.toList(),
        showUserAvatars: true,
        showUserNames: true,
        onSendPressed: (types.PartialText partialText) {
          _chatController.onSendPressed(setState, partialText.text, widget.profile);
        },
      ),
    );
  }
}
