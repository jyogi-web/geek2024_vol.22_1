import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:aicharamaker/model/chat_message.dart';

class ChatController {
  late GenerativeModel _generativeModel;
  final List<ChatMessage> _messages = []; //メッセージを格納する配列

  ChatController() {
    _initializeGenerativeModel();
  }

  void _initializeGenerativeModel() async {
    try {
      final apiKey = dotenv.env['API_KEY']; // apiキーをenvから取得
      if (apiKey == null) {
        print('API_KEY is not set in .env');
        return;
      }

      _generativeModel = GenerativeModel(
          model: 'gemini-pro', apiKey: apiKey); // apiキーとモデルを指定してインスタンスを生成
    } catch (e) {
      print('Error initializing Generative Model: $e');
    }
  }

  Future<void> onSendPressed(setState, textController) async {
    // 送信ボタン押下時のメソッド
    final text = textController.text;
    sendMessage(text); // コントローラーでメッセージを送信
    setState(() {}); // UIを更新
    await fetchMessage(text); // メッセージ取得
    setState(() {}); // UIを更新
  }

  Future<void> sendMessage(String text) async {
    // メッセージ送信メソッド
    if (text.isEmpty) {
      return;
    }
    _messages.add(ChatMessage(sender: 'User', text: text)); // ユーザーのメッセージを追加
  }

  Future<void> fetchMessage(String text) async {
    // メッセージ受信メソッド
    if (text.isEmpty) {
      return;
    }
    try {
      final response =
          await _generativeModel.generateContent([Content.text(text)]);
      final geminiText = response.text ?? 'No response text';
      _messages.add(
          ChatMessage(sender: 'Gemini', text: geminiText)); // Geminiからのメッセージを追加
    } catch (e) {
      print('Error generating response: $e');
    }
  }

  List<ChatMessage> get messages => _messages; // メッセージのリストを取得
}
