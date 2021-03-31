import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String message;
  final Timestamp timestamp;
  final String userId;
  final String userName;
  final DocumentReference reference;

  Message({this.message, this.timestamp, this.userId, this.userName})
      : id = null,
        reference = null;

  Message.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        message = snapshot.data()['message'],
        timestamp = snapshot.data()['timestamp'],
        userId = snapshot.data()['userId'],
        userName = snapshot.data()['userName'],
        reference = snapshot.reference;

  Message.fromUserInput({this.message, this.userId, this.userName})
      : id = null,
        timestamp = null,
        reference = null;

  factory Message.random({String userName, String userId}) {
    final rating = Random().nextInt(4) + 1;
    final mes = "test"+rating.toString();
    return Message.fromUserInput(
        message: mes,
        userName: userName,
        userId: userId);
  }
}
