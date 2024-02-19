import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CircleTrainingListTile extends StatelessWidget {
  double count;
  String unit;
  late bool showComma;

  CircleTrainingListTile(this.count, this.unit, {super.key}) {
    if (count % 1 == 0) {
      showComma = false;
    } else {
      showComma = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: unit == "reps"
          ? Colors.amber[200]
          : unit == "m"
              ? Colors.blue[200]
              : unit == "min"
                  ? Colors.green[200]
                  : Colors.purple[300],
      radius: 22,
      child: Center(
        child: Text(
          showComma
              ? "${count.toStringAsFixed(1)}\n$unit"
              : "${count.toStringAsFixed(0)}\n$unit",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
            fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
            height: 1,
          ),
          selectionColor: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
