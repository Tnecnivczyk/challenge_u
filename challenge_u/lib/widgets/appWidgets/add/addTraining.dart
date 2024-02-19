import 'package:challenge_u/classes/userChallengeU.dart';
import 'package:challenge_u/widgets/appWidgets/add/inputTextfield.dart';
import 'package:challenge_u/widgets/appWidgets/add/sportsList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../classes/challenge.dart';
import '../../../classes/training.dart';
import '../../../classes/sport.dart';

class AddTraining extends StatefulWidget {
  const AddTraining({super.key});

  @override
  State<AddTraining> createState() => _AddTrainingState();
}

class _AddTrainingState extends State<AddTraining> {
  Sport _selected = Sport('_', '_');

  final _reps = TextEditingController();
  final _meters = TextEditingController();
  final _minutes = TextEditingController();
  final _weight = TextEditingController();

  DateTime _date = DateTime.now();

  void _changeSelected(Sport sport) {
    _selected = sport;
  }

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

  void _createTraining() {
    if (_legaleEingabe()) {
      Training training = Training(
          _selected.name,
          double.parse(_reps.text),
          double.parse(_meters.text),
          double.parse(_minutes.text),
          double.parse(_weight.text),
          _date,
          DateTime.now().toString());
      training.createTraining();
    }
  }

  void setZeroIfEmpty() {
    if (_reps.text.isEmpty) {
      _reps.text = '0';
    }
    if (_minutes.text.isEmpty) {
      _minutes.text = '0';
    }
    if (_meters.text.isEmpty) {
      _meters.text = '0';
    }
    if (_weight.text.isEmpty) {
      _weight.text = '0';
    }
  }

  bool _legaleEingabe() {
    if (_reps.text.isEmpty &&
        _meters.text.isEmpty &&
        _minutes.text.isEmpty &&
        _weight.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('one type of performance is needed'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return false;
    }
    setZeroIfEmpty();
    if (_reps.text.contains(',') ||
        _reps.text.contains(':') ||
        _minutes.text.contains(',') ||
        _minutes.text.contains(':') ||
        _meters.text.contains(',') ||
        _meters.text.contains(':') ||
        _weight.text.contains(',') ||
        _weight.text.contains(':')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('use the "." to seperet decimal numbers'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return false;
    }
    if (double.tryParse(_reps.text) == null ||
        double.tryParse(_meters.text) == null ||
        double.tryParse(_minutes.text) == null ||
        double.tryParse(_weight.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('only numbers in are allowed'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Register training",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 5,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 2),
                      child: Text(
                        "Choose the sport",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SportsList(_changeSelected),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Card(
                elevation: 5,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 2),
                      child: Text(
                        "Select date",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                              child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              DateFormat("dd.MM.yy").format(_date),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          )),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: OutlinedButton(
                              onPressed: _datePicker,
                              child: const Text(
                                "Change date",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Card(
                elevation: 7,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 2),
                      child: Text(
                        "Performance",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    InputTextField(_reps, "repetitions"),
                    InputTextField(_meters, "distance"),
                    InputTextField(_minutes, "time"),
                    InputTextField(_weight, "weight"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.primaryContainer,
        shape: CircularNotchedRectangle(),
        child: SizedBox(
          width: 200,
          child: TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                  Theme.of(context).colorScheme.primary),
            ),
            onPressed: _createTraining,
            child: Text(
              "Log Training",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: 20),
            ),
          ),
        ),
      ),
    );
    ;
  }
}
