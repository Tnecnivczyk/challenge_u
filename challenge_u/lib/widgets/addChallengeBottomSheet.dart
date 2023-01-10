import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../classes/challenge.dart';
import '../classes/training.dart';
import '../classes/sport.dart';
import '../classes/goal.dart';

class AddChallengeBottomSheet extends StatefulWidget {
  final Function challengeHinzufuegen;

  AddChallengeBottomSheet(this.challengeHinzufuegen);

  @override
  State<AddChallengeBottomSheet> createState() =>
      _AddChallengeBottomSheetState();
}

class _AddChallengeBottomSheetState extends State<AddChallengeBottomSheet> {
  final List<int> _isSelected = List.generate(Sport.values.length, (_) => 0);

  final _anzahlDerWiederholungen = TextEditingController();
  final _nameDerChallenge = TextEditingController();
  final _anzahlDerWochentage = TextEditingController();

  DateTime _ausgewaehltesDatum = DateTime.now();

  final List<Goal> _ziele = [];

  Sport get _getSport {
    for (int i = 0; i < _isSelected.length; i++) {
      if (_isSelected.elementAt(i) == 2) {
        return Sport.beintraining.indexToEnum(i);
      }
    }
    return Sport.nichtAusgewaehlt;
  }

  double get _getWiederholungen {
    return double.parse(_anzahlDerWiederholungen.text);
  }

  double get _getTage {
    return double.parse(_anzahlDerWochentage.text);
  }

  void _challengeHungufuegen() {
    zielErneuern();
    widget.challengeHinzufuegen(_nameDerChallenge.text, _ziele);
  }

  void _auswahl(int index) {
    setState(() {
      zielErneuern();
      for (int i = 0; i < _isSelected.length; i++) {
        if (_isSelected[i] == 2) {
          if (_legaleEingabe()) {
            _isSelected[i] = 1;
          } else {
            _isSelected[i] = 0;
          }
        }
      }
      _isSelected[index] = 2;
      Goal renewGoal = _ziele.firstWhere(
          (goal) => goal.sport == Sport.nichtAusgewaehlt.indexToEnum(index),
          orElse: () =>
              Goal(Sport.nichtAusgewaehlt, 0, 0, DateTime.now().toString()));
      _anzahlDerWiederholungen.text =
          renewGoal.wiederholungenMuss.toStringAsFixed(0);
      _anzahlDerWochentage.text = renewGoal.tageMuss.toStringAsFixed(0);
    });
  }

  void zielErneuern() {
    if (_legaleEingabe()) {
      _ziele.removeWhere((element) {
        return element.sport == _getSport;
      });
      _ziele.add(Goal(
          _getSport, _getWiederholungen, _getTage, DateTime.now().toString()));
    }
  }

  bool _legaleEingabe() {
    if (_anzahlDerWiederholungen.text.isEmpty ||
        _anzahlDerWochentage.text.isEmpty) {
      return false;
    }
    if (double.tryParse(_anzahlDerWiederholungen.text) == null ||
        double.tryParse(_anzahlDerWochentage.text) == null) {
      return false;
    }
    if (double.parse(_anzahlDerWiederholungen.text) < 1 ||
        double.parse(_anzahlDerWochentage.text) < 1) {
      return false;
    }
    if (double.parse(_anzahlDerWochentage.text) > 7) {
      return false;
    }
    if (_getSport == Sport.nichtAusgewaehlt) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 7,
            child: TextField(
              controller: _nameDerChallenge,
              decoration: InputDecoration(labelText: "Name der Challenge"),
            ),
          ),
          Card(
            elevation: 7,
            child: TextField(
              controller: _anzahlDerWochentage,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: "Anzahl der Wochentage"),
            ),
          ),
          Card(
            elevation: 7,
            child: TextField(
              controller: _anzahlDerWiederholungen,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: "Anzahl der Wiederholungen"),
            ),
          ),
          Card(
            elevation: 7,
            child: SizedBox(
              height: 180,
              child: ListView.builder(
                itemCount: Sport.values.length - 1,
                itemBuilder: ((context, index) {
                  return OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _isSelected[index] == 0
                            ? Theme.of(context).colorScheme.primary
                            : _isSelected[index] == 1
                                ? Theme.of(context).colorScheme.secondary
                                : Colors.blue,
                        side: BorderSide(
                          color: _isSelected[index] == 0
                              ? Theme.of(context).colorScheme.primary
                              : _isSelected[index] == 1
                                  ? Theme.of(context).colorScheme.secondary
                                  : Colors.blue,
                        ),
                      ),
                      onPressed: () => _auswahl(index),
                      child: Text(Sport.bouldern.indexToString(index)));
                }),
              ),
            ),
          ),
          TextButton(
              onPressed: () => _challengeHungufuegen(),
              child: Text("ChallengeHinzufügen")),
        ],
      ),
    );
  }
}
