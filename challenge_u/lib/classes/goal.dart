// The Goal class represents a datamodel to create a goal for one week.
// The goal has a sport and reps per das and pays per week to accomplish.

import 'package:challenge_u/classes/training.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:week_of_year/date_week_extensions.dart';

class Goal {
  String challengeID = '';
  String id;
  String sportName;
  double reps;
  double days;

  Goal(this.sportName, this.reps, this.days, this.id);

  void createGoal() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('challenges')
        .doc(challengeID)
        .collection('goals')
        .doc(id)
        .set(toMap());
  }

  static Stream<List<Goal>> readGoals(String challengeID) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('challenges')
        .doc(challengeID)
        .collection('goals')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => Goal.fromMap(
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  static void deleteGoal(String id, String challengeID) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('challenges')
        .doc(challengeID)
        .collection('goals')
        .doc(id)
        .delete();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'challengeId': challengeID,
      'sportName': sportName,
      'reps': reps,
      'daysToDo': days,
    };
  }

  static Goal fromMap(Map<String, dynamic> map) {
    var goal = Goal(
      map['sportName'],
      map['reps'],
      map['daysToDo'],
      map['id'],
    );
    goal.challengeID = map['challengeId'];
    return goal;
  }

  // method to update the number of days completed for a goal based on a list of training sessions
  int daysDone() {
    Stream<List<Training>> currentTrainings = Training.readTrainings();
    Map<int, double> dayToRepetitions = {};
    int completedDays = 0;
    currentTrainings.forEach((trainings) {
      for (Training training in trainings) {
        if (training.date.weekOfYear == DateTime.now().weekOfYear) {
          // Check if the training session is relevant to the goal.
          // Check if the training session occurred on a day that has already been counted.
          if (training.sportName == sportName) {
            if (dayToRepetitions.containsKey(training.date.day)) {
              // If the day has already been counted, add the training session's repetitions to the count for that day.
              dayToRepetitions[training.date.day] =
                  (dayToRepetitions[training.date.day]! + training.reps);
            } else {
              // If the day has not already been counted, add a new entry for the day.
              dayToRepetitions[training.date.day] = training.reps;
            }
          }
        }
      }
    });
    // Counts the numer of days on which the goal was achieved
    dayToRepetitions.forEach((key, value) {
      if (value >= reps) {
        completedDays++;
      }
    });
    return completedDays;
  }
}
