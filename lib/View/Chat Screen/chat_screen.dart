import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_chat/Controller/Chat%20Controller/chat_controller.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final String receiverImage;

  const ChatScreen({
    super.key,
    required this.receiverId,
    required this.receiverName,
    required this.receiverImage,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  String? _chatId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChatId();
  }

  Future<void> _loadChatId() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final chatController = Provider.of<ChatController>(context, listen: false);
      // This now ensures we always get a chat ID, even if one doesn't exist yet
      _chatId = await chatController.getOrCreateChat(widget.receiverId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to initialize chat: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final chatController = Provider.of<ChatController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.receiverImage),
            ),
            const SizedBox(width: 10),
            Text(widget.receiverName),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: _chatId == null
                      ? const Center(child: Text('Could not initialize chat'))
                      : StreamBuilder<QuerySnapshot>(
                          stream: chatController.getMessages(_chatId!),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            }

                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            final messages = snapshot.data?.docs ?? [];

                            return messages.isEmpty
                                ? const Center(child: Text('No messages yet. Say hello!'))
                                : ListView.builder(
                                    reverse: true,
                                    itemCount: messages.length,
                                    itemBuilder: (context, index) {
                                      final message = messages[index];
                                      final isMe = message['senderId'] == currentUserId;

                                      return Align(
                                        alignment: isMe
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 8),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 14),
                                          decoration: BoxDecoration(
                                            color: isMe
                                                ? Colors.blue[200]
                                                : Colors.grey[300],
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: isMe
                                                ? CrossAxisAlignment.end
                                                : CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                message['text'],
                                                style: const TextStyle(fontSize: 16),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                _formatTimestamp(message['timestamp']),
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () async {
                          if (_messageController.text.trim().isEmpty) return;
                          if (_chatId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Could not send message, chat not initialized')),
                            );
                            return;
                          }

                          final messageText = _messageController.text.trim();
                          _messageController.clear(); // Clear early for better UX

                          try {
                            await chatController.sendMessage(
                              chatId: _chatId!,
                              text: messageText,
                              receiverId: widget.receiverId,
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to send message: $e')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'Sending...';
    
    final dateTime = timestamp.toDate();
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}