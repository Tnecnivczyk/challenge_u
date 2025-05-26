import 'dart:io';

import 'package:challenge_u/classes/participant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class UserChallengeU {
  final String id;
  final String username;
  final String email;
  final DateTime birthday;
  late String biography;
  String realName = "";

  UserChallengeU(this.id, this.username, this.email, this.birthday) {
    biography = '';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'birthday': birthday.toString(),
      'biography': biography,
      'realName': realName,
    };
  }

  static UserChallengeU fromMap(Map<String, dynamic> map) {
    final user = UserChallengeU(
      map['id'],
      map['username'],
      map['email'],
      DateTime.parse(map['birthday']),
    );
    user.biography = map['biography'];
    user.realName = map['realName'];
    return user;
  }

  static Future<UserChallengeU> readUser(String userId) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return UserChallengeU.fromMap(snapshot.data()!);
  }

  static void createProfilePicture(XFile? imageFile) async {
    await FirebaseStorage.instance
        .ref(FirebaseAuth.instance.currentUser!.uid)
        .child('profilepictures/${imageFile!.name}')
        .putFile(File(imageFile.path));
  }

  static void deleteProfilePicture(String fullPath) {
    FirebaseStorage.instance.ref().child(fullPath).delete();
  }

  static Future<ListResult> readProfilePicture(String userId) async {
    ListResult res = await FirebaseStorage.instance
        .ref(userId)
        .child('profilepictures')
        .listAll();

    if (res.items.isEmpty) {
      return FirebaseStorage.instance
          .ref('default')
          .child('profilepicture')
          .listAll();
    }
    return res;
  }

  static Future<UserChallengeU>? readUsersByName(String name) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: name)
        .get()
        .then((querySnapshot) {
      try {
        final doc = querySnapshot.docs[0];
        return UserChallengeU.fromMap(doc.data());
      } catch (e) {
        throw FirebaseException(
            plugin: 'Firestore', message: 'User does not exist');
      }
    });
  }

  static Future<List<String>> readFriend() async {
    List<String> friends = [];
    final userId = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('friends')
        .get()
        .then((snapshot) {
      for (var doc in snapshot.docs) {
        friends.add(doc['friendId']);
      }
    });
    return friends;
  }

  static Stream<List<String>> readFriends() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('friends')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((friend) {
        return friend['friendId'].toString();
      }).toList();
    });
  }

  static Future<void> createFriend(String friendId) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('friends')
        .doc(friendId)
        .set({'friendId': friendId});
  }

  static Future<void> deleteFriend(String friendId) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('friends')
        .doc(friendId)
        .delete();
  }

  static Future<void> createFollower(String friendId) async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(friendId)
        .collection('follower')
        .doc(id)
        .set({'followerId': id});
  }

  static Stream<List<String>> readFollower() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('follower')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((friend) {
        return friend['followerId'].toString();
      }).toList();
    });
  }

  static Future<void> deleteFollower(String friendId) async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(friendId)
        .collection('follower')
        .doc(id)
        .delete();
  }

  static Future<void> joinChallenge(String challengeId) async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    String username = await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .snapshots()
        .first
        .then((value) => value['username']);
    Participant participant = Participant(id, 0, 0, username, 0);
    await FirebaseFirestore.instance
        .collection('challenges')
        .doc(challengeId)
        .collection('participants')
        .doc(id)
        .set(participant.toMap());
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('challenges')
        .doc(challengeId)
        .set({'challengeId': challengeId});
  }

  static Stream<List<String>> readChallengeIds() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('challenges')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map(
              (doc) => doc.data()['challengeId'].toString(),
            )
            .toList());
  }

  static Future<void> setPrimaryChallenge(String challengeId) async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set({'primaryChallenge': challengeId});
  }

  static Future<String> readPrimaryChallenge() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((snapshot) {
      return snapshot.data()!['primaryChallenge'];
    });
  }

  static Future<Map<String, UserChallengeU>> userData(String userId) async {
    ListResult res = await FirebaseStorage.instance
        .ref(userId)
        .child('profilepictures')
        .listAll();

    if (res.items.isEmpty) {
      res = await FirebaseStorage.instance
          .ref('default')
          .child('profilepicture')
          .listAll();
    }

    return {
      await res.items.first.getDownloadURL(): await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get()
          .then((snapshot) {
        return UserChallengeU.fromMap(snapshot.data()!);
      })
    };
  }
}
