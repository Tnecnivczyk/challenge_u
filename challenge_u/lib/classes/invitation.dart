import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Invitation {
  String challengeId;
  String authorId;

  Invitation(
    this.challengeId,
    this.authorId,
  );

  Invitation formMap(Map<String, dynamic> map) {
    return Invitation(
      map['challengeId'],
      map['authorId'],
    );
  }

  static Stream<List<Map<String, dynamic>>> readInvitations() {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('invitations')
        .snapshots()
        .map(
          (invitations) => invitations.docs
              .map((invitationsFromUser) => {
                    invitationsFromUser.id: invitationsFromUser.data()['id'] ??
                        invitationsFromUser.data()['count']
                  })
              .toList(),
        );
  }

  static void deleteInvitation(String author, String challengeId) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('invitations')
        .doc(author)
        .update({
      'id': FieldValue.arrayRemove([challengeId]),
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('invitations')
        .doc('count')
        .update({
      'count': FieldValue.increment(-1),
    });
  }
}
