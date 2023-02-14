import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/single_child_widget.dart';

import '../../../classes/challenge.dart';
import '../../../classes/training.dart';
import '../../../classes/sport.dart';
import '../../../classes/goal.dart';

class AddChallengeBottomSheet extends StatefulWidget {
  @override
  State<AddChallengeBottomSheet> createState() =>
      _AddChallengeBottomSheetState();
}

class _AddChallengeBottomSheetState extends State<AddChallengeBottomSheet> {
  final _repsController = TextEditingController();
  final _challengeNameController = TextEditingController();
  final _daysController = TextEditingController();
  Sport _selected = Sport('_', '_');

  final List<Goal> _goals = [];

  Stream<List<Sport>> _readSports() {
    return FirebaseFirestore.instance.collection('sports').snapshots().map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => Sport.fromMap(
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  double get _getWiederholungen {
    return double.parse(_repsController.text.trim());
  }

  double get _getTage {
    return double.parse(_daysController.text.trim());
  }

  void _addChallenge() {
    zielErneuern();
    Challenge challenge = Challenge(
        _challengeNameController.text.trim(), DateTime.now().toString());
    challenge.createChallenge();
    for (Goal goal in _goals) {
      goal.challengeID = challenge.id;
      goal.createGoal();
    }
  }

  void _auswahl(String sportsName) {
    setState(() {
      zielErneuern();
      Goal renewGoal = _goals.firstWhere((goal) => goal.sportName == sportsName,
          orElse: () => Goal('_', 0, 0, DateTime.now().toString()));
      _repsController.text = renewGoal.reps.toStringAsFixed(0);
      _daysController.text = renewGoal.days.toStringAsFixed(0);
    });
  }

  void zielErneuern() {
    if (_legaleEingabe()) {
      _goals.removeWhere((element) {
        return element.sportName == _selected.name;
      });
      _goals.add(Goal(_selected.name, _getWiederholungen, _getTage,
          DateTime.now().toString()));
    }
  }

  bool _legaleEingabe() {
    if (_repsController.text.isEmpty || _daysController.text.isEmpty) {
      return false;
    }
    if (double.tryParse(_repsController.text) == null ||
        double.tryParse(_daysController.text) == null) {
      return false;
    }
    if (double.parse(_repsController.text) < 1 ||
        double.parse(_daysController.text) < 1) {
      return false;
    }
    if (double.parse(_daysController.text) > 7) {
      return false;
    }
    if (_selected.name == '_') {
      return false;
    }
    return true;
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
                controller: _challengeNameController,
                decoration: InputDecoration(labelText: "Name der Challenge"),
              ),
            ),
            Card(
              elevation: 7,
              child: TextField(
                controller: _daysController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: "Anzahl der Wochentage"),
              ),
            ),
            Card(
              elevation: 7,
              child: TextField(
                controller: _repsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: "Anzahl der Wiederholungen"),
              ),
            ),
            Card(
              elevation: 7,
              child: SizedBox(
                height: 180,
                child: StreamBuilder<List<Sport>>(
                  stream: _readSports(),
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
            TextButton(
                onPressed: () => _addChallenge(), child: Text("Add Challenge")),
          ],
        ),
      ),
    );
  }
}
