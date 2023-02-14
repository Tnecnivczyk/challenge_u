import 'package:challenge_u/classes/userChallengeU.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../classes/Utils.dart';

class AddFriendsBottomSheet extends StatefulWidget {
  const AddFriendsBottomSheet({super.key});

  @override
  State<AddFriendsBottomSheet> createState() => _AddFriendsBottomSheetState();
}

class _AddFriendsBottomSheetState extends State<AddFriendsBottomSheet> {
  final _friendNameController = TextEditingController();
  bool _search = false;

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
    return Card(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _friendNameController,
                  onChanged: (value) => setState(() {
                    _search = false;
                  }),
                  decoration: InputDecoration(
                    labelText: 'Username',
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () => setState(() {
                        _search = true;
                      }),
                  child: Text('search'))
            ],
          ),
          SizedBox(
            height: 5,
          ),
          !_search
              ? const Text('Press search for possible users')
              : FutureBuilder(
                  future: UserChallengeU.readUsersByName(
                      _friendNameController.text.trim()),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('No matched user found');
                    }
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    final user = snapshot.data!;
                    return Container(
                      height: 500,
                      child: Column(
                        children: [
                          FutureBuilder(
                            future: FirebaseStorage.instance
                                .ref(user.id)
                                .child('profilepictures')
                                .listAll()
                                .then((pictures) {
                              return pictures.items.first.getDownloadURL();
                            }),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Text('No matched user found');
                              }
                              if (!snapshot.hasData) {
                                return const CircularProgressIndicator();
                              }
                              final pictureURL = snapshot.data!;
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  radius: 30,
                                  backgroundImage: NetworkImage(pictureURL),
                                ),
                                title: Text(
                                  user.username,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                subtitle: Text(user.biography),
                                trailing: FutureBuilder(
                                    future: UserChallengeU.readFirends(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return const Text(
                                            'something went wrong');
                                      }
                                      if (!snapshot.hasData) {
                                        return const CircularProgressIndicator();
                                      }
                                      final friends = snapshot.data!;
                                      return !friends.contains(user.id)
                                          ? IconButton(
                                              icon: Icon(
                                                Icons.add,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                              ),
                                              onPressed: () => _addFriend(
                                                  user.id, user.username),
                                            )
                                          : IconButton(
                                              icon: Icon(
                                                Icons.remove_circle_outline,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                              onPressed: () => _removeFriend(
                                                  user.id, user.username),
                                            );
                                    }),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
