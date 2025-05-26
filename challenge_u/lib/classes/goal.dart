// The Goal class represents a datamodel to create a goal for one week.
// The goal has a sport and reps per das and pays per week to accomplish.

import 'package:challenge_u/classes/training.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:week_of_year/date_week_extensions.dart';

class Goal {
  String id;
  String sportName;
  String goalType;
  double count;
  double days;

  Goal(this.sportName, this.count, this.days, this.id, this.goalType);

  void createGoal() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('goals')
        .doc(id)
        .set(toMap());
  }

  void createGoalInChallenge(String challengeId) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('challenges')
        .doc(challengeId)
        .collection('participants')
        .doc(userId)
        .collection('goals')
        .doc(id)
        .set(toMap());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('goals')
        .doc(id)
        .collection('challengeIds')
        .doc(challengeId)
        .set({'challengeId': challengeId});
  }

  static void deleteGoal(String id) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('goals')
        .doc(id)
        .delete();
  }

  void deleteGoalFromChallenge(String challengeId) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('goals')
        .doc(id)
        .collection('challengeIds')
        .doc(challengeId)
        .delete();
  }

  static Stream<List<Goal>> readGoals() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('goals')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            Goal goal = Goal.fromMap(
              doc.data(),
            );
            return goal;
          }).toList(),
        );
  }

  static Future<List<Goal>> readParticipantGoals(String challgenId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return FirebaseFirestore.instance
        .collection('challenges')
        .doc(challgenId)
        .collection('participants')
        .doc(userId)
        .collection('goals')
        .get()
        .then((snapshot) {
      return snapshot.docs.map((goal) {
        return Goal.fromMap(goal.data());
      }).toList();
    });
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sportName': sportName,
      'count': count,
      'daysToDo': days,
      'goalType': goalType
    };
  }

  static Goal fromMap(Map<String, dynamic> map) {
    return Goal(
      map['sportName'],
      map['count'],
      map['daysToDo'],
      map['id'],
      map['goalType'],
    );
  }

  // method to update the number of days completed for a goal based on a list of training sessions
  int daysDone(List<Training> trainings) {
    Map<int, double> dayToRepetitions = {};
    int completedDays = 0;
    for (Training training in trainings) {
      if (training.date.weekOfYear == DateTime.now().weekOfYear) {
        // Check if the training session is relevant to the goal.
        // Check if the training session occurred on a day that has already been counted.
        if (training.sportName == sportName) {
          if (dayToRepetitions.containsKey(training.date.day)) {
            // If the day has already been counted, add the training session's repetitions to the count for that day.
            dayToRepetitions[training.date.day] =
                (dayToRepetitions[training.date.day]! +
                    getPerformanceOfGoaltype(training));
          } else {
            // If the day has not already been counted, add a new entry for the day.
            dayToRepetitions[training.date.day] =
                getPerformanceOfGoaltype(training);
          }
        }
      }
    }

    // Counts the numer of days on which the goal was achieved
    dayToRepetitions.forEach((key, value) {
      if (value >= count) {
        completedDays++;
      }
    });
    return completedDays;
  }

  double getPerformanceOfGoaltype(Training training) {
    switch (goalType) {
      case 'reps':
        return training.reps;
      case 'meters':
        return training.meters;
      case 'minutes':
        return training.minutes;
      case 'kilograms':
        return training.kilograms;
      default:
        return 0;
    }
  }
}
