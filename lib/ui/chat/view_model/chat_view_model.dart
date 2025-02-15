import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:aicharamaker/model/chat_message.dart';
import 'dart:math';

class ChatController {
  late GenerativeModel _generativeModel;
  final List<ChatMessage> _messages = []; // メッセージを格納する配列
  final List<ChatMessage> _conversationHistory = []; // 会話履歴を保持

  ChatController() {
    initialize();  // initialize メソッドを呼び出して初期化
  }

  void initialize() async {
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

  Future<void> onSendPressed(setState, String text) async {
    // 送信ボタン押下時のメソッド
    print('onSendPressed: $text');
    sendMessage(text); // コントローラーでメッセージを送信
    setState(() {}); // UIを更新
    await fetchMessage(text); // メッセージ取得
    setState(() {}); // UIを更新
  }

  Future<void> sendMessage(String text) async {
    final id = Random().nextInt(1000001).toString(); // ランダムなIDを生成してString型に変換
    final now = DateTime.now(); // 現在時刻を取得

    if (text.isEmpty) {
      return;
    }

    // ユーザーのメッセージを追加
    _messages.add(ChatMessage(
        sender: 'User', id: id, text: text, createdAt: now));

    // 会話履歴にメッセージを追加
    _conversationHistory.add(ChatMessage(
        sender: 'User', id: id, text: text, createdAt: now));
  }

  Future<void> fetchMessage(String text) async {
    final id = Random().nextInt(1000002).toString(); // ランダムなIDを生成してString型に変換
    final now = DateTime.now(); // 現在時刻を取得

    if (text.isEmpty) {
      return;
    }

    try {
      // 会話履歴を考慮したジェネレーティブAIの応答
      final response = await _generativeModel.generateContent([
        Content.text(text),
        ..._conversationHistory.map((message) => Content.text(message.text))
      ]);
      final geminiText = response.text ?? 'No response text';

      _messages.add(ChatMessage(
          sender: 'Gemini', id: id, text: geminiText, createdAt: now));

      // 会話履歴にGeminiからのメッセージを追加
      _conversationHistory.add(ChatMessage(
          sender: 'Gemini', id: id, text: geminiText, createdAt: now));
    } catch (e) {
      print('Error generating response: $e');
    }
  }

  List<ChatMessage> get messages => _messages; // メッセージのリストを取得

  List<ChatMessage> get conversationHistory => _conversationHistory; // 会話履歴を取得
}
