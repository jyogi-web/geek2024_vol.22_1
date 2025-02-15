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

      // Generative AIモデルの初期化
      _generativeModel = GenerativeModel(
          model: 'gemini-pro', apiKey: apiKey); // apiキーとモデルを指定してインスタンスを生成
      print("Generative model initialized successfully.");
    } catch (e) {
      print('Error initializing Generative Model: $e');
    }
  }

  Future<void> onSendPressed(setState, String text) async {
    // 送信ボタン押下時のメソッド
    print('onSendPressed: $text');
    
    // ユーザーのメッセージを送信
    sendMessage(text); // コントローラーでメッセージを送信
    setState(() {}); // UIを更新
    
    // ユーザーのメッセージを基にGeminiの応答を取得
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
      sender: 'User', id: id, text: text, createdAt: now
    ));

    // 会話履歴にメッセージを追加
    _conversationHistory.add(ChatMessage(
      sender: 'User', id: id, text: text, createdAt: now
    ));
  }

  Future<void> fetchMessage(String text) async {
    final id = Random().nextInt(1000002).toString(); // ランダムなIDを生成してString型に変換
    final now = DateTime.now(); // 現在時刻を取得

    if (text.isEmpty) {
      return;
    }

    try {
      // ユーザーのメッセージと会話履歴に基づいて、プロンプトを生成
      final prompt = '''
      あなたは親しみやすく、知識豊富なアシスタントです。以下の会話履歴に基づいて、適切な応答を生成してください。

      会話履歴:
      ${_conversationHistory.map((message) => "${message.sender}: ${message.text}").join('\n')}

      ユーザーからのメッセージ:
      "$text"
      
      応答は、丁寧で分かりやすく、必要であれば詳しい情報を追加してください。 
      もしユーザーが質問している場合、具体的な情報を提供するように心がけてください。
      応答が不明確な場合は、追加の質問をするか、確認を行うようにしてください。
      '''; // ユーザーのメッセージと会話履歴を含むプロンプト

      // 会話履歴を考慮したジェネレーティブAIの応答を取得
      final response = await _generativeModel.generateContent([
        Content.text(prompt), // 作成したプロンプトをAIに送信
      ]);

      final geminiText = response.text ?? '応答を生成できませんでした。';

      // 取得したAIの応答をメッセージリストに追加
      _messages.add(ChatMessage(
        sender: 'Gemini', id: id, text: geminiText, createdAt: now
      ));

      // 会話履歴にGeminiからのメッセージを追加
      _conversationHistory.add(ChatMessage(
        sender: 'Gemini', id: id, text: geminiText, createdAt: now
      ));
    } catch (e) {
      print('Error generating response: $e');
    }
  }

  List<ChatMessage> get messages => _messages; // メッセージのリストを取得

  List<ChatMessage> get conversationHistory => _conversationHistory; // 会話履歴を取得
}
