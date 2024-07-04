part of './chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatState());

  void sendMessage(String receiverUid, String message) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    final String currentUserUid = firebaseAuth.currentUser!.uid;
    final String currentUserName =
        firebaseAuth.currentUser!.displayName ?? 'Unknown';
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderUid: currentUserUid,
      senderName: currentUserName,
      receiverUid: receiverUid,
      message: message,
      timestamp: timestamp,
    );

    List<String> ids = [currentUserUid, receiverUid];
    ids.sort();
    String chatRoomId = ids.join("_");

    await FirebaseFirestore.instance
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessage(String userUid, String otherUserUid) {
    List<String> ids = [userUid, otherUserUid];
    ids.sort();
    String chatRoomId = ids.join("_");

    return FirebaseFirestore.instance
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
