import 'dart:async';

import 'package:challenge_u/classes/participant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Challenge {
  List<Participant> participants = [];
  bool differentChallenges;
  DateTime startTime;
  String id;
  String name;
  int duration;

  Challenge(this.differentChallenges, this.startTime, this.id, this.name,
      this.duration);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startTime': startTime.toString(),
      'differentChallenges': differentChallenges,
      'name': name,
      'duration': duration,
    };
  }

  static Challenge fromMap(Map<String, dynamic> map) {
    return Challenge(
      map['differentChallenges'],
      DateTime.parse(map['startTime']),
      map['id'],
      map['name'],
      map['duration'],
    );
  }

  void createChallenge() {
    FirebaseFirestore.instance.collection('challenges').doc(id).set(toMap());
  }

  static Future<Challenge> readChallenge(String challengeId) async {
    Challenge challenge = await FirebaseFirestore.instance
        .collection('challenges')
        .doc(challengeId)
        .get()
        .then((value) {
      return Challenge.fromMap(value.data()!);
    });

    List<Participant> people = await readParticipants(challengeId).first;
    for (var user in people) {
      challenge.participants.add(user);
    }
    return challenge;
  }

  void quitChallenge() {
    FirebaseFirestore.instance.collection('challenges').doc(id).set(toMap());
  }

  static Stream<List<Participant>> readParticipants(String challengeId) {
    return FirebaseFirestore.instance
        .collection('challenges')
        .doc(challengeId)
        .collection('participants')
        .orderBy('weeksDone', descending: true)
        .orderBy('trainingsMissedPercent')
        .snapshots()
        .map(
          (participants) => participants.docs
              .map(
                (participant) => Participant.fromMap(
                  participant.data(),
                ),
              )
              .toList(),
        );
  }
}
