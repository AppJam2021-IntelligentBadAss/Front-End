import 'package:cloud_firestore/cloud_firestore.dart';

//typedef RoomPressedCallback = void Function(String roomId);

//typedef CloseRoomPressedCallback = void Function();

class Room {
  final String id;
  final String name;
  final int numAttendee;
  final DocumentReference reference;

  Room({this.name, this.numAttendee})
      : id = null,
        //numAttendee = 0,
        reference = null;

  Room.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        name = snapshot.data()['name'],
        numAttendee = snapshot.data()['numAttendee'],
        reference = snapshot.reference;
}
