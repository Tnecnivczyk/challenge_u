import 'dart:ffi';

import 'package:challenge_u/widgets/appWidgets/add/addGoal.dart';
import 'package:challenge_u/widgets/appWidgets/overview/challengeOverview.dart';
import 'package:challenge_u/widgets/appWidgets/overview/goalOverview.dart';
import 'package:challenge_u/widgets/appWidgets/overview/listOfTrainings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:week_of_year/week_of_year.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../../classes/sport.dart';
import '../../../classes/goal.dart';
import '../../../classes/challenge.dart';
import '../../../classes/training.dart';

import 'invitationsWidget.dart';
import 'weeklyProgress.dart';
import '../add/addTraining.dart';
import '../add/add.dart';
import '../profile/profile.dart';

class Overview extends StatelessWidget {
  const Overview({super.key});

  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}

// The main widget of the app, representing the homepage.
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// The state of the MyHomePage widget.
class _MyHomePageState extends State<MyHomePage> {
  // List of all current challenges.
  final List<Challenge> _challenges = [];

  // List of all trainings.
  final List<Training> _trainings = [];

  // Returns the current trainings that are happening in the current week.
  List<Training> get _currentTrainings {
    return _trainings.where((element) {
      return element.date.weekOfYear == DateTime.now().weekOfYear;
    }).toList();
  }

  void _openAdd(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          return Add();
        },
      ),
    );
  }

  void _openProfile(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          return Profile(userId, true);
        },
      ),
    );
  }

  // Opens the bottom sheet to enter a training.
  void _openTrainingBottomSheet(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return const AddTraining();
        },
      ),
    );
  }

  void _openMesseges() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return const InvitationsWidget();
        },
      ),
    );
  }

  Stream<int> readMessageCounter() {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('invitations')
        .doc('count')
        .snapshots()
        .map((invitations) {
      if (invitations.data() != null) {
        return invitations.data()!['count'];
      }
      return 0;
    });
  }

  // Adds a new challenge.

  // Removes a training by its ID.
  // Updates the challenges by updating the number of days the goal was reached.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Challenge U"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 20,
            ),
            child: StreamBuilder(
              stream: readMessageCounter(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('something went wrong');
                }
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                int count = snapshot.data!;
                return GestureDetector(
                  onTap: count == 0 ? null : _openMesseges,
                  child: Stack(
                    children: [
                      Icon(
                        Icons.message_rounded,
                        size: 30,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Positioned(
                        right: 0.0,
                        bottom: 0.0,
                        child: Container(
                          padding: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: count == 0
                                ? Theme.of(context).colorScheme.onBackground
                                : Theme.of(context).colorScheme.error,
                          ),
                          child: Text(
                            '${count}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.background,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),

      // The main content of the app, shown in a Column widget.
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              height: 5,
            ),
            // Displays the progress of the current week.
            WeeklyProgress(_challenges, _currentTrainings),
            SizedBox(
              height: 5,
            ),
            // Displays the overview of all challenges.
            ChallengeOverview(),
            SizedBox(
              height: 5,
            ),
            // Displays the list of the weekly goals.
            GoalOverview(),
            SizedBox(
              height: 5,
            ),
            // Displays the list of all trainings.
            ListOfTrainings(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.primary,
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.primary),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.home,
                    color: Theme.of(context).colorScheme.background,
                  )),
              IconButton(
                  onPressed: () => _openAdd(context),
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.background,
                  )),
              IconButton(
                  onPressed: () => _openProfile(context),
                  icon: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.background,
                  )),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTrainingBottomSheet(context),
        child: const Icon(Icons.add),
      ),
    );

    // The FloatingActionButton to add a new training.
  }
}
