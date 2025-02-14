import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import '../view_model/chat_view_model.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class ChatL10nJa extends ChatL10n {
  const ChatL10nJa({
    super.attachmentButtonAccessibilityLabel = '画像アップロード',
    super.emptyChatPlaceholder = 'メッセージがありません。',
    super.fileButtonAccessibilityLabel = 'ファイル',
    super.inputPlaceholder = 'メッセージを入力してください',
    super.sendButtonAccessibilityLabel = '送信',
  }) : super(
          and: 'と',
          isTyping: 'が入力中',
          others: '他',
          unreadMessagesLabel: '未読メッセージ',
        );
}

class _ChatPageState extends State<ChatPage> {
  final ChatController _chatController = ChatController();
  final _user = types.User(id: 'my_user_id'); // 自分のユーザーIDを適宜設定

  @override
  void initState() {
    super.initState();
    _chatController.initialize(); // 初期化
  }

  @override
  Widget build(BuildContext context) {
    final chatMessages = _chatController.messages.map((m) {
      return types.TextMessage(
        id: m.id.toString(),
        author: types.User(id: m.sender),
        createdAt: m.createdAt.millisecondsSinceEpoch,
        text: m.text,
      ) as types.Message;  // Message 型にキャスト
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Gemini'),
      ),
      body: Chat(
        user: _user,
        messages: chatMessages,
        showUserAvatars: true,
        showUserNames: true,
        l10n: const ChatL10nJa(),
        onSendPressed: (types.PartialText partialText) {
          _chatController.onSendPressed(setState, partialText.text);
        },
      ),
    );
  }
}
