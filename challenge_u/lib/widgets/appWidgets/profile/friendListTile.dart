import 'package:challenge_u/classes/userChallengeU.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../classes/Utils.dart';

class FriendListTile extends StatefulWidget {
  String pictureURL;
  UserChallengeU user;

  FriendListTile(this.pictureURL, this.user);

  @override
  State<FriendListTile> createState() => _FriendListTileState();
}

class _FriendListTileState extends State<FriendListTile> {
  void _addFriend(String userId, String username) async {
    try {
      await UserChallengeU.createFriend(userId);
      await UserChallengeU.createFollower(userId);
    } on FirebaseException catch (e) {
      Utils.showErrorSnackBar(e.message, context);
      return;
    }
    Utils.showSnackBar('$username is now your friend', context);
    setState(() {});
  }

  void _removeFriend(String userId, String username) async {
    try {
      await UserChallengeU.deleteFriend(userId);
      await UserChallengeU.deleteFollower(userId);
    } on FirebaseException catch (e) {
      Utils.showErrorSnackBar(e.message, context);
      return;
    }
    Utils.showSnackBar('$username is not longer your friend', context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        radius: 30,
        backgroundImage: NetworkImage(widget.pictureURL),
      ),
      title: Text(
        widget.user.username,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: Text(
        widget.user.realName,
        style: Theme.of(context).textTheme.labelMedium,
      ),
      trailing: FutureBuilder(
          future: UserChallengeU.readFriend(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('something went wrong');
            }
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            final friends = snapshot.data!;
            return !friends.contains(widget.user.id)
                ? IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    onPressed: () =>
                        _addFriend(widget.user.id, widget.user.username),
                  )
                : IconButton(
                    icon: Icon(
                      Icons.remove_circle_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () =>
                        _removeFriend(widget.user.id, widget.user.username),
                  );
          }),
    );
    ;
  }
}
