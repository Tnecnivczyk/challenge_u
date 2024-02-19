import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'addGoal.dart';

class CreateFirstGoal extends StatelessWidget {
  const CreateFirstGoal({super.key});

  void _openAddGoal(BuildContext context) {
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
    return Card(
      child: Column(
        children: [
          Text(
            'Create a goal for yourself.\nTherafter you can turn it into a Multi-User-Challenge!',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          OutlinedButton(
            onPressed: () => _openAddGoal(context),
            child: Text('Create New Goal'),
          )
        ],
      ),
    );
    ;
  }
}
