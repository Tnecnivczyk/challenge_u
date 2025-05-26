import 'package:challenge_u/widgets/appWidgets/add/addGoal.dart';
import 'package:challenge_u/widgets/appWidgets/add/addSports.dart';
import 'package:challenge_u/widgets/appWidgets/navigationBarBottom.dart';
import 'package:flutter/material.dart';

import 'addFriendsBottomSheet.dart';
import 'addChallenge.dart';
import 'addTraining.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  // Opens the bottom sheet to enter a training.
  void _openTrainingBottomSheet() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return const AddTraining();
        },
      ),
    );
  }

  void _openAddGoal() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return const AddGoal();
        },
      ),
    );
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

  void _openFriendsBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return const AddFriendsBottomSheet();
        });
  }

  void _openChallengeBottomSheet(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return const AddChallengeBottomSheet();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Challenge U"),
      ),
      // The main content of the app, shown in a Column widget.
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: TextButton(
                    onPressed: _openTrainingBottomSheet,
                    child: const Text('Log Training'),
                  ),
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: TextButton(
                    onPressed: _openAddGoal,
                    child: const Text('Set Goal'),
                  ),
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: TextButton(
                    onPressed: _openFriendsBottomSheet,
                    child: const Text('Add / Remove Friends'),
                  ),
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: TextButton(
                    onPressed: _openAddSports,
                    child: const Text('Create New Sport'),
                  ),
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: TextButton(
                    child: const Text('Create Challenge'),
                    onPressed: () => _openChallengeBottomSheet(context),
                  ),
                ),
              ],
            )),
      ),
      bottomNavigationBar: NavigationBarBottom('add'),
    );
  }
}
