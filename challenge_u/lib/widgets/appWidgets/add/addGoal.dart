import 'package:challenge_u/widgets/appWidgets/add/inputTextfield.dart';
import 'package:challenge_u/widgets/appWidgets/add/selectabeBox.dart';
import 'package:challenge_u/widgets/appWidgets/add/sportsList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/single_child_widget.dart';

import '../../../classes/challenge.dart';
import '../../../classes/training.dart';
import '../../../classes/sport.dart';
import '../../../classes/goal.dart';
import 'addSports.dart';

class AddGoal extends StatefulWidget {
  const AddGoal({super.key});

  @override
  State<AddGoal> createState() => _AddGoalState();
}

class _AddGoalState extends State<AddGoal> {
  final _countController = TextEditingController();
  final _daysController = TextEditingController();
  Sport _selected = Sport('_', '_');
  int _selectedType = -1;

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

  void _changeSelected(Sport sport) {
    _selected = sport;
  }

  void handleBoxTap(int index) {
    setState(() {
      _selectedType = index;
    });
  }

  void _addGoal() {
    if (_legaleEingabe()) {
      String selected = "";
      switch (_selectedType) {
        case 0:
          selected = "reps";
          break;
        case 1:
          selected = "meters";
          break;
        case 2:
          selected = "minutes";
          break;
        case 3:
          selected = "kilograms";
          break;
      }
      Goal goal = Goal(
          _selected.name,
          double.parse(_countController.text.trim()),
          double.parse(_daysController.text.trim()),
          DateTime.now().toString(),
          selected);
      goal.createGoal();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('you have created a new goal'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    }
  }

  bool _legaleEingabe() {
    if (_countController.text.isEmpty || _daysController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Set parameters for your goal'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return false;
    }
    if (double.tryParse(_countController.text) == null ||
        double.tryParse(_daysController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('only numbers are allowed'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return false;
    }
    if (double.parse(_countController.text) < 1 ||
        double.parse(_daysController.text) < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Some number might bee to low'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return false;
    }
    if (double.parse(_daysController.text) > 7) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('There are maximum 7 days a week'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return false;
    }
    if (_selected.name == '_') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Select a sport'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return false;
    }
    if (_selectedType < 0 || _selectedType > 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Select how you want to track your goal'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return false;
    }
    return true;
  }

  void _openAddSports() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return const AddSports();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Set your new Goal",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        "Choose the sport",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SportsList(_changeSelected),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          const Expanded(
                              child: Text('Your sport doesn`t exist?')),
                          OutlinedButton(
                            onPressed: _openAddSports,
                            child: const Text('Create Sport'),
                          )
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
                elevation: 5,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 2),
                      child: Text(
                        "Choose how to track the progress",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 2),
                          child: SizedBox(
                            width: 85,
                            child: Text(
                              "repetitions",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 2),
                          child: SizedBox(
                            width: 85,
                            child: Text(
                              "distance",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 2),
                          child: SizedBox(
                            width: 85,
                            child: Text(
                              "time",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 2),
                          child: SizedBox(
                            width: 85,
                            child: Text(
                              "weight",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SelectableBox(0, 0 == _selectedType, handleBoxTap),
                        SelectableBox(1, 1 == _selectedType, handleBoxTap),
                        SelectableBox(2, 2 == _selectedType, handleBoxTap),
                        SelectableBox(3, 3 == _selectedType, handleBoxTap),
                      ],
                    ),
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
                        "Set parameters",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    InputTextField(_daysController, "number of weekdays"),
                    InputTextField(_countController,
                        "reps / meters / minutes / kilograms"),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
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
            onPressed: () => _addGoal(),
            child: Text(
              "Add Goal!",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
