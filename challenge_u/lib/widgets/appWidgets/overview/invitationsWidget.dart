import 'package:challenge_u/classes/invitation.dart';
import 'package:challenge_u/classes/userChallengeU.dart';
import 'package:challenge_u/widgets/appWidgets/overview/invitationsListtile.dart';
import 'package:flutter/material.dart';

import '../../../classes/challenge.dart';
import 'challengeRanking.dart';

class InvitationsWidget extends StatefulWidget {
  const InvitationsWidget({super.key});

  @override
  State<InvitationsWidget> createState() => _InvitationsWidgetState();
}

class _InvitationsWidgetState extends State<InvitationsWidget> {
  void _openChallengeRanking(BuildContext context, String challengeId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return ChallegngeRanking(challengeId);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invitations"),
      ),
      body: StreamBuilder(
        stream: Invitation.readInvitations(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('something went wrong');
          }
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          List<Map<String, dynamic>> allInvitations = snapshot.data!;
          List<Invitation> invitationsList = [];
          for (var element in allInvitations) {
            element.forEach((userId, challengeIds) {
              if (userId != 'count') {
                for (String challengeId in challengeIds) {
                  invitationsList.add(Invitation(challengeId, userId));
                }
              }
            });
          }
          return ListView.builder(
            itemCount: invitationsList.length,
            itemBuilder: (context, index) {
              return FutureBuilder(
                future: Future.wait([
                  UserChallengeU.userData(invitationsList[index].authorId),
                  Challenge.readChallenge(invitationsList[index].challengeId)
                ]),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('something went wrong');
                  }
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  Map<String, UserChallengeU> mapUser =
                      snapshot.data![0] as Map<String, UserChallengeU>;
                  UserChallengeU author = mapUser.values.first;
                  Challenge challenge = snapshot.data![1] as Challenge;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    child: InvitationsListTile(
                        author, challenge, _openChallengeRanking),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
