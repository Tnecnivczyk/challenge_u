import 'dart:io';
import 'package:challenge_u/classes/userChallengeU.dart';
import 'package:challenge_u/widgets/appWidgets/overview/overview.dart';
import 'package:challenge_u/widgets/appWidgets/profile/posts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

import '../../../classes/Utils.dart';
import '../add/add.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void _openAdd(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          return const Add();
        },
      ),
    );
  }

  void _openOverview(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          return const Overview();
        },
      ),
    );
  }

  void _changeToStart() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
      return MyHomePage();
    }));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Challenge U"),
        actions: [
          // The IconButton to add a new challenges.
          ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                _changeToStart();
              },
              child: Text('Sign Out'))
        ],
      ),
      // The main content of the app, shown in a Column widget.
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FutureBuilder(
                future: UserChallengeU.readProfilePicture(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went false');
                  }
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    final pictures = snapshot.data;
                    return Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: PageView(
                        controller: PageController(initialPage: 0),
                        children: pictures!.items.map((picture) {
                          return FutureBuilder(
                              future: picture.getDownloadURL(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Text('something went wrong');
                                }
                                if (!snapshot.hasData) {
                                  return CircularProgressIndicator();
                                }
                                final pictureURL = snapshot.data;
                                return Container(
                                  height: 200,
                                  width: 300,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(pictureURL!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              });
                        }).toList(),
                      ),
                    );
                  }
                }),
            FutureBuilder(
                future: UserChallengeU.readUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Fehler');
                  }
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  final user = snapshot.data;
                  return Container(
                      padding: EdgeInsets.all(20),
                      child: Column(children: <Widget>[
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              user!.username,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            TextButton(
                              child: Text("Friends"),
                              onPressed: () {
                                // Navigate to friends list
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(user.biography),
                        ),
                        SizedBox(height: 20),
                        Posts(),
                      ]));
                })
          ],
        ),
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
                onPressed: () => _openAdd(context),
                icon: Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
              IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.background,
                  )),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _pickImage(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
