import 'package:challenge_u/widgets/appWidgets/add/add.dart';
import 'package:challenge_u/widgets/appWidgets/overview/overview.dart';
import 'package:challenge_u/widgets/appWidgets/profile/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NavigationBarBottom extends StatelessWidget {
  final String widgetName;
  const NavigationBarBottom(this.widgetName, {Key? key}) : super(key: key);

  void _openOverview(BuildContext context) {
    if (widgetName == 'overview') {
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          return const Overview();
        },
      ),
    );
  }

  void _openProfile(BuildContext context) {
    if (widgetName == 'profile') {
      return;
    }
    String userId = FirebaseAuth.instance.currentUser!.uid;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          return Profile(userId, true);
        },
      ),
    );
  }

  void _openAdd(BuildContext context) {
    if (widgetName == 'add') {
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          return const Add();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: BottomAppBar(
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
                  onPressed: () => _openAdd(context),
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
