import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  bool get isLoading => _isLoading;



// Add to your ChatController class
Future<void> sendMessage({
    required String chatId,
    required String text,
    required String receiverId,
  }) async {
    try {
      final currentUserId = _auth.currentUser!.uid;
      final messageRef = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc();

      await _firestore.runTransaction((transaction) async {
        // Add the message
        transaction.set(messageRef, {
          'senderId': currentUserId,
          'text': text,
          'timestamp': FieldValue.serverTimestamp(),
          'read': false,
        });

        // Update chat last message
        transaction.update(_firestore.collection('chats').doc(chatId), {
          'lastMessage': text,
          'lastMessageTime': FieldValue.serverTimestamp(),
        });
      });
    } catch (e) {
      debugPrint('Error sending message: $e');
      rethrow;
    }
  }


  // Get or create a chat between two users
 Future<String> getOrCreateChat(String otherUserId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final currentUserId = _auth.currentUser!.uid;
      final chats = await _firestore
          .collection('chats')
          .where('participants', arrayContains: currentUserId)
          .get();

      // Check if chat already exists
      for (var chat in chats.docs) {
        final participants = List<String>.from(chat['participants']);
        if (participants.contains(otherUserId)) {
          return chat.id;
        }
      }

      // Create new chat
      final newChat = await _firestore.collection('chats').add({
        'participants': [currentUserId, otherUserId],
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
      });

      return newChat.id;
    } catch (e) {
      debugPrint('Error creating chat: $e');
      throw Exception('Failed to create or get chat: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }



   // Get messages stream for a chat
  Stream<QuerySnapshot> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }


  // Stream of user chats
 Stream<QuerySnapshot> getUserChats() {
    final userId = _auth.currentUser!.uid;
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }


  // Get chat ID between two users
 Future<String> getChatId(String otherUserId) async {
    // We'll now use getOrCreateChat to ensure we always have a valid chat ID
    return await getOrCreateChat(otherUserId);
  }

}