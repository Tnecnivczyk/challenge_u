import 'package:challenge_u/widgets/challengeUebersicht.dart';
import 'package:challenge_u/widgets/trainingsListe.dart';
import 'package:flutter/material.dart';
import 'package:week_of_year/week_of_year.dart';

import './klassen/sportart.dart';
import './klassen/ziel.dart';
import './klassen/challenge.dart';

import './widgets/wochenfortschritt.dart';
import './widgets/trainingEintragen.dart';
import './klassen/training.dart';
import './widgets/challengeHinzufuegen.dart';

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
            ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.teal,
          accentColor: Colors.lightGreen.shade300,
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Challenge> _challenges = [
    Challenge("Challege 1"),
  ];

  final List<Training> _trainings = [];
  List<Training> get _aktuelleTrainings {
    return _trainings.where((element) {
      return element.datum.weekOfYear == DateTime.now().weekOfYear;
    }).toList();
  }

  void _startTrainingEintragen(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TrainingEintragen(_trainingEintragen);
        });
  }

  void _trainingEintragen(
      Sportart sportart, double wiederholungen, DateTime datum) {
    if (sportart == Sportart.nichtAusgewaehlt || wiederholungen <= 0) {
      return;
    }
    final Training training =
        Training(sportart, wiederholungen, datum, DateTime.now().toString());

    setState(() {
      _trainings.add(training);
      for (Challenge challenge in _challenges) {
        for (Ziel ziel in challenge.ziele) {
          challenge.aktualisiereTageGemacht(ziel, _aktuelleTrainings);
        }
      }
      print("${_aktuelleTrainings.length}");
    });
  }

  void _startChallengeHinzufuegen() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return ChallengeHinzufuegen(_trainingEintragen);
        });
  }

  void _challengeHinzufuegen(
    List<Training> trainings,
  ) {}

  void _trainingEntfernen(String id) {
    setState(() {
      _trainings.removeWhere((training) {
        return training.id == id;
      });
      for (Challenge challenge in _challenges) {
        for (Ziel ziel in challenge.ziele) {
          challenge.aktualisiereTageGemacht(ziel, _aktuelleTrainings);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Challenge U"),
        actions: [
          IconButton(
            onPressed: _startChallengeHinzufuegen,
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          WochenFortschritt(_challenges, _aktuelleTrainings),
          ChallengeUebersicht(_challenges),
          TrainingsListe(_trainings, _trainingEntfernen),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startTrainingEintragen(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
