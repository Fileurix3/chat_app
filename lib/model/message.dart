import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderUid;
  final String senderName;
  final String receiverUid;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderUid,
    required this.senderName,
    required this.receiverUid,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      "senderUid": senderUid,
      "senderName": senderName,
      "receiverUid": receiverUid,
      "message": message,
      "timestamp": timestamp,
    };
  }
}
