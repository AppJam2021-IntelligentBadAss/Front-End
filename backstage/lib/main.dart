import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
      home: MyHomePage(title: 'Backstage'),
    );
  }
}

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

class HostPage extends StatefulWidget {
  @override
  _HostPageState createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {
  List<String> rooms = ["Room 1", "Room 2"];

  void _createRoom() {
    setState(() {
      rooms.add('Room ${rooms.length + 1}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Host Page"),
      ),
      body: ListView.builder(
          itemCount: rooms.length,
          itemBuilder: (BuildContext context, int i) {
            return ListTile(
              title: Text(rooms[i]),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HostRoom()));
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
        onPressed: _createRoom,
        tooltip: 'Create Room',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .centerDocked, // This trailing comma makes auto-formatting nicer for build methods.
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
            print('Pressed');
          },
        ),
      ),
    );
  }
}
