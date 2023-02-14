import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:challenge_u/classes/challenge.dart';
import 'package:challenge_u/classes/training.dart';
import 'package:challenge_u/classes/goal.dart';

import '../../../classes/sport.dart';

class ChallengeOverview extends StatefulWidget {
  @override
  State<ChallengeOverview> createState() => _ChallengeoverviewState();
}

class _ChallengeoverviewState extends State<ChallengeOverview> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Container(
            child: Text("Deine Ziele für diese Woche"),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
          ),
          StreamBuilder<List<Challenge>>(
            stream: Challenge.readChallenges(),
            builder: ((context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }
              if (snapshot.hasData) {
                final challenges = snapshot.data!;
                return Row(
                  children: challenges.map((challenge) {
                    return Flexible(
                      fit: FlexFit.loose,
                      child: Card(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Text(
                                    challenge.name,
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                  onPressed: () =>
                                      Challenge.deleteChallenge(challenge.id),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            StreamBuilder<List<Goal>>(
                              stream: Goal.readGoals(challenge.id),
                              builder: ((context, snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Something went ach man');
                                }
                                if (snapshot.hasData) {
                                  final goals = snapshot.data!;
                                  return Column(
                                    children: goals.map((goal) {
                                      return Column(children: [
                                        Text(
                                            "${goal.sportName} ${goal.daysDone()}/${goal.days.toStringAsFixed(0)}"),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Flexible(
                                              fit: FlexFit.loose,
                                              child: Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 5,
                                                    horizontal: 10),
                                                height: 10,
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            220, 220, 220, 1),
                                                        border: Border.all(
                                                            width: 1,
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    FractionallySizedBox(
                                                      widthFactor: goal
                                                                  .daysDone() ==
                                                              0
                                                          ? 0.0
                                                          : goal.daysDone() /
                                                              goal.days,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .secondary),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]);
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
                        ),
                      ),
                    );
                  }).toList(),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
          )
        ],
      ),
    );
  }
}
