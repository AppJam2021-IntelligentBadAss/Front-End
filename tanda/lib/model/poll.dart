import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class Poll {
  final String id;
  final String question;
  //final Timestamp timestamp;
  final List<Option> options;
  
  final DocumentReference reference;

  Poll({this.question, this.options})
      : id = null,
        reference = null;

  Poll.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        question = snapshot.data()['question'],
        options = snapshot.data()['pollOptions'],
        
        reference = snapshot.reference;

  Poll.fromUserInput({this.question, this.options})
      : id = null,
        reference = null;

  factory Poll.random() {
    final rating = Random().nextInt(4) + 1;
    final mes = "test"+rating.toString();
    return Poll.fromUserInput(
        question: mes,
        options: []//[Option.random(), Option.random()]
        );
  }
}

class Option {
  final String id;
  final String option;
  final List<dynamic> userIdsVoted;
  final int voteCount;

  final DocumentReference reference;

  Option({this.option, this.userIdsVoted, this.voteCount})
      : id = null,
        reference = null;

  Option.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        option = snapshot.data()['option'],
        userIdsVoted = snapshot.data()['userIdsVoted'],
        voteCount = snapshot.data()['voteCount'],

        reference = snapshot.reference;

  Option.fromUserInput({this.option, this.userIdsVoted, this.voteCount})
      : id = null,
        reference = null;

  factory Option.random() {
    final rating = Random().nextInt(4) + 1;
    final mes = "test"+rating.toString();
    return Option.fromUserInput(
        option: mes,
        userIdsVoted: [],
        voteCount: 0
        );
  }
}
