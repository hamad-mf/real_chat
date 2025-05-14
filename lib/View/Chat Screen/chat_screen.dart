import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_chat/Controller/Chat%20Controller/chat_controller.dart';
import 'package:real_chat/Utils/color_constants.dart';
import 'package:real_chat/View/Widgets/responsive_helper.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final String receiverImage;
  final String receiverUsername;

  const ChatScreen({
    super.key,
    required this.receiverUsername,
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
  bool showPopup = false;

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
      final chatController =
          Provider.of<ChatController>(context, listen: false);
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
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: ColorConstants.ChatScrnBg,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 21,
              backgroundImage: NetworkImage(widget.receiverImage),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.receiverName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  widget.receiverUsername,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: ColorConstants.lastMessage),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Image.asset('assets/images/icons/video_call.png'),
              SizedBox(
                width: ResponsiveHelper.width(32),
              ),
              Image.asset('assets/images/icons/voice_call.png'),
              SizedBox(
                width: ResponsiveHelper.width(32),
              )
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(children: [
              Column(
                children: [
                  Expanded(
                    child: _chatId == null
                        ? const Center(child: Text('Could not initialize chat'))
                        : StreamBuilder<QuerySnapshot>(
                            stream: chatController.getMessages(_chatId!),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              final messages = snapshot.data?.docs ?? [];

                              return messages.isEmpty
                                  ? const Center(
                                      child:
                                          Text('No messages yet. Say hello!'))
                                  : ListView.builder(
                                      reverse: true,
                                      itemCount: messages.length,
                                      itemBuilder: (context, index) {
                                        final message = messages[index];
                                        final isMe = message['senderId'] ==
                                            currentUserId;

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
                                                  ? ColorConstants.SendedMsgBg
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: isMe
                                                  ? CrossAxisAlignment.end
                                                  : CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  message['text'],
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: isMe
                                                          ? Colors.white
                                                          : Colors.black),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  _formatTimestamp(
                                                      message['timestamp']),
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: isMe
                                                        ? Colors.white
                                                        : Colors.grey,
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
                  Container(
                    height: ResponsiveHelper.height(90),
                    decoration: BoxDecoration(color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: ResponsiveHelper.width(12),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                showPopup = !showPopup;
                              });
                            },
                            icon: Icon(showPopup ? Icons.close : Icons.add),
                            iconSize: 30,
                            color: ColorConstants.AppBarBlue,
                          ),
                          SizedBox(
                            width: ResponsiveHelper.width(12),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                hintText: 'Type a message...',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                              ),
                            ),
                          ),
                          InkWell(
                              onTap: () async {
                                if (_messageController.text.trim().isEmpty)
                                  return;
                                if (_chatId == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Could not send message, chat not initialized')),
                                  );
                                  return;
                                }

                                final messageText =
                                    _messageController.text.trim();
                                _messageController
                                    .clear(); // Clear early for better UX

                                try {
                                  await chatController.sendMessage(
                                    chatId: _chatId!,
                                    text: messageText,
                                    receiverId: widget.receiverId,
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Failed to send message: $e')),
                                  );
                                }
                              },
                              child: Image.asset(
                                  'assets/images/icons/send_btn.png'))
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Outside tap dismiss area
              if (showPopup)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showPopup = false;
                    });
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),

              if (showPopup)
                Positioned(
                  bottom: 95,
                  right: 16,
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: ResponsiveHelper.width(343),
                      height: ResponsiveHelper.height(270),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() => showPopup = false);
                                      },
                                      child: CircleAvatar(
                                        child: Icon(
                                          Icons.photo_camera,
                                          color: Colors.white,
                                        ),
                                        radius: 28,
                                        backgroundColor: ColorConstants
                                            .AppBarBlue.withOpacity(0.8),
                                      ),
                                    ),
                                    SizedBox(
                                      height: ResponsiveHelper.height(12),
                                    ),
                                    Text(
                                      "Camera",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() => showPopup = false);
                                      },
                                      child: CircleAvatar(
                                        child: Icon(
                                          Icons.mic,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                        radius: 28,
                                        backgroundColor: ColorConstants
                                            .AppBarBlue.withOpacity(0.8),
                                      ),
                                    ),
                                    SizedBox(
                                      height: ResponsiveHelper.height(12),
                                    ),
                                    Text(
                                      "Record",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() => showPopup = false);
                                      },
                                      child: CircleAvatar(
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.white,
                                          size: 27,
                                        ),
                                        radius: 28,
                                        backgroundColor: ColorConstants
                                            .AppBarBlue.withOpacity(0.8),
                                      ),
                                    ),
                                    SizedBox(
                                      height: ResponsiveHelper.height(12),
                                    ),
                                    Text(
                                      "Contacts",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() => showPopup = false);
                                      },
                                      child: CircleAvatar(
                                        child: Icon(
                                          Icons.photo_library,
                                          color: Colors.white,
                                        ),
                                        radius: 28,
                                        backgroundColor: ColorConstants
                                            .AppBarBlue.withOpacity(0.8),
                                      ),
                                    ),
                                    SizedBox(
                                      height: ResponsiveHelper.height(12),
                                    ),
                                    Text(
                                      "Gallery",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() => showPopup = false);
                                      },
                                      child: CircleAvatar(
                                        child: Icon(
                                          Icons.location_on,
                                          color: Colors.white,
                                          size: 26,
                                        ),
                                        radius: 28,
                                        backgroundColor: ColorConstants
                                            .AppBarBlue.withOpacity(0.8),
                                      ),
                                    ),
                                    SizedBox(
                                      height: ResponsiveHelper.height(12),
                                    ),
                                    Text(
                                      "My Location",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() => showPopup = false);
                                      },
                                      child: CircleAvatar(
                                        child: Icon(
                                          Icons.description,
                                          color: Colors.white,
                                          size: 25,
                                        ),
                                        radius: 28,
                                        backgroundColor: ColorConstants
                                            .AppBarBlue.withOpacity(0.8),
                                      ),
                                    ),
                                    SizedBox(
                                      height: ResponsiveHelper.height(12),
                                    ),
                                    Text(
                                      "Documents",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ]),
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
