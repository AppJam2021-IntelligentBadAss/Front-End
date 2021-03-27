import 'package:cloud_firestore/cloud_firestore.dart';

//typedef RoomPressedCallback = void Function(String roomId);

//typedef CloseRoomPressedCallback = void Function();

class Room {
  final String id;
  final String name;
  final String userId;
  final int numAttendee;
  final int numMessages;
  final DocumentReference reference;

  Room({this.name, this.userId})
      : id = null,
        numMessages = 0,
        numAttendee = 0,
        reference = null;

  Room.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        name = snapshot.data()['name'],
        userId = snapshot.data()['userId'],
        numAttendee = snapshot.data()['numAttendee'],
        numMessages = snapshot.data()['numMessages'],
        reference = snapshot.reference;

  Room.fromUserInput({this.name, this.userId})
      : id = null,
        numMessages=0,
        numAttendee=0,
        reference = null;
}
