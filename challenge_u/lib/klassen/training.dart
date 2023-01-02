import '../klassen/sportart.dart';

class Training {
  Sportart sportart;
  double wiederholungen;
  DateTime datum;
  String id;

  Training(this.sportart, this.wiederholungen, this.datum, this.id);
}
