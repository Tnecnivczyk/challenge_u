import 'package:challenge_u/widgets/appWidgets/add/addChallengeBottomSheet.dart';
import 'package:challenge_u/widgets/appWidgets/add/addSportsBottomSheet.dart';
import 'package:challenge_u/widgets/appWidgets/overview/overview.dart';
import 'package:flutter/material.dart';

import '../profile/profile.dart';
import 'addFriendsBottomSheet.dart';
import 'addTrainingBottomSheet.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  void _openOverview(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          return const Overview();
        },
      ),
    );
  }

  void _openProfile(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          return const Profile();
        },
      ),
    );
  }

  // Opens the bottom sheet to enter a training.
  void _openTrainingBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return AddTrainingBottomSheet();
        });
  }

  void _openChallengeBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return AddChallengeBottomSheet();
        });
  }

  void _openSportsBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return AddSportsBottomSheet();
        });
  }

  void _openFriendsBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return AddFriendsBottomSheet();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Challenge U"),
      ),
      // The main content of the app, shown in a Column widget.
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Container(
                  width: double.maxFinite,
                  child: TextButton(
                    child: Text('Add Training'),
                    onPressed: _openTrainingBottomSheet,
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  child: TextButton(
                    child: Text('Add Challenge'),
                    onPressed: _openChallengeBottomSheet,
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  child: TextButton(
                    child: Text('Add / Remove Friends'),
                    onPressed: _openFriendsBottomSheet,
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  child: TextButton(
                    child: Text('Add Sports'),
                    onPressed: _openSportsBottomSheet,
                  ),
                ),
              ],
            )),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.primary,
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.primary),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () => _openOverview(context),
                  icon: Icon(
                    Icons.home,
                    color: Theme.of(context).colorScheme.background,
                  )),
              IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.background,
                  )),
              IconButton(
                  onPressed: () => _openProfile(context),
                  icon: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.background,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
