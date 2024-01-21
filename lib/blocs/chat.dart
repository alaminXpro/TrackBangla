import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:trackbangla/models/chat.dart';


class ChatModel extends ChangeNotifier {
  final FirebaseFirestore _firestore;
  List<ChatMessage> _messages = [];

  ChatModel(this._firestore);

  List<ChatMessage> get messages => _messages;

  Future<void> sendMessage(ChatMessage message) async {
    // Generate a unique ID for the chat
    String chatId = message.senderUid.compareTo(message.receiverUid) > 0
        ? message.senderUid + message.receiverUid
        : message.receiverUid + message.senderUid;

    // Get a reference to the chat document
    DocumentReference chatDocRef = _firestore.collection('chatroom').doc(chatId);

    // Add the message to the messages sub-collection
    await chatDocRef.collection('messages').add(message.toMap());

    // Fetch the updated list of messages
    QuerySnapshot querySnapshot = await chatDocRef.collection('messages').orderBy('timestamp').get();

    _messages = querySnapshot.docs
        .map((doc) => ChatMessage.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

    notifyListeners();
  }

  Future<void> loadMessages(String senderUid, String receiverUid) async {
    // Generate a unique ID for the chat
    String chatId = senderUid.compareTo(receiverUid) > 0
        ? senderUid + receiverUid
        : receiverUid + senderUid;

    // Get a reference to the chat document
    DocumentReference chatDocRef = _firestore.collection('chatroom').doc(chatId);

    // Check if the chat document exists
    DocumentSnapshot chatDocSnapshot = await chatDocRef.get();
    if (!chatDocSnapshot.exists) {
      // If the chat document doesn't exist, initialize it with an empty messages collection
      await chatDocRef.set(Map<String, dynamic>());
    }

    // Fetch the list of messages
    QuerySnapshot querySnapshot = await chatDocRef.collection('messages').orderBy('timestamp').get();

    _messages = querySnapshot.docs
        .map((doc) => ChatMessage.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

    notifyListeners();
  }
}