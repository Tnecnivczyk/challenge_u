import 'package:challenge_u/classes/challenge.dart';
import 'package:challenge_u/classes/userChallengeU.dart';
import 'package:challenge_u/widgets/appWidgets/add/createFirstGoal.dart';
import 'package:challenge_u/widgets/appWidgets/add/selectGoals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../../../classes/goal.dart';
import 'addGoal.dart';

class AddChallengeBottomSheet extends StatefulWidget {
  const AddChallengeBottomSheet({super.key});

  @override
  State<AddChallengeBottomSheet> createState() => _AddChallengeBottomSheet();
}

class _AddChallengeBottomSheet extends State<AddChallengeBottomSheet> {
  bool differentChallenges = false;
  final List<Goal> _selected = [];

  final _challengeNameController = TextEditingController();

  void _addToSelected(Goal goal) {
    _selected.add(goal);
  }

  void _removeFromSelected(Goal goal) {
    _selected.removeWhere((item) => item.id == goal.id);
  }

  void _createChallenge() {
    if (_challengeNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('enter a valid challenge name'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
    if (_selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('selecte at least one goal for your challenge'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
    Challenge challenge = Challenge(
      !differentChallenges,
      DateTime.now(),
      DateTime.now().toString(),
      _challengeNameController.text.trim(),
      1000,
    );
    challenge.createChallenge();
    UserChallengeU.joinChallenge(challenge.id);
    for (Goal goal in _selected) {
      goal.createGoalInChallenge(challenge.id);
    }
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Challenge "${challenge.name}" was created successfully!'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _openAddGoal() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return const AddGoal();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Challenge"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(5),
        child: StreamBuilder(
          stream: Goal.readGoals(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('something went wrong');
            }
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            List<Goal> goals = snapshot.data!;
            if (goals.isEmpty) {
              return const CreateFirstGoal();
            }
            return Column(
              children: [
                TextFormField(
                  controller: _challengeNameController,
                  decoration: const InputDecoration(
                    labelText: "Give your challenge name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        gapPadding: 5),
                  ),
                  validator: (string) {
                    if (string == null || string.isEmpty) {
                      return 'enter valid name';
                    }
                    if (string.length > 30) {
                      return 'name is too long';
                    }

                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(
                  height: 5,
                ),
                Card(
                  elevation: 5,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'We all compete in whit the same goals',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        FlutterSwitch(
                          value: differentChallenges,
                          onToggle: (value) => setState(() {
                            differentChallenges = value;
                          }),
                          width: 60,
                          height: 30,
                          activeColor: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Card(
                  elevation: 5,
                  child: Column(
                    children: [
                      Text(
                        'Choose goals for the challenge',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SelectGoals(goals, _selected, _addToSelected,
                          _removeFromSelected),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            const Expanded(child: Text('Need another goal?')),
                            OutlinedButton(
                              onPressed: _openAddGoal,
                              child: const Text('Create goal'),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.primaryContainer,
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          width: 200,
          child: TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                  Theme.of(context).colorScheme.primary),
            ),
            onPressed: _createChallenge,
            child: Text(
              "Create challenge",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
