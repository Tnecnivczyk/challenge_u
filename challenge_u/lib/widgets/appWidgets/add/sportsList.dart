import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../classes/sport.dart';

class SportsList extends StatefulWidget {
  final Function _changeSelected;
  const SportsList(this._changeSelected, {super.key});

  @override
  State<SportsList> createState() => _SportsListState();
}

class _SportsListState extends State<SportsList> {
  Sport _selected = Sport('_', '_');
  Stream<List<Sport>> _readSports() {
    return FirebaseFirestore.instance
        .collection('sports')
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => Sport.fromMap(
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: StreamBuilder<List<Sport>>(
        stream: _readSports(),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.hasData) {
            final sports = snapshot.data!;
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
              child: ListView(
                children: sports
                    .map((sport) => OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _selected.name == sport.name
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.background,
                          backgroundColor: _selected.name == sport.name
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.background,
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        onPressed: () => setState(() {
                              widget._changeSelected(sport);
                              _selected = sport;
                            }),
                        child: Text(
                          sport.name,
                          style: TextStyle(
                              color: _selected.name == sport.name
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.onBackground),
                        )))
                    .toList(),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
    );
  }
}
