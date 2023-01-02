import '../klassen/sportart.dart';

class Ziel {
  Sportart sportart;
  var wiederholungenMuss;

  var tageMuss;
  var tageGemacht;

  Ziel(this.sportart, this.wiederholungenMuss, this.tageMuss) {
    tageGemacht = 0;
  }

  void setTageGemacht(int tage) {
    tageGemacht = tage;
  }
}
