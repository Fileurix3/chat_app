import 'package:chat_app/bloc/chat/chat_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserName;
  final String receiverUserUid;
  const ChatPage({
    super.key,
    required this.receiverUserName,
    required this.receiverUserUid,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeOutQuint,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUserName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: context.read<ChatCubit>().getMessage(
                    widget.receiverUserUid,
                    FirebaseAuth.instance.currentUser!.uid,
                  ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.hasError.toString()));
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot doc = snapshot.data!.docs[index];
                      Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;

                      Alignment alignment = (data["senderUid"] ==
                              FirebaseAuth.instance.currentUser!.uid)
                          ? Alignment.centerRight
                          : Alignment.centerLeft;

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        alignment: alignment,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width / 1.4,
                            minWidth: 0,
                          ),
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: FirebaseAuth.instance.currentUser!.uid ==
                                    data["senderUid"]
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).cardColor,
                          ),
                          child: Column(
                            children: [
                              Text(
                                data["message"],
                                style: TextStyle(
                                  fontSize: 18,
                                  color:
                                      FirebaseAuth.instance.currentUser!.uid ==
                                              data["senderUid"]
                                          ? Colors.white
                                          : Theme.of(context)
                                                      .colorScheme
                                                      .brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Colors.black,
                                ),
                                overflow: TextOverflow.clip,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                top: BorderSide(
                  width: 1,
                  color: Colors.grey[700]!,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 8,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your message...',
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      style: Theme.of(context).textTheme.labelMedium,
                      minLines: 1,
                      maxLines: 5,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if (messageController.text.isNotEmpty) {
                        context.read<ChatCubit>().sendMessage(
                              widget.receiverUserUid,
                              messageController.text,
                            );
                        messageController.clear();
                        _scrollToBottom();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
