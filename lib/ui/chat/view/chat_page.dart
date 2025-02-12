import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import '../view_model/chat_view_model.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

/// flutter_chat_ui の日本語対応例
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
  Widget build(BuildContext context) {
    /// ここで ChatController 内の messages (独自クラスなど) を
    /// flutter_chat_types の Message 型 (TextMessage など) に変換します
    print('messages: ${_chatController.messages}');
    final chatMessages = _chatController.messages.map((m) {
      print('m $m');
      return types.TextMessage(
        id: m.id.toString(), // それぞれ固有のIDにする
        author: types.User(id: m.sender),
        createdAt: m.createdAt.millisecondsSinceEpoch,
        text: m.text,
      );
    }).toList();

    print('chatMessages $chatMessages');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Gemini'),
      ),
      body: Chat(
        // ログイン中のユーザーの情報
        user: _user,

        // チャット全体のメッセージ
        messages: chatMessages,

        // メッセージの下に表示されるユーザー名やアバターの表示制御
        showUserAvatars: true,
        showUserNames: true,

        // 日本語ローカライズ
        l10n: const ChatL10nJa(),

        // メッセージ送信が押されたときの処理
        onSendPressed: (types.PartialText partialText) {
          print('partialText: ${partialText.text}');
          setState(() {
            // partialText.text を渡す
            _chatController.onSendPressed(setState, partialText.text);
          });
        },
      ),
    );
  }
}
