import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../klassen/sportart.dart';
import '../klassen/training.dart';

class TrainingsListe extends StatelessWidget {
  List<Training> trainings;

  Function trainingEntfernen;

  TrainingsListe(this.trainings, this.trainingEntfernen);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: ListView.builder(
        itemCount: trainings.length,
        itemBuilder: (training, index) {
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                radius: 30,
                child: Text(
                    "x${trainings.elementAt(index).wiederholungen.toString()}"),
              ),
              title: Text(
                Sportart.bouldern.asString(trainings.elementAt(index).sportart),
                style: Theme.of(context).textTheme.headline5,
              ),
              subtitle: Text(DateFormat("dd.MM.yyyy")
                  .format(trainings.elementAt(index).datum)),
              trailing: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                onPressed: () => trainingEntfernen(trainings[index].id),
              ),
            ),
          );
        },
      ),
    );
  }
}
