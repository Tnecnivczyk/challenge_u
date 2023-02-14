import 'dart:async';
import 'dart:math';

import 'package:challenge_u/classes/Utils.dart';
import 'package:challenge_u/main.dart';
import 'package:challenge_u/widgets/appWidgets/overview/overview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../classes/userChallengeU.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool _isEmailVerified = false;
  bool canResent = false;
  Timer? timer;
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      if (!_isEmailVerified) {
        sendVerifyEmail();

        timer = Timer.periodic(Duration(seconds: 3), (_) => checkEmailStatus());
      }
    });
  }

  Future checkEmailStatus() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      _isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (_isEmailVerified) {
      timer?.cancel();
    }
  }

  Future sendVerifyEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() {
        canResent = false;
      });
      await Future.delayed(Duration(seconds: 5));
      setState(() {
        canResent = true;
      });
    } on FirebaseAuthException catch (e) {
      Utils.showErrorSnackBar(e.message, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isEmailVerified
        ? const Overview()
        : Scaffold(
            appBar: AppBar(
              title: const Text("Challenge U"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Please verify your email',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton.icon(
                    onPressed: canResent ? sendVerifyEmail : () {},
                    icon: const Icon(
                      Icons.email,
                      size: 20,
                    ),
                    label: Text('Resent Email'),
                  ),
                  TextButton(
                      onPressed: () => FirebaseAuth.instance.signOut(),
                      child: Text('Cancel'))
                ],
              ),
            ),
          );
  }
}
