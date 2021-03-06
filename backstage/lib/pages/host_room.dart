import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rubber/rubber.dart';

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

class _HostRoomState extends State<HostRoom>
    with SingleTickerProviderStateMixin {
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
            //_userName = 'Anonymous (${kIsWeb ? "Web" : "Mobile"})';
            _userName =
                'Anonymous (${userCredential.user.uid.substring(0, 4)})';
          } else {
            _userName = userCredential.user.displayName;
          }
          _room = room;
          _userId = userCredential.user.uid;
          _roomName = room.name;

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
  void initState() {
    _controller = RubberAnimationController(
      vsync: this,
      dismissable: true,
      lowerBoundValue: AnimationControllerValue(pixel: 450),
      upperBoundValue: AnimationControllerValue(pixel: 450),
      //halfBoundValue: AnimationControllerValue(percentage: 0.8),
      duration: Duration(milliseconds: 200),
    );
    super.initState();
  }

  @override
  void dispose() {
    _currentMessageSubscription?.cancel();
    super.dispose();
  }

  // Used for rubber. The bottom navigation component
  Widget _getMenuLayer() {
    return Container(
      height: 80,
      decoration: BoxDecoration(color: Colors.blue),
    );
  }

  bool _isLoading = true;
  StreamSubscription<QuerySnapshot> _currentMessageSubscription;

  String _roomId;
  String _roomName;
  Room _room;
  String _userId;
  String _userName;
  List<Message> _messages = <Message>[];
  RubberAnimationController _controller;
  ScrollController _scrollController = ScrollController();
  final _userTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Room: $_roomName"),
        ),
        body: Container(
            child: RubberBottomSheet(
          lowerLayer: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Container(
              //  margin: const EdgeInsets.only(right: 16.0),
              //  child: CircleAvatar(child: Text("_name[0]")),
              //),
              //Text("_name", style: Theme.of(context).textTheme.headline4),
              TextField(
                controller: _userTextController,
                decoration: InputDecoration.collapsed(
                    hintText: 'Write down your message here...'),
              ),
              TextButton(
                child: Text('Send Request'),
                onPressed: () {
                  print('Pressed');
                  if (_userTextController.text.isNotEmpty) {
                    data.addMessage(
                        roomId: _roomId,
                        message: Message.fromUserInput(
                            message: _userTextController.text,
                            userId: _userId,
                            userName: _userName));
                    _userTextController.clear();
                  }
                },
              ),
            ],
          ), // The underlying page (Widget)
          upperLayer: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int i) {
                return ListTile(
                  title:
                      Text("${_messages[i].userName}: ${_messages[i].message}"),
                );
              }), // The bottomsheet content (Widget)
          //menuLayer: _getMenuLayer(),
          animationController: _controller, // The one we created earlier
        )) //Row(
        //Padding(
        //padding: const EdgeInsets.all(8.0),

        //children: [
        //],
        //),
        );
  }
}

class HostRoomArguments {
  final String id;

  HostRoomArguments({@required this.id});
}
