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
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Widget buildMessageItem(DocumentSnapshot doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      print("123132123231123123 ${data["message"]}");
      Alignment alignment =
          (data["senderUid"] == FirebaseAuth.instance.currentUser!.uid)
              ? Alignment.centerRight
              : Alignment.centerLeft;

      return Container(
        alignment: alignment,
        child: Column(
          children: [
            Text(data["senderName"]),
            Text(data["message"]),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.receiverUserName,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
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
                  return ListView(
                    children: snapshot.data!.docs
                        .map((doc) => buildMessageItem(doc))
                        .toList(),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your message...',
                    ),
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
}
