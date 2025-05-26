import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../classes/sport.dart';

class AddSports extends StatefulWidget {
  const AddSports({super.key});

  @override
  State<AddSports> createState() => _AddSportsState();
}

class _AddSportsState extends State<AddSports> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Sport"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 300,
              child: TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _createSport,
              child: const Text('Create new sport'),
            )
          ],
        ),
      ),
    );
  }
}
