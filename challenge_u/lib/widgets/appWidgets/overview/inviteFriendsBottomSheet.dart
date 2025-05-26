import 'package:challenge_u/classes/userChallengeU.dart';
import 'package:challenge_u/widgets/appWidgets/overview/friendListTile1.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../../classes/challenge.dart';

class InviteFriendsBottomSheet extends StatefulWidget {
  final Challenge challenge;
  const InviteFriendsBottomSheet(this.challenge, {super.key});

  @override
  State<InviteFriendsBottomSheet> createState() =>
      _InviteFriendsBottomSheetState();
}

class _InviteFriendsBottomSheetState extends State<InviteFriendsBottomSheet> {
  final _friendNameController = TextEditingController();
  bool _search = false;

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
                  decoration: const InputDecoration(
                    labelText: 'Username',
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () => setState(() {
                        _search = true;
                      }),
                  child: const Text('search'))
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          !_search
              ? const Text('Press search for possible users')
              : FutureBuilder(
                  future: UserChallengeU.readUsersByName(
                      _friendNameController.text.trim()),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('No matched user found');
                    }
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    final user = snapshot.data!;
                    return SizedBox(
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
                              return FriendListTile1(
                                  pictureURL, user, widget.challenge);
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
