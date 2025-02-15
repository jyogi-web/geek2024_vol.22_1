// チャットメッセージモデル
class ChatMessage {
  final String sender;
  final String text;
  final String id;  // String型に変更
  final DateTime createdAt;

  ChatMessage({
    required this.sender,
    required this.text,
    required this.id,
    required this.createdAt,
  });

  // JSONからChatMessageオブジェクトを生成
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      sender: json['sender'],
      text: json['text'],
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // ChatMessageオブジェクトをJSONに変換
  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'text': text,
      'id': id,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
