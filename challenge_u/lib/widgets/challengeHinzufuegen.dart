import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../klassen/challenge.dart';
import '../klassen/training.dart';
import '../klassen/sportart.dart';
import '../klassen/ziel.dart';

class ChallengeHinzufuegen extends StatefulWidget {
  final Function challengeHinzufuegen;

  ChallengeHinzufuegen(this.challengeHinzufuegen);

  @override
  State<ChallengeHinzufuegen> createState() => _ChallengeHinzufuegenState();
}

class _ChallengeHinzufuegenState extends State<ChallengeHinzufuegen> {
  final List<int> _isSelected = List.generate(Sportart.values.length, (_) => 0);

  final _anzahlDerWiederholungen = TextEditingController();
  final _nameDerChallenge = TextEditingController();
  final _anzahlDerWochentage = TextEditingController();

  DateTime _ausgewaehltesDatum = DateTime.now();

  final List<Ziel> _ziele = [];

  Sportart get _getSportart {
    for (int i = 0; i < _isSelected.length; i++) {
      if (_isSelected.elementAt(i) == 1) {
        return Sportart.beintraining.indexAtAsEnum(i);
      }
    }
    return Sportart.nichtAusgewaehlt;
  }

  double get _getWiederholungen {
    return double.parse(_anzahlDerWiederholungen.text);
  }

  void _auswahl(int index) {
    setState(() {
      for (int i = 0; i < _isSelected.length; i++) {
        _isSelected[i] = 0;
      }
      _isSelected[index] = 1;
      for (int i = 0; i < _ziele.length; i++) {}
    });
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
            child: SizedBox(
              height: 180,
              child: ListView.builder(
                itemCount: Sportart.values.length - 1,
                itemBuilder: ((context, index) {
                  return OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _isSelected[index] == false
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.secondary,
                        side: BorderSide(
                            color: _isSelected[index] == false
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.secondary),
                      ),
                      onPressed: () => _auswahl(index),
                      child: Text(Sportart.bouldern.indexAtAsString(index)));
                }),
              ),
            ),
          ),
          Card(
            elevation: 7,
            child: TextField(
              controller: _anzahlDerWochentage,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Anzahl der Wochentage"),
            ),
          ),
          Card(
            elevation: 7,
            child: TextField(
              controller: _anzahlDerWiederholungen,
              keyboardType: TextInputType.number,
              decoration:
                  InputDecoration(labelText: "Anzahl der Wiederholungen"),
            ),
          ),
          TextButton(
              onPressed: () => widget.challengeHinzufuegen(
                  _getSportart, _getWiederholungen, _ausgewaehltesDatum),
              child: Text("ChallengeHinzufügen")),
        ],
      ),
    );
  }
}
