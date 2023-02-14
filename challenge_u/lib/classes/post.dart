import 'package:challenge_u/classes/training.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Post {
  String get imageUrl => '';

  static Stream<List<Post>> readPosts() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('posts')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => Post.fromMap(
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  static Post fromMap(Map<String, dynamic> map) {
    return Post();
  }
}
