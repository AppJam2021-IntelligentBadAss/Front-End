import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rubber/rubber.dart';
import 'package:tanda/model/performer.dart';

import '../model/data.dart' as data;
import '../model/message.dart';
import '../model/room.dart';
import '../model/poll.dart';

import 'package:polls/polls.dart';

class HostRoom extends StatefulWidget {
  static const route = '/room';
  final String _roomId;
  final Performer _performer;

  HostRoom({Key key, @required String roomId, Performer performer})
      : _roomId = roomId,
        _performer = performer,
        super(key: key);

  @override
  _HostRoomState createState() =>
      _HostRoomState(roomId: _roomId, performer: _performer);
}

class _HostRoomState extends State<HostRoom>
    with SingleTickerProviderStateMixin {
  _HostRoomState({@required String roomId, Performer performer}) {
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
          _userName =
              (performer != null) ? performer.name + '(Host)' : _userName;

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

          // Initialize the polls snapshot...
          _currentMessageSubscription = _room.reference
              .collection('polls')
              //.orderBy('voteCount', descending: false)
              .snapshots()
              .listen((QuerySnapshot pollSnap) {
            setState(() {
              //_isLoading = false;
              _polls = pollSnap.docs.map((DocumentSnapshot doc) {
                return Poll.fromSnapshot(doc);
              }).toList();
              print("_polls length: ${_polls.length}");
              if (_polls.length > 0) print("_polls id: ${_polls[0].id}");
            });

            if (_polls.length > 0) {
              // Initialize the options snapshot...
              _currentMessageSubscription = _room.reference
                  .collection('polls')
                  .doc(_polls[0].id)
                  .collection('pollOptions')
                  //.orderBy('voteCount', descending: false)
                  .snapshots()
                  .listen((QuerySnapshot optionSnap) {
                setState(() {
                  //_isLoading = false;
                  _options = optionSnap.docs.map((DocumentSnapshot doc) {
                    return Option.fromSnapshot(doc);
                  }).toList();
                  print("_options: ${_options.length}");
                  //print("_options: ${_options[0].option}");
                  var _optionArray = [];
                  _options.forEach((element) {
                    _optionArray.add(Polls.options(
                        title: element.option,
                        value: element.voteCount.toDouble()));
                  });

                  for (var element in _options) {
                    if (element.userIdsVoted.contains(_userId)) {
                      hasVoted = true;
                      votedOptionId = element.id;
                      print("You have voted $votedOptionId");
                      break;
                    }
                  }

                  poll = Polls(
                    children: _optionArray,
                    //question: Text('how old are you?'),
                    question: Text(_polls[0].question),
                    currentUser: this.user,
                    creatorID: this.creator,
                    voteData: usersWhoVoted,
                    userChoice: usersWhoVoted[this.user],
                    onVoteBackgroundColor: Colors.blue,
                    leadingBackgroundColor: Colors.blue,
                    backgroundColor: Colors.grey,
                    onVote: (choice) {
                      print(choice);
                      print("Option chosen: " +
                          _options[choice - 1].option +
                          " (" +
                          _options[choice - 1].id +
                          ")");
                      print("userId: " + _userId);
                      String _optionId = _options[choice - 1].id;
                      data.castVote(
                          roomId: _room.id,
                          pollId: _polls[0].id,
                          optionId: _optionId,
                          userId: _userId,
                          castFlag: true);
                      setState(() {
                        this.usersWhoVoted[this.user] = choice;
                        poll.children[choice - 1][1] += 1;
                        this.hasVoted = true;
                      });
                    },
                  );
                });
              });
            } // if
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
      lowerBoundValue: AnimationControllerValue(pixel: 350),
      upperBoundValue: AnimationControllerValue(pixel: 350),
      //halfBoundValue: AnimationControllerValue(percentage: 0.8),
      duration: Duration(milliseconds: 200),
    );

    // poll stuff
    // This cannot be less than 2, else will throw an exception
    options.forEach((key, value) {
      optionArray.add(Polls.options(title: key, value: value.toDouble()));
    });
    // --------

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
  List<Poll> _polls = <Poll>[];
  List<Option> _options = <Option>[];
  RubberAnimationController _controller;
  ScrollController _scrollController = ScrollController();
  final _userTextController = TextEditingController();

  // poll stuff
  var options = {'a': 2, 'b': 0, 'c': 2, 'd': 3};
  var optionArray = [];
  Polls poll, poll2;
  bool hasVoted = false;
  String votedOptionId;

  String user = "king";
  Map usersWhoVoted = {}; //{'sam': 3, 'mike' : 4, 'john' : 1, 'kenny' : 1};
  String creator = "eddy";
  // ------------

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
                  /*data.addPollOption(
                    roomId: _roomId,
                    pollId: "vKbhOQi6RZ5oC3SRjDeq",
                    option: Option.random()
                  );*/
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
              // poll stuff
              if (!hasVoted && poll != null)
                poll = Polls.castVote(
                  children: poll.children,
                  question: poll.question,
                  onVote: poll.onVote,
                ),
              if (hasVoted)
                poll2 = Polls.viewPolls(
                  children: poll.children,
                  question: poll.question,
                  userChoice: usersWhoVoted[this.user],
                ),
              if (hasVoted)
                TextButton(
                  child: Text('Undo the vote'),
                  onPressed: () {
                    print('Pressed');
                    data.castVote(
                        roomId: _room.id,
                        pollId: _polls[0].id,
                        optionId: votedOptionId,
                        userId: _userId,
                        castFlag: false);
                    setState(() {
                      hasVoted = false;
                    });
                  },
                ),
              // ------------
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
