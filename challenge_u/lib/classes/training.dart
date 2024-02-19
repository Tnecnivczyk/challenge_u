import 'package:challenge_u/classes/sport.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Training {
  String sportName;
  double reps;
  double meters;
  double minutes;
  double kilograms;
  DateTime date;
  String id;

  Training(this.sportName, this.reps, this.meters, this.minutes, this.kilograms,
      this.date, this.id);

  // Adds a new training and updates the challenges accordingly.
  void createTraining() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('trainings')
        .doc(id)
        .set(toMap());
  }

  static Stream<List<Training>> readTrainings() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('trainings')
        .orderBy("date")
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.reversed
              .map(
                (doc) => Training.fromMap(
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  void deleteTraining() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('trainings')
        .doc(id)
        .delete();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toString(),
      'sportName': sportName,
      'reps': reps,
      'meters': meters,
      'minutes': minutes,
      'kilograms': kilograms,
    };
  }

  static Training fromMap(Map<String, dynamic> map) {
    return Training(
      map['sportName'],
      map['reps'],
      map['meters'],
      map['minutes'],
      map['kilograms'],
      DateTime.parse(map['date']),
      map['id'],
    );
  }
}
