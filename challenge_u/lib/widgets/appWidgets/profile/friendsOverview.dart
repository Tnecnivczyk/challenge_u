import 'package:challenge_u/classes/userChallengeU.dart';
import 'package:challenge_u/widgets/appWidgets/profile/friendListTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FreindsOverview extends StatelessWidget {
  const FreindsOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friends & Followers"),
      ),
      body: PageView(
        controller: PageController(initialPage: 0),
        children: [
          StreamBuilder(
              stream: UserChallengeU.readFriends(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('something went wrong');
                }
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                List<String> friends = snapshot.data!;
                return Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Your Friends',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Expanded(
                        child: ListView(
                            children: friends.map((friend) {
                          return FutureBuilder(
                              future: UserChallengeU.userData(friend),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Text('something went wrong');
                                }
                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator();
                                }
                                String pictureURL = snapshot.data!.keys.first;
                                UserChallengeU user =
                                    snapshot.data!.values.first;
                                return FriendListTile(pictureURL, user);
                              });
                        }).toList()),
                      ),
                    ],
                  ),
                );
              }),
          StreamBuilder(
              stream: UserChallengeU.readFollower(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('something went wrong');
                }
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                List<String> friends = snapshot.data!;
                return Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Your Follower',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Expanded(
                        child: ListView(
                            children: friends.map((friendId) {
                          return FutureBuilder(
                              future: UserChallengeU.userData(friendId),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Text('something went wrong');
                                }
                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator();
                                }
                                String pictureURL = snapshot.data!.keys.first;
                                UserChallengeU user =
                                    snapshot.data!.values.first;
                                return FriendListTile(pictureURL, user);
                              });
                        }).toList()),
                      ),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
