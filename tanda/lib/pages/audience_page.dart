import 'package:flutter/material.dart';
import 'audience_room.dart';

class AudiencePage extends StatefulWidget {
  @override
  _AudiencePageState createState() => _AudiencePageState();
}

class _AudiencePageState extends State<AudiencePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audience Page',
      home: _TextButton(),
      theme: ThemeData(
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(primary: Colors.blue))),
    );
  }
}

class _TextButton extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JOIN'),
      ),
      body: Center(
        child: TextButton(
          child: Text('Join via QR code'),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AudienceRoom(),
                ));
          },
        ),
      ),
    );
  }
}
