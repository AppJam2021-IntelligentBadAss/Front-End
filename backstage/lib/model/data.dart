import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import './room.dart';
import './message.dart';
import 'message.dart';

Future<void> addRoom({Room room}) {
  final rooms = FirebaseFirestore.instance.collection('rooms');
  return rooms.add({
    'name': room.name,
    'numAttendee': room.numAttendee,
    'numMessages': room.numMessages,
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

Future<Room> getRoom(String roomId) {
  return FirebaseFirestore.instance
      .collection('rooms')
      .doc(roomId)
      .get()
      .then((DocumentSnapshot doc) => Room.fromSnapshot(doc));
}

Future<void> addMessage({String roomId, Message message}) {
  final room =
      FirebaseFirestore.instance.collection('rooms').doc(roomId);
  final newMessage = room.collection('messages').doc();

  return FirebaseFirestore.instance.runTransaction((Transaction transaction) {
    return transaction
        .get(room)
        .then((DocumentSnapshot doc) => Room.fromSnapshot(doc))
        .then((Room fresh) {
          final numMessages = fresh.numMessages + 1;
          //final newAverage =
          //    ((fresh.numRatings * fresh.avgRating) + review.rating) / newRatings;

          transaction.update(room, {
            'numMessages': numMessages,
            //'avgRating': newAverage,
          });

          transaction.set(newMessage, {
            'message': message.message ?? "This is message #"+numMessages.toString(),
            'timestamp': message.timestamp ?? FieldValue.serverTimestamp(),
            'userName': message.userName,
            'userId': message.userId,
          });
        });
  });
}