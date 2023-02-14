import 'package:challenge_u/classes/participants.dart';

class MultiUserChallenge {
  List<Participants> participants = [];
  bool differentChallenges;
  DateTime startTime;
  String id;

  MultiUserChallenge(this.differentChallenges, this.startTime, this.id);
}
