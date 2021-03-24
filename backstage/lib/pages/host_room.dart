import 'package:flutter/material.dart';

class HostRoom extends StatefulWidget {
  @override
  _HostRoomState createState() => _HostRoomState();
}

class _HostRoomState extends State<HostRoom> {
  List<String> audienceRequests = [
    'Play this song',
    'Play that song',
    'Can you give a shout out to me please',
    'What time are you done?'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Host Page"),
      ),
      body: ListView.builder(
          itemCount: audienceRequests.length,
          itemBuilder: (BuildContext context, int i) {
            return ListTile(
              title: Text(audienceRequests[i]),
            );
          }),
    );
  }
}
