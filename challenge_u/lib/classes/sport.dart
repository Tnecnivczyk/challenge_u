enum Sport {
  liegestuetz,
  klimzuege,
  dehnen,
  situps,
  hangboard,
  bouldern,
  joggen,
  beintraining,
  nichtAusgewaehlt;

  String indexToString(int index) {
    switch (index) {
      case 0:
        return "Liegestütz";
      case 1:
        return "Klimzüge";
      case 2:
        return "Dehnen";
      case 3:
        return "Situps";
      case 4:
        return "Hangboard";
      case 5:
        return "Bouldern";
      case 6:
        return "Joggen";
      case 7:
        return "Beintraining";

      default:
        return "Nicht Ausgewählt";
    }
  }

  Sport indexToEnum(int index) {
    switch (index) {
      case 0:
        return Sport.liegestuetz;
      case 1:
        return Sport.klimzuege;
      case 2:
        return Sport.dehnen;
      case 3:
        return Sport.situps;
      case 4:
        return Sport.hangboard;
      case 5:
        return Sport.bouldern;
      case 6:
        return Sport.joggen;
      case 7:
        return Sport.beintraining;

      default:
        return Sport.nichtAusgewaehlt;
    }
  }

  String enumToString(Sport sport) {
    switch (sport) {
      case Sport.liegestuetz:
        return "Liegestütz";
      case Sport.klimzuege:
        return "Klimzüge";
      case Sport.dehnen:
        return "Dehnen";
      case Sport.situps:
        return "Situps";
      case Sport.hangboard:
        return "Hangboard";
      case Sport.bouldern:
        return "Bouldern";
      case Sport.joggen:
        return "Joggen";
      case Sport.beintraining:
        return "Beintraining";
      default:
        return "Nicht Ausgewählt";
    }
  }

  int enumToIndex(Sport sport) {
    switch (sport) {
      case Sport.liegestuetz:
        return 0;
      case Sport.klimzuege:
        return 1;
      case Sport.dehnen:
        return 2;
      case Sport.situps:
        return 3;
      case Sport.hangboard:
        return 4;
      case Sport.bouldern:
        return 5;
      case Sport.joggen:
        return 6;
      case Sport.beintraining:
        return 7;

      default:
        return 8;
    }
  }
}
