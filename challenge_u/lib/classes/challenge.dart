import 'package:challenge_u/classes/training.dart';

import '../classes/goal.dart';

class Challenge {
  String name;
  List<Goal> goals = [];
  String id;

  Challenge(this.name, this.id);

  void addGoal(Goal ziel) {
    ziel.challengeID = id;
    goals.add(ziel);
  }

  void removeGoal(Goal ziel) {
    goals.removeWhere((element) {
      if (element.sport == ziel.sport &&
          element.wiederholungenMuss == ziel.wiederholungenMuss) {
        return true;
      }
      return false;
    });
  }

  // Updates the completed training days for a goal with a lis of trainings
  void updateDaysCompleted(Goal goal, List<Training> currentTrainings) {
    // Initialize a map to track the number of repetitions performed on each day.
    Map<int, double> dayToRepetitions = {};
    // Initialize a variable to track completed days.
    int completedDays = 0;
    // Iterate over the current training sessions.
    for (Training training in currentTrainings) {
      // Check if the training session is relevant to the goal.
      if (training.sport == goal.sport) {
        // Check if the training session occurred on a day that has already been counted.
        if (dayToRepetitions.containsKey(training.datum.day)) {
          // If the day has already been counted, add the training session's repetitions to the count for that day.
          dayToRepetitions[training.datum.day] =
              (dayToRepetitions[training.datum.day]! + training.wiederholungen);
        } else {
          // If the day has not already been counted, add a new entry for the day.
          dayToRepetitions[training.datum.day] = training.wiederholungen;
        }
      }
    }
    // Counts the numer of days on which the goal was achieved
    dayToRepetitions.forEach((key, value) {
      if (value >= goal.wiederholungenMuss) {
        completedDays++;
      }
    });
    // Update the goal's completed days count.
    goal.tageGemacht = completedDays;
  }
}
