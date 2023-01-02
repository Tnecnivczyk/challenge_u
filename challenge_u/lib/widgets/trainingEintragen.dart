import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../klassen/challenge.dart';
import '../klassen/training.dart';
import '../klassen/sportart.dart';

class TrainingEintragen extends StatefulWidget {
  final Function trainingEintragen;

  TrainingEintragen(this.trainingEintragen);

  @override
  State<TrainingEintragen> createState() => _TrainingEintragenState();
}

class _TrainingEintragenState extends State<TrainingEintragen> {
  final List<bool> _isSelected =
      List.generate(Sportart.values.length, (_) => false);

  final _anzahlDerWiederholungen = TextEditingController();

  DateTime _ausgewaehltesDatum = DateTime.now();

  Sportart get _getSportart {
    for (int i = 0; i < _isSelected.length; i++) {
      if (_isSelected.elementAt(i)) {
        return Sportart.beintraining.indexAtAsEnum(i);
      }
    }
    return Sportart.nichtAusgewaehlt;
  }

  double get _getWiederholungen {
    return double.parse(_anzahlDerWiederholungen.text);
  }

  void _datumAuswhalAnzeigen() {
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
        _ausgewaehltesDatum = datum;
      });
    });
  }

  void _auswahl(int index) {
    setState(() {
      for (int i = 0; i < _isSelected.length; i++) {
        _isSelected[i] = false;
      }
      _isSelected[index] = true;
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
              controller: _anzahlDerWiederholungen,
              keyboardType: TextInputType.number,
              decoration:
                  InputDecoration(labelText: "Anzahl der Wiederholungen"),
            ),
          ),
          Card(
            elevation: 7,
            child: SizedBox(
              height: 220,
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
            child: Container(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                          DateFormat("dd.MM.yy").format(_ausgewaehltesDatum))),
                  TextButton(
                    onPressed: _datumAuswhalAnzeigen,
                    child: Text(
                      "Anderes Datum Auswählen",
                    ),
                  ),
                ],
              ),
            ),
          ),
          TextButton(
              onPressed: () => widget.trainingEintragen(
                  _getSportart, _getWiederholungen, _ausgewaehltesDatum),
              child: Text("Training eintragen"))
        ],
      ),
    );
    ;
  }
}
