import 'package:cloud_firestore/cloud_firestore.dart';

class Sport {
  String name;
  String description;

  Sport(this.name, this.description);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
    };
  }

  static Sport fromMap(Map<String, dynamic> map) {
    return Sport(
      map['name'],
      map['description'],
    );
  }

  static Stream<List<Sport>> readSports() {
    return FirebaseFirestore.instance.collection('sports').snapshots().map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => Sport.fromMap(
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  void createSport() {
    FirebaseFirestore.instance.collection('sports').doc(name).set(toMap());
  }
}
