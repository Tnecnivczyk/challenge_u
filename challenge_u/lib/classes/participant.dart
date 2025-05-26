import 'challenge.dart';

class Participant {
  int weeksDone = 0;
  int trainingsMissedPercent = 0;
  String userId;
  String username;
  int weeksAsParticipant;
  late Challenge challenge;

  Participant(this.userId, this.trainingsMissedPercent, this.weeksDone,
      this.username, this.weeksAsParticipant);

  void _setChallenge(Challenge challenge) {
    this.challenge = challenge;
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'weeksDone': weeksDone,
      'trainingsMissedPercent': trainingsMissedPercent,
      'username': username,
      'weeksAsParticipant': weeksAsParticipant,
    };
  }

  static Participant fromMap(Map<String, dynamic> map) {
    return Participant(map['userId'], map['trainingsMissedPercent'],
        map['weeksDone'], map['username'], map['weeksAsParticipant']);
  }
}
