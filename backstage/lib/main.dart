import 'package:backstage/pages/host_room.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'model/data.dart' as data;
import 'model/room.dart';
import 'pages/audience_page.dart';
import 'dart:async';
import 'pages/host_page.dart';

void main() async {
  await Firebase.initializeApp();
  runApp(MyApp(
      /*debugWidget: HostRoom(
      roomId: 'ggQsSaQRzT6SP9mIDcBw',
    ),*/
      ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  Widget debugWidget;

  MyApp({this.debugWidget = null});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home:
          (debugWidget == null) ? MyHomePage(title: 'Backstage') : debugWidget,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final List<String> actors = <String>['Host', 'Audience Member'];

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListView.builder(
          itemCount: widget.actors.length,
          itemBuilder: (BuildContext context, int i) {
            return ListTile(
              title: Text(widget.actors[i]),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            OpenPage(page: widget.actors[i])));
              },
            );
          }),
    );
  }
}

// This class simply to determine whether
// we are navigating to the host page or the audience page
class OpenPage extends StatelessWidget {
  final String page;

  //In this constructor we are requiring passing in the string name of
  //the page we want to navigate to
  OpenPage({Key key, @required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (page == 'Host') ? HostPage() : AudiencePage();
  }
}

//TODO: need to connect this roomButton to roomAudience
class RoomButton extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: Text('Send Request'),
          onPressed: () {
            print('Pressed');
          },
        ),
      ),
    );
  }
}
