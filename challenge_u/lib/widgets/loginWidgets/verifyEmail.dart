import 'dart:async';

import 'package:challenge_u/classes/Utils.dart';
import 'package:challenge_u/widgets/appWidgets/overview/overview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


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

        timer = Timer.periodic(const Duration(seconds: 3), (_) => checkEmailStatus());
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
      await Future.delayed(const Duration(seconds: 5));
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
                    label: const Text('Resent Email'),
                  ),
                  TextButton(
                      onPressed: () => FirebaseAuth.instance.signOut(),
                      child: const Text('Cancel'))
                ],
              ),
            ),
          );
  }
}
