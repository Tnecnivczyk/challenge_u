import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../classes/sport.dart';

class AddSportsBottomSheet extends StatefulWidget {
  const AddSportsBottomSheet({super.key});

  @override
  State<AddSportsBottomSheet> createState() => _AddSportsBottomSheetState();
}

class _AddSportsBottomSheetState extends State<AddSportsBottomSheet> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _createSport() async {
    final docSports = FirebaseFirestore.instance
        .collection('sports')
        .doc(_nameController.text.trim());
    final sport =
        Sport(_nameController.text.trim(), _descriptionController.text.trim());
    await docSports.set(sport.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 400,
            child: TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _createSport,
            child: Text('Create new sport'),
          )
        ],
      ),
    );
  }
}
