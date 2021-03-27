import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../model/data.dart' as data;
import '../model/room.dart';

import 'host_room.dart';
import 'dialogs/room_create.dart';

class HostPage extends StatefulWidget {
  @override
  _HostPageState createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {
  StreamSubscription<QuerySnapshot> _currentSubscription;
  bool _isLoading = true;
  String _userId;
  List<Room> _rooms = <Room>[];

  _HostPageState() {
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

  // ---- Hard coded rooms ----
  List<String> rooms = ["Room 1", "Room 2"];
  void _createRoom() {
    setState(() {
      rooms.add('Room ${rooms.length + 1}');
    });
  }

  Future<void> _onAddRoomPressed() async {
    final newRoom = await showDialog<Room>(
      context: context,
      builder: (_) => RoomCreateDialog(
        userId: _userId,
        //userName: _userName,
      ),
    );
    if (newRoom != null) {
      final snackBar = SnackBar(
            content: Text('Room added'),
          );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // Save the review
      return data.addRoom(
        room: newRoom,
      );
    }

    /*
    // legacy: hard coded
    final room = Room(
      name: "test room name",
      //numAttendee: 0,
    );
    data.addRoom(room);
    */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Host Page"),
      ),
      body: ListView.builder(
          //itemCount: rooms.length,
          itemCount: _rooms.length,
          itemBuilder: (BuildContext context, int i) {
            return ListTile(
              //title: Text(rooms[i]),
              title: Text(_rooms[i].name),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HostRoom(
                              roomId: _rooms[i].id,
                            )));
                //Navigator.pushNamed(context, HostRoom.route,
                //arguments: HostRoomArguments(id: _rooms[i].name));
              },
            );
          }),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 50.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        //onPressed: _createRoom,
        onPressed: _onAddRoomPressed,
        tooltip: 'Create Room',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .centerDocked, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
