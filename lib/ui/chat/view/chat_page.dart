import 'package:flutter/material.dart';
import '../view_model/chat_view_model.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatController _chatController = ChatController();
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Gemini'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _chatController.messages.length,
              itemBuilder: (context, index) {
                final message = _chatController.messages[index];
                return ListTile(
                  title: Text('${message.sender}: ${message.text}'),
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
                    // メッセージ入力フィールド
                    controller: _textController,
                    decoration: const InputDecoration(
                      labelText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  // 送信ボタン
                  icon: const Icon(Icons.send),
                  onPressed: () =>
                      _chatController.onSendPressed(setState, _textController),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
