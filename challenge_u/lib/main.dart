import 'package:challenge_u/classes/Utils.dart';
import 'package:challenge_u/widgets/logIn.dart';
import 'package:challenge_u/widgets/overview.dart';
import 'package:challenge_u/widgets/signInSignUpManager.dart';
import 'package:challenge_u/widgets/verifyEmail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      navigatorKey: navigatorKey,
      title: 'Challenge U',
      theme: ThemeData(
        textTheme: ThemeData.light().textTheme.copyWith(
            headline6: const TextStyle(
              fontFamily: "Quicksand",
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            headline5: const TextStyle(
              fontFamily: "Quicksand",
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
            bodyText2: const TextStyle(
                fontFamily: "OpenSans",
                fontSize: 14,
                color: Colors.black), // style for body text
            caption: const TextStyle(
                fontFamily: "OpenSans",
                fontSize: 12,
                color: Colors.grey)), // style for captions
        buttonTheme: ButtonThemeData(
            buttonColor: Colors.lightGreen.shade300,
            textTheme: ButtonTextTheme.primary),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.teal,
          primaryColorDark: Colors.teal[800],
          accentColor: Colors.lightGreen.shade300,
          backgroundColor: Colors.white,
          cardColor: Colors.grey[50],
          errorColor: Colors.red[400],
        ),
      ),
      home: MyHomePage(),
    );
  }
}

// The main widget of the app, representing the homepage.
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const VerifyEmail();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong'),
            );
          } else {
            return signInSignUpManager();
          }
        },
      ),
      // The FloatingActionButton to add a new training.
    );
  }
}
