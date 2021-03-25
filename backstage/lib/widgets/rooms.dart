import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../model/data.dart' as data;
import '../model/room.dart';

class Rooms extends StatefulWidget {
  @override
  _RoomsState createState() => _RoomsState();

  void addRoom(){
    this.
  }
}

class _RoomsState extends State<Rooms> {
  StreamSubscription<QuerySnapshot> _currentSubscription;
  bool _isLoading = true;
  List<Room> _rooms = <Room>[];

  _RoomsState() {
    FirebaseAuth.instance
        .signInAnonymously()
        .then((UserCredential userCredential) {
      _currentSubscription = data.loadAllRooms().listen(_updateRooms);
    });
  }

    void _updateRooms(QuerySnapshot snapshot) {
    setState(() {
      _isLoading = false;
      _rooms = data.getRoomsFromQuery(snapshot);
    });
  }

  Future<void> _onAddRoomPressed() async {
    final room = Room(
      name: "test room name",
      numAttendee: 0,
    );
    data.addRoom(room);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
          //itemCount: rooms.length,
          itemCount: _rooms.length,
          itemBuilder: (BuildContext context, int i) {
            return ListTile(
              //title: Text(rooms[i]),
              title: Text(_rooms[i].name),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HostRoom()));
              },
            );
          })
  }
}
