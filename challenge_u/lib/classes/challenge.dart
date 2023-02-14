// The Challenge class represents a datamodel to create a challenge from a list of goals.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../classes/goal.dart';
import '../classes/training.dart';

class Challenge {
  String name;
  String id;

  // constructor that takes the name and id as arguments and initializes the name and id properties
  Challenge(this.name, this.id);

  // method to add a goal to the list of goals for the challenge
  void linkGoal(Goal goal) {
    goal.challengeID = id;
  }

  void createChallenge() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('challenges')
        .doc(id)
        .set(toMap());
  }

  static Stream<List<Challenge>> readChallenges() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('challenges')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => Challenge.fromMap(
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  static void deleteChallenge(String id) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('challenges')
        .doc(id)
        .delete();
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
    };
  }

  static Challenge fromMap(Map<String, dynamic> map) {
    return Challenge(
      map['name'],
      map['id'],
    );
  }
}
