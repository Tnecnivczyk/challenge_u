import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserChallengeU {
  final String id;
  final String username;
  final String email;
  final DateTime birthday;
  late String biography;

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
    return user;
  }

  static Future<UserChallengeU> readUser() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    return UserChallengeU.fromMap(snapshot.data()!);
  }

  static void createProfilePicture(XFile? imageFile) async {
    await FirebaseStorage.instance
        .ref(FirebaseAuth.instance.currentUser!.uid)
        .child('profilepictures/${imageFile!.name}')
        .putFile(File(imageFile.path));
  }

  static void deleteProfilePicture() {}

  static Future<ListResult> readProfilePicture() async {
    return await FirebaseStorage.instance
        .ref(FirebaseAuth.instance.currentUser!.uid)
        .child('profilepictures')
        .listAll();
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

  static Future<List<String>> readFirends() async {
    List<String> friends = [];
    final userId = await FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('friends')
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((doc) {
        friends.add(doc['friendId']);
      });
    });
    return friends;
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

  static Future<void> deleteFollower(String friendId) async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(friendId)
        .collection('follower')
        .doc(id)
        .delete();
  }
}
