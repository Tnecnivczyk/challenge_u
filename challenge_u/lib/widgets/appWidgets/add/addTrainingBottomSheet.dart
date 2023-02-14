import 'package:challenge_u/classes/userChallengeU.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../classes/challenge.dart';
import '../../../classes/training.dart';
import '../../../classes/sport.dart';

class AddTrainingBottomSheet extends StatefulWidget {
  @override
  State<AddTrainingBottomSheet> createState() => _AddTrainingBottomSheetState();
}

class _AddTrainingBottomSheetState extends State<AddTrainingBottomSheet> {
  Sport _selected = Sport('_', '_');

  final _reps = TextEditingController();

  DateTime _date = DateTime.now();

  void _datePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((datum) {
      if (datum == null) {
        return;
      }
      setState(() {
        _date = datum;
      });
    });
  }

  void _createTraining(String name, double reps, DateTime date) {
    Training training = Training(name, reps, date, DateTime.now().toString());
    training.createTraining();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 7,
              child: TextField(
                controller: _reps,
                keyboardType: TextInputType.number,
                decoration:
                    InputDecoration(labelText: "Anzahl der Wiederholungen"),
              ),
            ),
            Card(
              elevation: 7,
              child: SizedBox(
                height: 220,
                child: StreamBuilder<List<Sport>>(
                  stream: Sport.readSports(),
                  builder: ((context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }
                    if (snapshot.hasData) {
                      final sports = snapshot.data!;
                      return ListView(
                        children: sports
                            .map((sport) => OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: _selected.name == sport.name
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.secondary,
                                  side: BorderSide(
                                      color: _selected.name == sport.name
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                ),
                                onPressed: () => _selected = sport,
                                child: Text(sport.name)))
                            .toList(),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
                ),
              ),
            ),
            Card(
              child: Container(
                height: 50,
                child: Row(
                  children: [
                    Expanded(child: Text(DateFormat("dd.MM.yy").format(_date))),
                    TextButton(
                      onPressed: _datePicker,
                      child: Text(
                        "Anderes Datum Auswählen",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            TextButton(
                onPressed: () => _createTraining(
                    _selected.name, double.parse(_reps.text), _date),
                child: Text("Training eintragen"))
          ],
        ),
      ),
    );
    ;
  }
}
