import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../model/data.dart' as data;
import '../model/message.dart';
import '../model/room.dart';

class HostRoom extends StatefulWidget {
  static const route = '/room';
  final String _roomId;

  HostRoom({Key key, @required String roomId})
      : _roomId = roomId,
        super(key: key);

  @override
  _HostRoomState createState() => _HostRoomState(roomId: _roomId);
}

class _HostRoomState extends State<HostRoom> {
  _HostRoomState({@required String roomId}) {
    _roomId = roomId;
    FirebaseAuth.instance
        .signInAnonymously()
        .then((UserCredential userCredential) {
      data.getRoom(roomId).then((Room room) {
        _currentMessageSubscription?.cancel();
        setState(() {
          if (userCredential.user.displayName == null ||
              userCredential.user.displayName.isEmpty) {
            _userName = 'Anonymous (${kIsWeb ? "Web" : "Mobile"})';
          } else {
            _userName = userCredential.user.displayName;
          }
          _room = room;
          _userId = userCredential.user.uid;

          // Initialize the messages snapshot...
          _currentMessageSubscription = _room.reference
              .collection('messages')
              .orderBy('timestamp', descending: false)
              .snapshots()
              .listen((QuerySnapshot messageSnap) {
            setState(() {
              _isLoading = false;
              _messages = messageSnap.docs.map((DocumentSnapshot doc) {
                return Message.fromSnapshot(doc);
              }).toList();
              print("_messages: ${_messages.length}");
            });
          });
        });
      });
    });
  }

  @override
  void dispose() {
    _currentMessageSubscription?.cancel();
    super.dispose();
  }

  bool _isLoading = true;
  StreamSubscription<QuerySnapshot> _currentMessageSubscription;

  String _roomId;
  Room _room;
  String _userId;
  String _userName;
  List<Message> _messages = <Message>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Host Room $_roomId"),
        ),
        body: Row(
          //Padding(
          //padding: const EdgeInsets.all(8.0),

          children: [
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: Text("_name[0]")),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("_name", style: Theme.of(context).textTheme.headline4),
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                  child: Text("text"),
                ),
              ],
            ),
            /*ListView.builder(
            itemCount: audienceRequests.length,
            itemBuilder: (BuildContext context, int i) {
              return ListTile(
                title: Text(audienceRequests[i]),
              );
            }),*/
            TextButton(
              child: Text('Send Request'),
              onPressed: () {
                print('Pressed');
                data.addMessage(roomId: _roomId, message: Message.random());
              },
            ),
          ],
        ));
  }
}

class HostRoomArguments {
  final String id;

  HostRoomArguments({@required this.id});
}
