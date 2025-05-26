import 'package:challenge_u/classes/challenge.dart';
import 'package:challenge_u/classes/participant.dart';
import 'package:challenge_u/classes/userChallengeU.dart';
import 'package:challenge_u/widgets/appWidgets/overview/rankingListTile.dart';
import 'package:flutter/material.dart';

class ChallegngeRanking extends StatefulWidget {
  String challengeId;
  ChallegngeRanking(this.challengeId, {super.key});

  @override
  State<ChallegngeRanking> createState() => _ChallegngeRankingState();
}

class _ChallegngeRankingState extends State<ChallegngeRanking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Challenge Ranking"),
      ),
      body: StreamBuilder<List<Participant>>(
        stream: Challenge.readParticipants(widget.challengeId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('something went wrong wiht the participants');
          }
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          var participants = snapshot.data!;

          return ListView.builder(
              itemCount: participants.length,
              itemBuilder: (context, index) {
                var participant = participants[index];
                return FutureBuilder(
                    future: UserChallengeU.userData(participant.userId),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('something went wrong with userdata${participant.userId}');
                      }
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }
                      String pictureURL = snapshot.data!.keys.first;
                      UserChallengeU user = snapshot.data!.values.first;
                      bool showStats = false;

                      return RankingListTile(
                          pictureURL,
                          user,
                          participants.indexOf(participant) + 1,
                          widget.challengeId);
                    });
              });
        },
      ),
    );
  }
}
