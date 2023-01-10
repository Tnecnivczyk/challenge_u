import 'package:challenge_u/helpers/databaseHelper.dart';
import 'package:challenge_u/widgets/addChallengeBottomSheet.dart';
import 'package:challenge_u/widgets/challengeOverview.dart';
import 'package:challenge_u/widgets/listOfTrainings.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:week_of_year/week_of_year.dart';

import 'classes/sport.dart';
import 'classes/goal.dart';
import 'classes/challenge.dart';
import 'classes/training.dart';

import 'widgets/weeklyProgress.dart';
import 'widgets/addTrainingBottomSheet.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Challenge U',
      theme: ThemeData(
        textTheme: ThemeData.light().textTheme.copyWith(
            headline6: const TextStyle(
              fontFamily: "Quicksand",
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            headline5: const TextStyle(
              fontFamily: "Quicksand",
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
            bodyText2: const TextStyle(
                fontFamily: "OpenSans",
                fontSize: 14,
                color: Colors.black), // style for body text
            caption: const TextStyle(
                fontFamily: "OpenSans",
                fontSize: 12,
                color: Colors.grey)), // style for captions
        buttonTheme: ButtonThemeData(
            buttonColor: Colors.lightGreen.shade300,
            textTheme: ButtonTextTheme.primary),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.teal,
          primaryColorDark: Colors.teal[800],
          accentColor: Colors.lightGreen.shade300,
          backgroundColor: Colors.white,
          cardColor: Colors.grey[50],
          errorColor: Colors.red[400],
        ),
      ),
      home: MyHomePage(),
    );
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
      return element.datum.weekOfYear == DateTime.now().weekOfYear;
    }).toList();
  }

  Future<void> loadAllData() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    _challenges.clear();
    List<Challenge> challenges = await dbHelper.getAllChallenges();
    for (Challenge challenge in challenges) {
      _challenges.add(challenge);
    }
    _trainings.clear();
    for (Training training in await dbHelper.getAllTrainings()) {
      _trainings.add(training);
    }
    for (Goal goal in await dbHelper.getAllGoals()) {
      for (Challenge challenge in _challenges) {
        if (challenge.id == goal.challengeID) {
          challenge.addGoal(goal);
        }
      }
    }
    _updatAllChallenges();
  }

  // Opens the bottom sheet to enter a training.
  void _openTrainingBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return AddTrainingBottomSheet(_addNewTraining);
        });
  }

  //Updates All challenges with the Trainings of the curent week
  void _updatAllChallenges() {
    for (Challenge challenge in _challenges) {
      for (Goal ziel in challenge.goals) {
        challenge.updateDaysCompleted(ziel, _currentTrainings);
      }
    }
  }

  // Adds a new training and updates the challenges accordingly.
  void _addNewTraining(Sport sport, double wiederholungen, DateTime datum) {
    if (sport == Sport.nichtAusgewaehlt || wiederholungen <= 0) {
      return;
    }
    final Training training =
        Training(sport, wiederholungen, datum, DateTime.now().toString());
    DatabaseHelper dbhelper = DatabaseHelper();
    dbhelper.insertTraining(training);
    setState(() {
      _trainings.add(training);
      _updatAllChallenges();
    });
  }

  // Opens the bottom sheet to add a new challenge.
  void _openChallengeBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return AddChallengeBottomSheet(_addNewChallenge);
        });
  }

  // Adds a new challenge.
  Future<void> _addNewChallenge(String challengeName, List<Goal> goals) async {
    Challenge challenge = Challenge(challengeName, DateTime.now().toString());
    // Insert a new challenge into the database
    DatabaseHelper dbHelper = DatabaseHelper();
    dbHelper.insertChallenge(challenge);
    //Adds als goals to the new Challenge
    for (Goal goal in goals) {
      // Set the challengeID of the goal to the ID of the challenge
      goal.challengeID = challenge.id;
      await dbHelper.insertGoal(goal);
    }
    setState(() {
      _updatAllChallenges();
    });
  }

  // Removes a training by its ID.
  // Updates the challenges by updating the number of days the goal was reached.
  void _removeTraining(String id) {
    DatabaseHelper dbHelper = DatabaseHelper();
    dbHelper.removeTraining(id);
    setState(() {
      _trainings.removeWhere((training) {
        return training.id == id;
      });
      _updatAllChallenges();
    });
  }

  // Removes a training by its ID.
  // Updates the challenges by updating the number of days the goal was reached.
  void _removeChallenge(String id) {
    setState(() {
      DatabaseHelper dbHelper = DatabaseHelper();
      dbHelper.removeChallenge(id);
      dbHelper.removeGoal(id);
      _challenges.removeWhere((challenge) {
        return challenge.id == id;
      });
      _updatAllChallenges();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Challenge U"),
        actions: [
          // The IconButton to add a new challenges.
          IconButton(
            onPressed: _openChallengeBottomSheet,
            icon: Icon(Icons.add),
          )
        ],
      ),
      // The main content of the app, shown in a Column widget.
      body: FutureBuilder(
        future: loadAllData(),
        builder: ((context, snapshot) => Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                // Displays the progress of the current week.
                WeeklyProgress(_challenges, _currentTrainings),
                // Displays the overview of all challenges.
                ChallengeOverview(_challenges, _removeChallenge),
                // Displays the list of all trainings.
                ListOfTrainings(_trainings, _removeTraining),
              ],
            )),
      ),
      // The FloatingActionButton to add a new training.
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTrainingBottomSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
