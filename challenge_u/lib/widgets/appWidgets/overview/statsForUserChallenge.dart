import 'package:challenge_u/classes/userChallengeU.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../classes/goal.dart';
import 'goalWidget.dart';

class StatsForUserChallenge extends StatefulWidget {
  bool showStats;
  String challengeId;
  UserChallengeU user;
  StatsForUserChallenge(this.showStats, this.challengeId, this.user,
      {super.key});

  @override
  State<StatsForUserChallenge> createState() => _StatsForUserChallengeState();
}

class _StatsForUserChallengeState extends State<StatsForUserChallenge> {
  @override
  Widget build(BuildContext context) {
    return widget.showStats
        ? StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('challenges')
                .doc(widget.challengeId)
                .collection('participants')
                .doc(widget.user.id)
                .collection('goals')
                .snapshots()
                .map(
                  (snapshot) => snapshot.docs
                      .map(
                        (goal) => Goal.fromMap(goal.data()),
                      )
                      .toList(),
                ),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('something went wrong');
              }
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              List<Goal> goals = snapshot.data!;
              return Column(
                children: goals.map((goal) => GoalWidget(goal, false)).toList(),
              );
            },
          )
        : const SizedBox(
            height: 5,
          );
  }
}
