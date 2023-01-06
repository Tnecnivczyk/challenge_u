import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../classes/challenge.dart';
import '../classes/training.dart';
import '../classes/sport.dart';

class AddTrainingBottomSheet extends StatefulWidget {
  final Function trainingEintragen;

  AddTrainingBottomSheet(this.trainingEintragen);

  @override
  State<AddTrainingBottomSheet> createState() => _AddTrainingBottomSheetState();
}

class _AddTrainingBottomSheetState extends State<AddTrainingBottomSheet> {
  final List<bool> _isSelected =
      List.generate(Sport.values.length, (_) => false);

  final _anzahlDerWiederholungen = TextEditingController();

  DateTime _ausgewaehltesDatum = DateTime.now();

  Sport get _getSport {
    for (int i = 0; i < _isSelected.length; i++) {
      if (_isSelected.elementAt(i)) {
        return Sport.beintraining.indexToEnum(i);
      }
    }
    return Sport.nichtAusgewaehlt;
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
                itemCount: Sport.values.length - 1,
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
                      child: Text(Sport.bouldern.indexToString(index)));
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
                  _getSport, _getWiederholungen, _ausgewaehltesDatum),
              child: Text("Training eintragen"))
        ],
      ),
    );
    ;
  }
}
