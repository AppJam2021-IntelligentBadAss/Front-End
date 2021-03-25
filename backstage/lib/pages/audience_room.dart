import 'package:flutter/material.dart';

class AudienceRoom extends StatefulWidget {
  @override
  _AudienceRoomState createState() => _AudienceRoomState();
}

class _AudienceRoomState extends State<AudienceRoom> {
  //text controller for use to retrieve the current value
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Room (Audience)'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                TextField(
                  onChanged: (text) {
                    print("Testing text field: $text");
                  },
                ),
                TextField(
                  controller: myController,
                ),
                TextButton(
                  child: Text('Send Request'),
                  onPressed: () {
                    setState(() {});
                  },
                ),
                Text(myController.text),
              ],
            )));
  }
}
