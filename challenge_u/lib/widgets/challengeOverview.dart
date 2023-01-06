import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:challenge_u/classes/challenge.dart';
import 'package:challenge_u/classes/training.dart';
import 'package:challenge_u/classes/goal.dart';
import 'package:flutter/material.dart';

import '../classes/sport.dart';

class ChallengeOverview extends StatefulWidget {
  List<Challenge> challenges;
  final Function removeChallenge;

  ChallengeOverview(this.challenges, this.removeChallenge);

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
          Row(
            children: widget.challenges.map((challenge) {
              return Flexible(
                fit: FlexFit.loose,
                flex: 1,
                child: Card(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: Text(
                              challenge.name,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Theme.of(context).errorColor,
                            ),
                            onPressed: () =>
                                widget.removeChallenge(challenge.id),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Column(
                        children: challenge.goals.map((ziel) {
                          return Column(children: [
                            Text(
                                "${Sport.bouldern.enumToString(ziel.sport)} ${ziel.tageGemacht.toStringAsFixed(0)}/${ziel.tageMuss.toStringAsFixed(0)}"),
                            Row(
                              children: [
                                Flexible(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    height: 10,
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                220, 220, 220, 1),
                                            border: Border.all(
                                                width: 1, color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        FractionallySizedBox(
                                          widthFactor: ziel.tageGemacht == 0
                                              ? 0.0
                                              : ziel.tageGemacht /
                                                  ziel.tageMuss,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Theme.of(context)
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
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
