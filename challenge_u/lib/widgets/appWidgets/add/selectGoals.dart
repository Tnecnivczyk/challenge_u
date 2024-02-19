import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../classes/goal.dart';
import '../overview/goalWidget.dart';

class SelectGoals extends StatefulWidget {
  List<Goal> goals;
  List<Goal> _selected;
  Function _addToSelected;
  Function _removeFromSelected;

  SelectGoals(
      this.goals, this._selected, this._addToSelected, this._removeFromSelected,
      {super.key});

  @override
  State<SelectGoals> createState() => _SelectGoalsState();
}

class _SelectGoalsState extends State<SelectGoals> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.goals
          .asMap()
          .map((index, goal) {
            return MapEntry(
              index,
              GestureDetector(
                  child: Card(
                    color: widget._selected
                            .map((item) => item.id)
                            .contains(goal.id)
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Theme.of(context).colorScheme.background,
                    child: Column(
                      children: [
                        GoalWidget(goal, false),
                        const SizedBox(
                          height: 5,
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      if (widget._selected
                          .map((item) => item.id)
                          .contains(goal.id)) {
                        widget._removeFromSelected(goal);
                      } else {
                        widget._addToSelected(goal);
                      }
                    });
                  }),
            );
          })
          .values
          .toList(),
    );
  }
}
