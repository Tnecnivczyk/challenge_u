import 'sport.dart';

class Goal {
  late String challengeID;
  String id;
  Sport sport;
  double wiederholungenMuss;
  double tageMuss;
  var tageGemacht;

  Goal(this.sport, this.wiederholungenMuss, this.tageMuss, this.id) {
    tageGemacht = 0;
    challengeID = '';
  }

  void setTageGemacht(int tage) {
    tageGemacht = tage;
  }

  // Other properties and methods

  Map<String, dynamic> toMap() {
    return {
      'sport': sport.enumToIndex(sport),
      'reps': wiederholungenMuss,
      'daysToDo': tageMuss,
    };
  }
}
