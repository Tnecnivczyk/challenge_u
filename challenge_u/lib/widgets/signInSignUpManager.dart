import 'package:challenge_u/widgets/logIn.dart';
import 'package:challenge_u/widgets/signUp.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class signInSignUpManager extends StatefulWidget {
  @override
  State<signInSignUpManager> createState() => _signInSignUpManagerState();
}

class _signInSignUpManagerState extends State<signInSignUpManager> {
  bool login = true;

  void toggle() {
    setState(() {
      login = !login;
    });
  }

  @override
  Widget build(BuildContext context) => login ? LogIn(toggle) : SignUp(toggle);
}
