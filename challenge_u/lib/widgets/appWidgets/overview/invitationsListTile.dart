import 'package:challenge_u/classes/invitation.dart';
import 'package:challenge_u/classes/userChallengeU.dart';
import 'package:challenge_u/widgets/appWidgets/overview/statsForUserChallenge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../classes/challenge.dart';
import '../../../classes/goal.dart';
import '../profile/profile.dart';
import 'challengeRanking.dart';
import 'chooseGoalsToJoin.dart';

class InvitationsListTile extends StatefulWidget {
  UserChallengeU author;
  Challenge challenge;
  Function _openChallengeRanking;
  InvitationsListTile(this.author, this.challenge, this._openChallengeRanking,
      {super.key});

  @override
  State<InvitationsListTile> createState() => _InvitationsListTileState();
}

class _InvitationsListTileState extends State<InvitationsListTile> {
  bool showGoals = false;

  void _openProfile(BuildContext context, String userId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return Profile(userId, false);
        },
      ),
    );
  }

  void _openChooseGoalsToJoin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return ChooseGoalsToJoinSheet(widget.challenge, widget.author.id);
        },
      ),
    );
  }

  void _joinChallenge() async {
    UserChallengeU.joinChallenge(widget.challenge.id);
    List<Goal> goals = await FirebaseFirestore.instance
        .collection('challenges')
        .doc(widget.challenge.id)
        .collection('participants')
        .doc(widget.author.id)
        .collection('goals')
        .snapshots()
        .first
        .then(
          (snapshot) => snapshot.docs
              .map(
                (goal) => Goal.fromMap(goal.data()),
              )
              .toList(),
        );
    for (Goal goal in goals) {
      goal.createGoal();
      goal.createGoalInChallenge(widget.challenge.id);
    }
    Invitation.deleteInvitation(widget.author.id, widget.challenge.id);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () => _openProfile(context, widget.author.id),
              text: "${widget.author.username}\n",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextSpan(
              text: "has invited you to the ",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            TextSpan(
              text: widget.challenge.name,
              style: Theme.of(context).textTheme.titleSmall,
              recognizer: TapGestureRecognizer()
                ..onTap = () =>
                    widget._openChallengeRanking(context, widget.challenge.id),
            ),
            TextSpan(
              text: " challenge!",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (widget.challenge.differentChallenges)
              TextSpan(
                text:
                    '\nEveryone competes with their own goals at this challenge',
                style: Theme.of(context).textTheme.bodySmall,
              )
            else
              TextSpan(
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => setState(() {
                            showGoals = !showGoals;
                          }),
                    text: '\nWatch here',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  TextSpan(
                      text: ' goals for the challenge',
                      style: Theme.of(context).textTheme.bodySmall)
                ],
              ),
          ],
        ),
      ),
      subtitle:
          StatsForUserChallenge(showGoals, widget.challenge.id, widget.author),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          widget.challenge.differentChallenges
              ? SizedBox(
                  height: 35,
                  width: 75,
                  child: OutlinedButton(
                    onPressed: () => _openChooseGoalsToJoin(),
                    child: Center(
                        child: Text(
                      'choose goals',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    )),
                  ),
                )
              : SizedBox(
                  height: 35,
                  width: 75,
                  child: OutlinedButton(
                    onPressed: () => _joinChallenge(),
                    child: Center(
                        child: Text(
                      'Accept',
                      style: Theme.of(context).textTheme.bodySmall,
                    )),
                  ),
                ),
          IconButton(
              onPressed: () => Invitation.deleteInvitation(
                  widget.author.id, widget.challenge.id),
              icon: Center(child: Icon(Icons.close))),
        ],
      ),
    );
  }
}
