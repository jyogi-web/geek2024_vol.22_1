//チャットメッセージモデル
class ChatMessage {
  final String sender;
  final String text;
  final int id;
  final DateTime createdAt;

  ChatMessage(
      {required this.sender,
      required this.text,
      required this.id,
      required this.createdAt});
}
