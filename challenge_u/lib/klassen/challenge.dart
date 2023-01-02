import 'package:challenge_u/klassen/sportart.dart';
import 'package:challenge_u/klassen/training.dart';

import '../klassen/ziel.dart';

class Challenge {
  final String name;
  final List<Ziel> ziele = [];

  Challenge(this.name) {
    zielAddieren(new Ziel(Sportart.bouldern, 1, 3));
  }

  void zielAddieren(Ziel ziel) {
    ziele.add(ziel);
  }

  void zielEntfernen(Ziel ziel) {
    ziele.removeWhere((element) {
      if (element.sportart == ziel.sportart &&
          element.wiederholungenMuss == ziel.wiederholungenMuss) {
        return true;
      }
      return false;
    });
  }

  bool tagEnthalten(DateTime day, List<DateTime> tagZwischenspeicher) {
    for (DateTime datumCheck in tagZwischenspeicher) {
      if (datumCheck.day == day.day) {
        return true;
      }
    }
    return false;
  }

  void aktualisiereTageGemacht(Ziel ziel, List<Training> aktuelleTrainings) {
    if (!ziele.contains(ziel)) {
      return;
    }
    List<DateTime> erledigteTage = [];
    int tage = 0;
    double wiederhoungenTeilweise = 0;
    DateTime tagZwischenspeicher = DateTime.now();
    print("ja0");
    for (Training trainingCheck in aktuelleTrainings) {
      print("${trainingCheck.sportart}, ${ziel.sportart}}");
      if (trainingCheck.sportart == ziel.sportart &&
          !tagEnthalten(trainingCheck.datum, erledigteTage)) {
        print("ja1");
        if (trainingCheck.wiederholungen >= ziel.wiederholungenMuss) {
          print("ja2");
          tage++;
          erledigteTage.add(trainingCheck.datum);
        } else if (tagZwischenspeicher.day == trainingCheck.datum.day) {
          wiederhoungenTeilweise += trainingCheck.wiederholungen;
          tagZwischenspeicher = trainingCheck.datum;
          print("ja3");
          if (wiederhoungenTeilweise >= ziel.wiederholungenMuss) {
            tage++;
            erledigteTage.add(trainingCheck.datum);
            wiederhoungenTeilweise = 0;
          }
        } else {
          print("uff");
          wiederhoungenTeilweise = trainingCheck.wiederholungen;
          tagZwischenspeicher = trainingCheck.datum;
        }
      }
    }
    for (Ziel zielListe in ziele) {
      if (zielListe == ziel) {
        zielListe.tageGemacht = tage;
      }
    }
  }
}
