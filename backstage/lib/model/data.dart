import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import './room.dart';

Future<void> addRoom(Room room) {
  final rooms = FirebaseFirestore.instance.collection('rooms');
  return rooms.add({
    'name': room.name + " (" + Random().nextInt(100).toString() + ")",
    'numAttendee': room.numAttendee,
  });
}

Stream<QuerySnapshot> loadAllRooms() {
  return FirebaseFirestore.instance
      .collection('rooms')
      .orderBy('numAttendee', descending: true)
      .limit(50)
      .snapshots();
}

List<Room> getRoomsFromQuery(QuerySnapshot snapshot) {
  return snapshot.docs.map((DocumentSnapshot doc) {
    return Room.fromSnapshot(doc);
  }).toList();
}