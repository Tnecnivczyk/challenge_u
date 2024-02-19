import 'package:challenge_u/classes/userChallengeU.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../classes/Utils.dart';
import '../../../classes/challenge.dart';

class FriendListTile1 extends StatefulWidget {
  String pictureURL;
  UserChallengeU user;
  Challenge challenge;

  FriendListTile1(this.pictureURL, this.user, this.challenge);

  @override
  State<FriendListTile1> createState() => _FriendListTileState1();
}

class _FriendListTileState1 extends State<FriendListTile1> {
  void _inviteFirend(String userId, String username) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('invitations')
          .doc(FirebaseAuth.instance.currentUser!.uid.toString())
          .set({
        'id': FieldValue.arrayUnion([widget.challenge.id])
      }, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      Utils.showErrorSnackBar(e.message, context);
      return;
    }
    Utils.showSnackBar(
        '$username is now invited to the ${widget.challenge.name} challenge',
        context);
    setState(() {});
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('invitations')
        .doc('count')
        .set({'count': FieldValue.increment(1)}, SetOptions(merge: true));
  }

  Future<bool> isInvitedOrParticipant(UserChallengeU user) async {
    return await FirebaseFirestore.instance
            .collection('challenges')
            .doc(widget.challenge.id)
            .collection('participants')
            .get()
            .then((snapshot) {
          bool isParticipant = false;
          snapshot.docs.forEach((participant) async {
            String participantId = participant.data()['userId'].toString();
            if (participantId == widget.user.id) {
              isParticipant = true;
            }
          });
          return isParticipant;
        }) ||
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.id)
            .collection('invitations')
            .get()
            .then((snapshot) {
          bool isInvited = false;
          snapshot.docs.forEach((invitation) async {
            for (String invitationId in invitation.data()['id']) {
              if (invitationId == widget.challenge.id) {
                isInvited = true;
              }
            }
          });
          return isInvited;
        });
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
          future: isInvitedOrParticipant(widget.user),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('something went wrong');
            }
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            final invited = snapshot.data!;
            return !invited
                ? IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    onPressed: () =>
                        _inviteFirend(widget.user.id, widget.user.username),
                  )
                : Text('already invited');
          }),
    );
    ;
  }
}
