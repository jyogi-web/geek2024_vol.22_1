import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:aicharamaker/model/chat_message.dart';
import 'dart:math';

class ChatController {
  late GenerativeModel _generativeModel;
  final List<ChatMessage> _messages = []; //メッセージを格納する配列

  ChatController() {
    _initializeGenerativeModel();
  }

  void _initializeGenerativeModel() async {
    // ジェネレーティブモデルの初期化
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

  Future<void> onSendPressed(setState, text) async {
    // 送信ボタン押下時のメソッド
    print('onSendPressed: $text');
    sendMessage(text); // コントローラーでメッセージを送信
    setState(() {}); // UIを更新
    await fetchMessage(text); // メッセージ取得
    setState(() {}); // UIを更新
  }

  Future<void> sendMessage(String text) async {
    final id = Random().nextInt(1000001); // ランダムなIDを生成
    final now = DateTime.now(); // 現在時刻を取得
    // メッセージ送信メソッド
    if (text.isEmpty) {
      return;
    }
    _messages.add(ChatMessage(
        sender: 'User', id: id, text: text, createdAt: now)); // ユーザーのメッセージを追加
  }

  Future<void> fetchMessage(String text) async {
    final id = Random().nextInt(1000002); // ランダムなIDを生成
    final now = DateTime.now(); // 現在時刻を取
    // メッセージ受信メソッド
    if (text.isEmpty) {
      return;
    }
    try {
      final response =
          await _generativeModel.generateContent([Content.text(text)]);
      final geminiText = response.text ?? 'No response text';
      _messages.add(ChatMessage(
          sender: 'Gemini',
          id: id,
          text: geminiText,
          createdAt: now)); // Geminiからのメッセージを追加
    } catch (e) {
      print('Error generating response: $e');
    }
  }

  List<ChatMessage> get messages => _messages; // メッセージのリストを取得
}
