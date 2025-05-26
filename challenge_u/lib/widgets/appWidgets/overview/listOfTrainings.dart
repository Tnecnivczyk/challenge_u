
import 'package:challenge_u/widgets/appWidgets/overview/circleTrainingListTile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../classes/training.dart';

class ListOfTrainings extends StatelessWidget {
  const ListOfTrainings({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: StreamBuilder<List<Training>>(
          stream: Training.readTrainings(),
          builder: (ctx, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went false');
            }
            if (snapshot.hasData) {
              final trainings = snapshot.data!;
              return Card(
                elevation: 5,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        left: 7,
                      ),
                      child: Text(
                        'Trainings',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      height: 350,
                      child: ListView(
                        children: trainings
                            .map(
                              (training) => Card(
                                elevation: 0,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 5),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(0),
                                  leading: SizedBox(
                                    width: 80,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        training.sportName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ),
                                  ),
                                  title: SizedBox(
                                    width: 10,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 52,
                                          child: training.reps != 0
                                              ? CircleTrainingListTile(
                                                  training.reps, "reps")
                                              : Container(),
                                        ),
                                        SizedBox(
                                          width: 52,
                                          child: training.meters != 0
                                              ? CircleTrainingListTile(
                                                  training.meters, "m")
                                              : Container(),
                                        ),
                                        SizedBox(
                                          width: 52,
                                          child: training.minutes != 0
                                              ? CircleTrainingListTile(
                                                  training.minutes, "min")
                                              : Container(),
                                        ),
                                        SizedBox(
                                          width: 52,
                                          child: training.kilograms != 0
                                              ? CircleTrainingListTile(
                                                  training.kilograms, "kg")
                                              : Container(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  subtitle: Text(
                                    DateFormat("dd.MM.yyyy")
                                        .format(training.date),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  trailing: Container(
                                    alignment: Alignment.centerLeft,
                                    width: 34,
                                    child: IconButton(
                                      alignment: Alignment.centerRight,
                                      iconSize: 22,
                                      icon: Icon(
                                        Icons.delete,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                      ),
                                      onPressed: () =>
                                          training.deleteTraining(),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
