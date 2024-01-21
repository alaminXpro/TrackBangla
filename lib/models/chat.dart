class ChatMessage {
  final String senderUid;
  final String receiverUid;
  final String message;
  final DateTime timestamp;

  ChatMessage({
    required this.senderUid,
    required this.receiverUid,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderUid': senderUid,
      'receiverUid': receiverUid,
      'message': message,
      'timestamp': timestamp,
    };
  }

  static ChatMessage fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      senderUid: map['senderUid'],
      receiverUid: map['receiverUid'],
      message: map['message'],
      timestamp: map['timestamp'].toDate(),
    );
  }
}