import 'package:challenge_u/classes/userChallengeU.dart';
import 'package:challenge_u/widgets/appWidgets/overview/challengeRanking.dart';
import 'package:flutter/material.dart';

import 'package:challenge_u/classes/challenge.dart';

import '../add/addChallenge.dart';
import 'challengeWidget.dart';

class ChallengeOverview extends StatefulWidget {
  const ChallengeOverview({super.key});

  @override
  State<ChallengeOverview> createState() => _ChallengeoverviewState();
}

class _ChallengeoverviewState extends State<ChallengeOverview> {
  void _openChallengeBottomSheet(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return const AddChallengeBottomSheet();
        },
      ),
    );
  }

  void _openChallengeRanking(BuildContext context, String challengeId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return ChallegngeRanking(challengeId);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: UserChallengeU.readChallengeIds(),
      builder: ((context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.hasData) {
          final challenges = snapshot.data!;
          if (challenges.isEmpty) {
            return Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 20,
                  height: 50,
                  child: GestureDetector(
                    child: Card(
                      elevation: 5,
                      child: Center(
                        child: Text(
                          'Create Your First Challenge',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    ),
                    onTap: () => _openChallengeBottomSheet(context),
                  ),
                ),
              ],
            );
          }
          return Column(children: [
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 250,
              child: PageView(
                  children: challenges.map((challengeId) {
                return GestureDetector(
                  onTap: () => _openChallengeRanking(context, challengeId),
                  child: Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    elevation: 5,
                    child: FutureBuilder(
                      future: Challenge.readChallenge(challengeId),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text(
                              'something went wrong whith the challenge ');
                        }
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }
                        Challenge challenge = snapshot.data!;
                        return ChallengeWidget(challenge);
                      },
                    ),
                  ),
                );
              }).toList()),
            ),
          ]);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }
}
