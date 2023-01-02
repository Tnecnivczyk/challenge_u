import 'package:flutter/material.dart';

import '../klassen/challenge.dart';
import '../klassen/training.dart';
import '../klassen/ziel.dart';

class WochenFortschritt extends StatelessWidget {
  List<Challenge> challenges;
  List<Training> trainings;

  WochenFortschritt(this.challenges, this.trainings);

  List<double> get fortschritt {
    double wocheMuss = 0.0;
    double wocheGemacht = 0.0;
    for (Challenge challenge in challenges) {
      for (Ziel ziel in challenge.ziele) {
        wocheMuss += ziel.tageMuss;
        wocheGemacht += ziel.tageGemacht;
      }
    }
    return [wocheGemacht, wocheMuss];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text("Wöchentlicher Fortschritt"),
          ),
          Row(
            children: [
              Flexible(
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
                        widthFactor: fortschritt[0] == 0.0
                            ? 0.0
                            : fortschritt[0] / fortschritt[1],
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
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
