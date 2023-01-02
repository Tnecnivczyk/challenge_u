import 'dart:ui';

import 'package:challenge_u/klassen/challenge.dart';
import 'package:challenge_u/klassen/training.dart';
import 'package:challenge_u/klassen/ziel.dart';
import 'package:flutter/material.dart';

import '../klassen/sportart.dart';

class ChallengeUebersicht extends StatelessWidget {
  List<Challenge> challenges;

  ChallengeUebersicht(this.challenges, {super.key});

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
            children: challenges.map((challenge) {
              return Flexible(
                fit: FlexFit.loose,
                flex: 1,
                child: Card(
                  child: Column(
                    children: [
                      Text(
                        challenge.name,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Column(
                        children: challenge.ziele.map((ziel) {
                          return Column(children: [
                            Text(
                                "${Sportart.bouldern.asString(ziel.sportart)} ${ziel.tageGemacht}/${ziel.tageMuss}"),
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
