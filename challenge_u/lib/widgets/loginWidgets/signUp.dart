import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../classes/Utils.dart';
import '../../classes/userChallengeU.dart';
import '../../main.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final VoidCallback onClickLogIn;
  SignUp(this.onClickLogIn);
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();
  DateTime _birthday = DateTime.now();

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    if (passwordController.text == confirmPasswordController.text) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        _createUser();
      } on FirebaseAuthException catch (e) {
        Utils.showErrorSnackBar(e.message, context);
      }
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  void _datePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((datum) {
      if (datum == null) {
        return;
      }
      setState(() {
        _birthday = datum;
      });
    });
  }

  void _createUser() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final docUser =
        FirebaseFirestore.instance.collection('users').doc(firebaseUser?.uid);
    final user = UserChallengeU(
        firebaseUser!.uid,
        _usernameController.text.trim(),
        firebaseUser.email.toString(),
        _birthday);
    await docUser.set(user.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Challenge U"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              TextFormField(
                controller: _usernameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (email) => null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? 'Enter a valid email'
                        : null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Password'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 8
                    ? 'Enter min. 8 characters'
                    : null,
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: confirmPasswordController,
                textInputAction: TextInputAction.done,
                decoration:
                    const InputDecoration(labelText: 'Confirm Password'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) =>
                    value != null && value != passwordController.text
                        ? 'Password doesn\'t match'
                        : null,
              ),
              TextField(
                decoration: InputDecoration(
                    labelText: DateFormat("dd.MM.yy").format(_birthday)),
              ),
              TextButton(
                onPressed: _datePicker,
                child: const Text(
                  "Choose other date",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: signUp,
                child: const Text('Create Account'),
              ),
              const SizedBox(
                height: 25,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'You already have an account? ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickLogIn,
                      text: 'Login here',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Theme.of(context).primaryColor),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
