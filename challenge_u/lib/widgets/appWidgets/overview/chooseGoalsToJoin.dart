import 'package:challenge_u/classes/challenge.dart';
import 'package:challenge_u/classes/invitation.dart';
import 'package:challenge_u/widgets/appWidgets/add/createFirstGoal.dart';
import 'package:challenge_u/widgets/appWidgets/add/selectGoals.dart';
import 'package:flutter/material.dart';

import '../../../classes/goal.dart';
import '../../../classes/userChallengeU.dart';

class ChooseGoalsToJoinSheet extends StatefulWidget {
  Challenge challenge;
  String author;
  ChooseGoalsToJoinSheet(this.challenge, this.author, {super.key});

  @override
  State<ChooseGoalsToJoinSheet> createState() => _ChooseGoalsToJoinSheetState();
}

class _ChooseGoalsToJoinSheetState extends State<ChooseGoalsToJoinSheet> {
  final List<Goal> _selected = [];

  void _addToSelected(Goal goal) {
    setState(() {
      _selected.add(goal);
    });
  }

  void _removeFromSelected(Goal goal) {
    setState(() {
      _selected.removeWhere((item) => item.id == goal.id);
    });
  }

  void _joinChallenge(List<Goal> goals) async {
    UserChallengeU.joinChallenge(widget.challenge.id);
    for (Goal goal in goals) {
      goal.createGoal();
      goal.createGoalInChallenge(widget.challenge.id);
    }
    Invitation.deleteInvitation(widget.author, widget.challenge.id);
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose Goals for ${widget.challenge.name}"),
      ),
      body: SingleChildScrollView(
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
              return goals.isEmpty
                  ? const CreateFirstGoal()
                  : Column(
                      children: [
                        SelectGoals(goals, _selected, _addToSelected,
                            _removeFromSelected),
                        Row(
                          children: [
                            OutlinedButton(
                                onPressed: _selected.isEmpty
                                    ? null
                                    : () => _joinChallenge(_selected),
                                child: const Text("Join challenge")),
                            OutlinedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("Go back")),
                          ],
                        ),
                      ],
                    );
            }),
      ),
    );
  }
}
