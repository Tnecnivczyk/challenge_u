import 'package:flutter/material.dart';

import '../../../classes/challenge.dart';
import '../../../classes/training.dart';

class WeeklyProgress extends StatelessWidget {
  List<Challenge> challenges;
  List<Training> trainings;

  WeeklyProgress(this.challenges, this.trainings, {super.key});

  List<double> get progress {
    double toDo = 0.0;
    double done = 0.0;
    for (Challenge challenge in challenges) {}
    return [done, toDo];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text("Weekly Progress"),
          ),
          Row(
            children: [
              Flexible(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  height: 10,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(220, 220, 220, 1),
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: progress[0] == 0.0
                            ? 0.0
                            : progress[0] / progress[1],
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
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
