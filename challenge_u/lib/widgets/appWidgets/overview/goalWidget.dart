import 'dart:io';

import 'package:challenge_u/classes/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:week_of_year/date_week_extensions.dart';

import '../../../classes/goal.dart';
import '../../../classes/training.dart';

class GoalWidget extends StatefulWidget {
  bool editeble;
  Goal goal;

  GoalWidget(this.goal, this.editeble, {super.key});

  @override
  State<GoalWidget> createState() => _GoalWidgetState();
}

class _GoalWidgetState extends State<GoalWidget> {
  Stream<List<Training>> readTrainings(goal) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('trainings')
        .where('sportName', isEqualTo: goal.sportName)
        .snapshots()
        .map(
          (trainings) => trainings.docs
              .map(
                (training) => Training.fromMap(
                  training.data(),
                ),
              )
              .toList(),
        );
  }

  void _deleteGoal() async {
    bool isGoalInChallenges = false;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('goals')
        .doc(widget.goal.id)
        .collection('challengeIds')
        .get()
        .then((value) {
      value.docs.forEach((challenge) {
        isGoalInChallenges = true;
      });
    });
    if (!isGoalInChallenges) {
      Goal.deleteGoal(widget.goal.id);
    } else {
      Utils.showErrorSnackBar(
          'You need the goal for a challenge.\nQuit the challenge first to delete the goal',
          context);
    }
  }

  void _editGoal() {}
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: readTrainings(widget.goal),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('something went wrong');
        }
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        List<Training> trainings = snapshot.data!;
        int daysDone = widget.goal.daysDone(trainings);
        return Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  left: 7,
                ),
                child: Row(
                  children: [
                    Text(
                      " ${widget.goal.sportName}: ${widget.goal.daysDone(trainings)} / ${widget.goal.days.toStringAsFixed(0)}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      " x ${widget.goal.count} ${widget.goal.goalType}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              widget.editeble
                  ? IconButton(
                      onPressed: () {
                        final RenderBox button =
                            context.findRenderObject() as RenderBox;
                        showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(
                            button.localToGlobal(Offset.zero).dx +
                                MediaQuery.of(context).size.width,
                            button.localToGlobal(Offset.zero).dy,
                            button.localToGlobal(Offset.zero).dx,
                            button.localToGlobal(Offset.zero).dy,
                          ),
                          // Position des Menüs
                          items: <PopupMenuEntry>[
                            PopupMenuItem(
                              onTap: _deleteGoal,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('delete'),
                                  Icon(Icons.delete),
                                ],
                              ),
                            ),
                          ],
                        ).then((value) {
                          // Aktion, wenn eine Option ausgewählt wurde
                          setState(() {});
                        });
                      },
                      icon: Icon(
                        Icons.more_horiz,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    )
                  : SizedBox(
                      height: 35,
                    ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  height: 10,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(220, 220, 220, 1),
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: daysDone == 0
                            ? 0.0
                            : daysDone > widget.goal.days
                                ? 1.0
                                : widget.goal.daysDone(trainings) /
                                    widget.goal.days,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ]);
      },
    );
  }
}
