import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../model/room.dart';

class RoomCreateDialog extends StatefulWidget {
  final String userName;
  final String userId;

  RoomCreateDialog({this.userName, this.userId, Key key});

  @override
  _RoomCreateDialogState createState() => _RoomCreateDialogState();
}

class _RoomCreateDialogState extends State<RoomCreateDialog> {
  //double rating = 0;
  String roomName;

  @override
  Widget build(BuildContext context) {
    //Color color = rating == 0 ? Colors.grey : Colors.amber;
    return AlertDialog(
      title: Text('Add a Room'),
      content: Container(
        width: math.min(MediaQuery.of(context).size.width, 740),
        height: math.min(MediaQuery.of(context).size.height, 180),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration.collapsed(
                    hintText: 'room name'),
                keyboardType: TextInputType.name,
                maxLines: null,
                onChanged: (value) {
                  print("room name: " + value);
                  if (mounted) {
                    setState(() {
                      roomName = value;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: () => Navigator.pop(context, null),
        ),
        RaisedButton(
          child: Text('SAVE'),
          onPressed: () => Navigator.pop(
            context,
            Room.fromUserInput(
              name: roomName,
              userId: widget.userId,
              //userName: widget.userName,
            ),
          ),
        ),
      ],
    );
  }
}