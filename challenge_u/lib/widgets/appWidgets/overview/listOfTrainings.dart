import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../classes/sport.dart';
import '../../../classes/training.dart';

class ListOfTrainings extends StatelessWidget {
  Function removeTraining;

  ListOfTrainings(this.removeTraining);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: StreamBuilder<List<Training>>(
          stream: Training.readTrainings(),
          builder: (ctx, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went false');
            }
            if (snapshot.hasData) {
              final trainings = snapshot.data!;
              return ListView(
                children: trainings
                    .map(
                      (training) => Card(
                        elevation: 4,
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            radius: 30,
                            child: Text("x${training.reps}"),
                          ),
                          title: Text(
                            training.sportName,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          subtitle: Text(
                              DateFormat("dd.MM.yyyy").format(training.date)),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Theme.of(context).errorColor,
                            ),
                            onPressed: () => removeTraining(training.id),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
