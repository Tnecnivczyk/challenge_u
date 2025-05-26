import 'package:challenge_u/classes/userChallengeU.dart';
import 'package:challenge_u/widgets/appWidgets/profile/friendListTile.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


class AddFriendsBottomSheet extends StatefulWidget {
  const AddFriendsBottomSheet({super.key});

  @override
  State<AddFriendsBottomSheet> createState() => _AddFriendsBottomSheetState();
}

class _AddFriendsBottomSheetState extends State<AddFriendsBottomSheet> {
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
                              return FriendListTile(pictureURL, user);
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
