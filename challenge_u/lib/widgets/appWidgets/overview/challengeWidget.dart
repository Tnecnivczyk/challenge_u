import 'package:challenge_u/widgets/appWidgets/overview/goalWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../classes/challenge.dart';
import '../../../classes/goal.dart';
import '../add/addFriendsBottomSheet.dart';
import 'inviteFriendsBottomSheet.dart';

class ChallengeWidget extends StatefulWidget {
  Challenge challenge;
  ChallengeWidget(this.challenge, {super.key});

  @override
  State<ChallengeWidget> createState() => _ChallengeWidgetState();
}

class _ChallengeWidgetState extends State<ChallengeWidget> {
  void _invitePeople() {
    Navigator.of(context).pop();
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return InviteFriendsBottomSheet(widget.challenge);
        });
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return InviteFriendsBottomSheet(widget.challenge);
        });
  }

  void _quit() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    List<Goal> goals = await FirebaseFirestore.instance
        .collection('challenges')
        .doc(widget.challenge.id)
        .collection('participants')
        .doc(userId)
        .collection('goals')
        .get()
        .then((snapshot) {
      return snapshot.docs.map((goal) {
        return Goal.fromMap(goal.data());
      }).toList();
    });

    for (Goal goal in goals) {
      await FirebaseFirestore.instance
          .collection('challenges')
          .doc(widget.challenge.id)
          .collection('participants')
          .doc(userId)
          .collection('goals')
          .doc(goal.id)
          .delete();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('goals')
          .doc(goal.id)
          .collection('challengeIds')
          .doc(widget.challenge.id)
          .delete();
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('challenges')
        .doc(widget.challenge.id)
        .delete();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(
                left: 7,
              ),
              child: Text(
                widget.challenge.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            PopupMenuButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        onTap: _invitePeople,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Invite Friends'),
                            Icon(Icons.mail_outline),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: _quit,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Quit'),
                            Icon(Icons.directions_walk),
                          ],
                        ),
                      ),
                    ])
          ],
        ),
        FutureBuilder<List<Goal>>(
          future: Goal.readParticipantGoals(widget.challenge.id),
          builder: ((context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went ach man');
            }
            if (snapshot.hasData) {
              final goals = snapshot.data!;

              return Column(
                children: goals.map((goal) {
                  return GoalWidget(goal, false);
                }).toList(),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
        ),
      ],
    );
  }
}
