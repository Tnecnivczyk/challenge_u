import 'package:challenge_u/classes/userChallengeU.dart';
import 'package:challenge_u/widgets/appWidgets/navigationBarBottom.dart';
import 'package:challenge_u/widgets/appWidgets/profile/friendsOverview.dart';
import 'package:challenge_u/widgets/appWidgets/profile/posts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../classes/Utils.dart';

class Profile extends StatefulWidget {
  String userId;
  bool owner;
  Profile(this.userId, this.owner, {super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool picturesExpandet = false;

  void _openFriends(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return const FreindsOverview();
        },
      ),
    );
  }

  void _pickImage(BuildContext context) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) {
      Utils.showErrorSnackBar('No picture selected', context);
      return;
    }
    setState(() {
      UserChallengeU.createProfilePicture(image);
    });
  }

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

  void _toggleExpandedState() {
    setState(() {
      picturesExpandet = !picturesExpandet;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Challenge U"),
        actions: [
          // The IconButton to add a new challenges.
          widget.owner
              ? ElevatedButton(
                  onPressed: FirebaseAuth.instance.signOut,
                  child: const Text('Sign Out'))
              : Container()
        ],
      ),
      // The main content of the app, shown in a Column widget.
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FutureBuilder(
                future: UserChallengeU.readProfilePicture(widget.userId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went false');
                  }
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    final pictures = snapshot.data;
                    return SizedBox(
                      height: picturesExpandet
                          ? MediaQuery.of(context).size.width * 1.1
                          : 250,
                      width: MediaQuery.of(context).size.width,
                      child: PageView(
                        controller: PageController(initialPage: 0),
                        children: pictures!.items.map((picture) {
                          return FutureBuilder(
                              future: picture.getDownloadURL(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Text('something went wrong');
                                }
                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator();
                                }
                                final pictureURL = snapshot.data;
                                return Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: _toggleExpandedState,
                                      child: Container(
                                        height: picturesExpandet
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                1.1
                                            : 250,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(pictureURL!),
                                            fit: BoxFit.cover,
                                            alignment: Alignment.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                    widget.userId ==
                                                FirebaseAuth.instance
                                                    .currentUser!.uid &&
                                            picture.fullPath !=
                                                'default/profilepicture/profil.png'
                                        ? Positioned(
                                            top: 10,
                                            right: 10,
                                            child: GestureDetector(
                                              onTap: () => setState(() {
                                                UserChallengeU
                                                    .deleteProfilePicture(
                                                        picture.fullPath);
                                              }),
                                              child: const Icon(Icons.delete),
                                            ),
                                          )
                                        : Container()
                                  ],
                                );
                              });
                        }).toList(),
                      ),
                    );
                  }
                }),
            FutureBuilder(
                future: UserChallengeU.readUser(widget.userId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Fehler');
                  }
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final user = snapshot.data!;
                  return Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(children: <Widget>[
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              user.username,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            widget.owner
                                ? TextButton(
                                    child: Text(
                                      "Friends",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary),
                                    ),
                                    onPressed: () {
                                      _openFriends(context);
                                    },
                                  )
                                : FutureBuilder(
                                    future: UserChallengeU.readFriend(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return const Text(
                                            'something went wrong');
                                      }
                                      if (!snapshot.hasData) {
                                        return const CircularProgressIndicator();
                                      }
                                      final friends = snapshot.data!;
                                      return !friends.contains(widget.userId)
                                          ? OutlinedButton(
                                              style: ButtonStyle(
                                                  foregroundColor:
                                                      MaterialStatePropertyAll(
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .onPrimary),
                                                  backgroundColor:
                                                      MaterialStatePropertyAll(
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .primary)),
                                              onPressed: () => _addFriend(
                                                  user.id, user.username),
                                              child: SizedBox(
                                                width: 60,
                                                child: Center(
                                                    child: Text(
                                                  'Add Friend',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .tertiary),
                                                )),
                                              ),
                                            )
                                          : OutlinedButton(
                                              style: ButtonStyle(
                                                  foregroundColor:
                                                      MaterialStatePropertyAll(
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .primary),
                                                  backgroundColor:
                                                      MaterialStatePropertyAll(
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .background)),
                                              onPressed: () => _removeFriend(
                                                  user.id, user.username),
                                              child: SizedBox(
                                                width: 60,
                                                child: Center(
                                                    child: Text(
                                                  'Remove Friend',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .tertiary),
                                                  textAlign: TextAlign.center,
                                                )),
                                              ),
                                            );
                                    },
                                  ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(user.biography),
                        ),
                        const SizedBox(height: 20),
                        const Posts(),
                      ]));
                })
          ],
        ),
      ),
      bottomNavigationBar: const NavigationBarBottom('profile'),
      floatingActionButton: widget.owner
          ? FloatingActionButton(
              onPressed: () => setState(() {
                _pickImage(context);
              }),
              child: const Icon(Icons.add),
            )
          : Container(),
    );
  }
}
