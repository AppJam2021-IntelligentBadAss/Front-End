import 'package:backstage/pages/host_room.dart';
import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'model/data.dart' as data;
import 'model/room.dart';
//import 'pages/audience_page.dart';
import 'pages/audience_page_choose_room.dart';
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
      title: 'TANDA',
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
        //primarySwatch: Colors.blue,      

        //brightness and colors
        brightness: Brightness.dark,
        primaryColor: Colors.brown[800],
        accentColor: Colors.deepPurple[100],

        //font family
        fontFamily: 'RobotoMono',

        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        ),
      ),
      home: (debugWidget == null) ? MyHomePage(title: 'Tanda') : debugWidget,
    );
  }
}

List<StaggeredTile> _staggeredTiles = const <StaggeredTile>[
  const StaggeredTile.count(2, 2),
  const StaggeredTile.count(2, 1),
  const StaggeredTile.count(1, 2),
  const StaggeredTile.count(1, 1),
  const StaggeredTile.count(2, 2),
  const StaggeredTile.count(1, 2),
  const StaggeredTile.count(1, 1),
  const StaggeredTile.count(3, 1),
  const StaggeredTile.count(1, 1),
  const StaggeredTile.count(4, 1),
];

List<Widget> _tiles = const <Widget>[
  const _MyHomePageTile(Colors.green, Icons.widgets),
  const _MyHomePageTile(Colors.lightBlue, Icons.wifi),
  const _MyHomePageTile(Colors.amber, Icons.panorama_wide_angle),
  const _MyHomePageTile(Colors.brown, Icons.map),
  const _MyHomePageTile(Colors.deepOrange, Icons.send),
  const _MyHomePageTile(Colors.indigo, Icons.airline_seat_flat),
  const _MyHomePageTile(Colors.red, Icons.bluetooth),
  const _MyHomePageTile(Colors.pink, Icons.battery_alert),
  const _MyHomePageTile(Colors.purple, Icons.desktop_windows),
  const _MyHomePageTile(Colors.blue, Icons.radio),
];

class _MyHomePageTile extends StatelessWidget {
  const _MyHomePageTile(this.backgroundColor, this.iconData);

  final Color backgroundColor;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: backgroundColor,
      child: new InkWell(
        onTap: () {},
        child: new Center(
          child: new Padding(
            padding: const EdgeInsets.all(4.0),
            child: new Icon(
              iconData,
              color: Colors.white,
            ),
          ),
        ),
      ),
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
  final List<String> actors = <String>['Host', 'Audience Member', 'Find shows nearby'];

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
      /*body: ListView.builder(
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
          }),*/
      body: new Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: new StaggeredGridView.count(
                crossAxisCount: 4,
                staggeredTiles: _staggeredTiles,
                children: _tiles,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                padding: const EdgeInsets.all(4.0),
              )),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu'),
              decoration: BoxDecoration(
                color: Colors.deepPurple[100],
              ),
            ),
            Container(
              height: double.maxFinite,
              child: ListView.builder(
                itemCount: widget.actors.length,
                itemBuilder: (BuildContext context, int i) {
                  return ListTile(
                    title: Text(widget.actors[i]),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OpenPage(page: widget.actors[i])));
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
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
              final snackBar = SnackBar(
                content: Text('Request Sent!'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }),
      ),
    );
  }
}
