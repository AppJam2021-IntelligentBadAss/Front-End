import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Backstage Demo',
      theme: ThemeData(
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
        onPressed: () {
          _createRoom();
          final snackBar = SnackBar(
            content: Text('Room added'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        tooltip: 'Create Room',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .centerDocked, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class AudiencePage extends StatefulWidget {
  @override
  _AudiencePageState createState() => _AudiencePageState();
}

class _AudiencePageState extends State<AudiencePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audience Page'),
      ),
      body: Center(
          child: ElevatedButton(
        child: Text('Join via QR'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AudienceRoom()),
          );
        },
      )),
    );
  }
}

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
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.all(8),
              ),
            ),
            TextButton(
              child: Text('Send Request'),
              onPressed: () {
                print('Pressed');
              },
            )
          ],
        ),
      ),
    );
  }
}

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

class MyHomePage extends StatelessWidget {
  final String title;
  final List<String> actors = <String>[
    'Host',
    'Audience Member',
    'Find shows nearby'
  ];

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: //Center(child: Text('Work in progress')),
          new Padding(
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
                itemCount: actors.length,
                itemBuilder: (BuildContext context, int i) {
                  return ListTile(
                    title: Text(actors[i]),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OpenPage(page: actors[i])));
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
