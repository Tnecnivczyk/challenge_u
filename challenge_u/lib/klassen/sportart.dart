enum Sportart {
  liegestuetz,
  klimzuege,
  dehnen,
  situps,
  hangboard,
  bouldern,
  joggen,
  beintraining,
  nichtAusgewaehlt;

  String indexAtAsString(int index) {
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

  Sportart indexAtAsEnum(int index) {
    switch (index) {
      case 0:
        return Sportart.liegestuetz;
      case 1:
        return Sportart.klimzuege;
      case 2:
        return Sportart.dehnen;
      case 3:
        return Sportart.situps;
      case 4:
        return Sportart.hangboard;
      case 5:
        return Sportart.bouldern;
      case 6:
        return Sportart.joggen;
      case 7:
        return Sportart.beintraining;

      default:
        return Sportart.nichtAusgewaehlt;
    }
  }

  String asString(Sportart sportart) {
    switch (sportart) {
      case Sportart.liegestuetz:
        return "Liegestütz";
      case Sportart.klimzuege:
        return "Klimzüge";
      case Sportart.dehnen:
        return "Dehnen";
      case Sportart.situps:
        return "Situps";
      case Sportart.hangboard:
        return "Hangboard";
      case Sportart.bouldern:
        return "Bouldern";
      case Sportart.joggen:
        return "Joggen";
      case Sportart.beintraining:
        return "Beintraining";

      default:
        return "Nicht Ausgewählt";
    }
  }
}
