import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class Performer {
  final String id;
  final String name;
  final String city;
  final DocumentReference reference;

  Performer._({this.name, this.city})
      : id = null,
        reference = null;

  Performer.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        name = snapshot.data()['name'],
        city = snapshot.data()['city'],
        reference = snapshot.reference;

  factory Performer.default_performer() {
    return Performer._(
      name: 'Wu-Tang',
      city: 'New York',
    );
  }
}
