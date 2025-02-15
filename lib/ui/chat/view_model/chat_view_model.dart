import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:aicharamaker/model/chat_message.dart';
import 'dart:math';

class ChatController {
  late GenerativeModel _generativeModel;
  final List<ChatMessage> _messages = [];
  final List<ChatMessage> _conversationHistory = [];

  ChatController() {
    initialize();
  }

  void initialize() async {
    try {
      final apiKey = dotenv.env['API_KEY'];
      if (apiKey == null) {
        print('API_KEY is not set in .env');
        return;
      }

      _generativeModel = GenerativeModel(
          model: 'gemini-pro', apiKey: apiKey);
    } catch (e) {
      print('Error initializing Generative Model: $e');
    }
  }

  Future<void> onSendPressed(setState, String text, Map<String, dynamic> profile) async {
    sendMessage(text);
    setState(() {});
    await fetchMessage(text, profile);
    setState(() {});
  }

  Future<void> fetchMessage(String text, Map<String, dynamic> profile) async {
    final id = Random().nextInt(1000002).toString();
    final now = DateTime.now();

    if (text.isEmpty) {
      return;
    }

    try {
      final prompt = '''
      あなたは ${profile['name']} というキャラクターになりきって会話してください。
      
      キャラクター情報:
      - 性格: ${profile['personality']}
      - 趣味: ${profile['hobbies']}
      - 好きなもの・嫌いなもの: ${profile['likesDislikes']}
      - その他の特徴: ${profile['otherDetails']}

      過去の会話履歴:
      ${_conversationHistory.map((message) => "${message.sender}: ${message.text}").join('\n')}

      ユーザーからのメッセージ:
      "$text"

      キャラクターらしい口調で適切に応答してください。
      '''; 

      final response = await _generativeModel.generateContent([
        Content.text(prompt),
      ]);

      final geminiText = response.text ?? '応答を生成できませんでした。';

      _messages.add(ChatMessage(
        sender: 'Gemini',
        id: id,
        text: geminiText,
        createdAt: now,
      ));

      _conversationHistory.add(ChatMessage(
        sender: 'Gemini',
        id: id,
        text: geminiText,
        createdAt: now,
      ));
    } catch (e) {
      print('Error generating response: $e');
    }
  }

  Future<void> sendMessage(String text) async {
    final id = Random().nextInt(1000001).toString();
    final now = DateTime.now();

    if (text.isEmpty) {
      return;
    }

    _messages.add(ChatMessage(
      sender: 'User',
      id: id,
      text: text,
      createdAt: now,
    ));

    _conversationHistory.add(ChatMessage(
      sender: 'User',
      id: id,
      text: text,
      createdAt: now,
    ));
  }

  List<ChatMessage> get messages => _messages;
}
