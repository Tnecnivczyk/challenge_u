import 'dart:async';
import 'dart:math';

import 'package:challenge_u/classes/Utils.dart';
import 'package:challenge_u/main.dart';
import 'package:challenge_u/widgets/overview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isEmailVerified = false;
  bool canResent = false;
  Timer? timer;
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void initState() {
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      if (!isEmailVerified) {
        sendVerifyEmail();

        timer = Timer.periodic(Duration(seconds: 3), (_) => checkEmailStatus());
      }
    });
  }

  Future checkEmailStatus() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) {
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
      Utils.showSnackBar(e.message, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
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
