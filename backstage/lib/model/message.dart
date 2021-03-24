import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String message;
  final String sentTo;
  final String sentBy;
  final String room;
  final DocumentReference reference;

  Message._({this.message, this.sentTo, this.sentBy, this.room})
      : id = null,
        reference = null;

  Message.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        message = snapshot.data()['message'],
        sentTo = snapshot.data()['sentTo'],
        sentBy = snapshot.data()['sentBy'],
        room = snapshot.data()['room'],
        reference = snapshot.reference;

  Message.fromUserInput({this.message, this.sentTo, this.sentBy, this.room})
      : id = null,
        reference = null;
}
