import 'package:challenge_u/widgets/appWidgets/overview/goalWidget.dart';
import 'package:flutter/material.dart';

import '../../../classes/goal.dart';
import '../add/addGoal.dart';

class GoalOverview extends StatefulWidget {
  const GoalOverview({super.key});

  @override
  State<GoalOverview> createState() => _GoalOverviewState();
}

class _GoalOverviewState extends State<GoalOverview> {
  bool shown = true;
  void _openGoal() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return const AddGoal();
        },
      ),
    );
  }

  void _hideGoals() {
    setState(() {
      shown = false;
    });
  }

  void _showGoals() {
    setState(() {
      shown = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
                        'Create Your First Goal',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ),
                  onTap: () => _openGoal(),
                ),
              ),
            ],
          );
        }
        return Card(
          elevation: 5,
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 20,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        left: 7,
                      ),
                      child: Text(
                        'Your goals for this week',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      onPressed: () {
                        final RenderBox button =
                            context.findRenderObject() as RenderBox;
                        showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(
                            button.localToGlobal(Offset.zero).dx +
                                MediaQuery.of(context).size.width,
                            button.localToGlobal(Offset.zero).dy,
                            button.localToGlobal(Offset.zero).dx,
                            button.localToGlobal(Offset.zero).dy,
                          ),
                          // Position des Menüs
                          items: <PopupMenuEntry>[
                            shown
                                ? PopupMenuItem(
                                    onTap: () => _hideGoals(),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('hide'),
                                        Icon(Icons.visibility_off),
                                      ],
                                    ),
                                  )
                                : PopupMenuItem(
                                    onTap: () => _showGoals(),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('show'),
                                        Icon(Icons.visibility),
                                      ],
                                    ),
                                  ),
                          ],
                        ).then((value) {
                          // Aktion, wenn eine Option ausgewählt wurde
                          setState(() {});
                        });
                      },
                    ),
                  ],
                ),
                shown
                    ? Column(
                        children: goals.map((goal) {
                          return GoalWidget(goal, true);
                        }).toList(),
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
