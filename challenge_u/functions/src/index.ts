/**
 * Import function triggers from their respective submodules:
 *
 * import { onCall } from "firebase-functions/v2/https";
 * import { onDocumentWritten } from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import {onSchedule} from "firebase-functions/v2/scheduler";
import * as logger from "firebase-functions/logger";
import * as admin from "firebase-admin";

admin.initializeApp();
// Start writing functions
// https://firebase.google.com/docs/functions/typescript

exports.updateChallengeProgress = onSchedule("every sunday 23:59", async () => {
  const userListSnapshot = await admin.firestore().collection("users").get();

  userListSnapshot.forEach(async (user) => {
    const trainingListSnapshot = await admin
      .firestore()
      .collection("users")
      .doc(user.id)
      .collection("trainings")
      .get();

    const goalsListSnapshot = await admin
      .firestore()
      .collection("users")
      .doc(user.id)
      .collection("goals")
      .get();

    if (!goalsListSnapshot.empty) {
      const challengeCompletePercentage: Map<string, number[]> = new Map();
      const trainings: Map<string, any>[] = [];
      let percentDone = 0;
      const batch = admin.firestore().batch();

      trainingListSnapshot.forEach((trainingData) => {
        const training = new Map();
        training.set("id", trainingData.data()["id"]);
        training.set("date", trainingData.data()["date"]);
        training.set("sportName", trainingData.data()["sportName"]);
        training.set("reps", trainingData.data()["reps"]);
        training.set("meters", trainingData.data()["meters"]);
        training.set("minutes", trainingData.data()["minutes"]);
        training.set("kilograms", trainingData.data()["kilograms"]);
        trainings.push(training);
        logger.log(trainingData.data()["sportName"] + " training");
      });

      for (const goalData of goalsListSnapshot.docs) {
        const goal = new Map();
        goal.set("id", goalData.data()["id"]);
        goal.set("sportName", goalData.data()["sportName"]);
        goal.set("count", goalData.data()["count"]);
        goal.set("daysToDo", goalData.data()["daysToDo"]);
        goal.set("goalType", goalData.data()["goalType"]);
        logger.log(goalData.data()["sportName"] + " goalData");
        percentDone = calculateCompletionPercentage(goal, trainings);
        if (percentDone > 100) {
          percentDone = 100;
        }
        logger.log(percentDone);

        const challengesSnapshot = await admin
          .firestore()
          .collection("users")
          .doc(user.id)
          .collection("goals")
          .doc(goalData.id)
          .collection("challengeIds")
          .get();

        challengesSnapshot.forEach((challengeDoc) => {
          if (challengeCompletePercentage.has(challengeDoc.id)) {
            const existingList = challengeCompletePercentage.get(
              challengeDoc.id
            );
            existingList!.push(percentDone);
          } else {
            challengeCompletePercentage.set(challengeDoc.id, [percentDone]);
          }
          logger.log(challengeCompletePercentage.get(challengeDoc.id) +
            "bis hier gehts");
        });
      }

      logger.log(challengeCompletePercentage.size + "das ist nicht 0?");
      for (const [challengeID, percentages] of challengeCompletePercentage) {
        logger.log("gehts noch?");
        let average = 0;
        let missedPercentOld = 0;
        let weeksAsParticipant = 0;
        let missedPercentNew = 0;
        logger.log(challengeID + "challenge ID");
        logger.log(percentages + "percentage");
        const path = admin
          .firestore()
          .collection("challenges")
          .doc(challengeID)
          .collection("participants")
          .doc(user.id);
        logger.log(path + "path");
        logger.log(challengeID + " challengeID");
        logger.log(user.id + " userID");
        const participantSnapshot = await path.get();
        if (participantSnapshot.exists) {
          logger.log("existiert");
        } else {
          logger.log("existiert nicht");
        }
        missedPercentOld = participantSnapshot
          .data()!.trainingsMissedPercent;
        logger.log(missedPercentOld + "missedPercentOld");
        weeksAsParticipant = participantSnapshot.data()!.weeksAsParticipant;

        percentages.forEach((value) => {
          average += value;
        });
        average /= percentages.length;
        logger.log(average + " avg");
        batch.update(path, {
          weeksAsParticipant: admin.firestore.FieldValue.increment(1),
        });
        missedPercentNew = (weeksAsParticipant * missedPercentOld +
            100 -
            average) /
          (weeksAsParticipant + 1);
        batch.update(path, {
          trainingsMissedPercent: Math.floor(missedPercentNew),
        });
        logger.log((weeksAsParticipant * missedPercentOld +
          100 -
          average) /
          (weeksAsParticipant + 1) + " training missed percent");
        if (average == 100) {
          batch.update(path,
            {weeksDone: admin.firestore.FieldValue.increment(1)});
        }
      }
      batch
        .commit()
        .then(() => {
          console.log("Das Feld wurde erfolgreich aktualisiert.");
        })
        .catch((error) => {
          console.error("Fehler beim Aktualisieren des Feldes:", error);
        });
    }
  });
  logger.log("fertig mit allem");
});

/**
 * Berechnet den Abschlussprozentsatz für eine bestimmte Zielvorgabe.
 *
 * @param {Map<string, any>} goal - Die Zielvorgabe,
 * für die der Abschlussprozentsatz berechnet werden soll.
 * @param {Map<string, any>[]} trainings - Eine Liste der Trainingsdaten.
 * @return {number} Der berechnete Abschlussprozentsatz.
 */
function calculateCompletionPercentage(
  goal: Map<string, any>,
  trainings: Map<string, any>[]
): number {
  const dayToRepetitions: Map<string, number> = new Map();
  let completedDays = 0;
  const goaltype: string = goal.get("goalType");
  logger.log(goaltype);
  trainings.forEach((training) => {
    if (training.get("sportName") ===
      goal.get("sportName")) {
      const dateString = training.get("date");
      const date = new Date(dateString);
      const weekday = date
        .toLocaleDateString("en-US", {
          weekday: "long",
        });
      logger.log(weekday);
      logger.log(training.get(goaltype));
      if (date >= getStartOfWeek(new Date())) {
        if (dayToRepetitions.has(weekday)) {
          const currentRepetitions = dayToRepetitions.get(weekday)!;
          dayToRepetitions.set(weekday, currentRepetitions + training
            .get(goaltype));
        } else {
          dayToRepetitions.set(weekday, training.get(goaltype));
        }
      }
    }
  });

  dayToRepetitions.forEach((value) => {
    if (value >= goal.get("count")) {
      completedDays++;
    }
  });

  return (completedDays * 100) / goal.get("daysToDo");
}

/**
 * Gibt das Startdatum der Woche (Montag) zurück, in der das gegebene
 * Datum liegt.
 * Das Datum selbst wird nicht verändert.
 *
 * @param {Date} date - Das Datum, für das das Startdatum der Woche ermittelt
 * werden soll.
 * @return {Date} Das Startdatum der Woche (Montag) als neues Date-Objekt.
 */
function getStartOfWeek(date: Date): Date {
  const dayOfWeek = date.getDay();
  const diff = (dayOfWeek + 6) % 7;
  date.setDate(date.getDate() - diff);
  date.setHours(0, 0, 0, 0);
  return date;
}
