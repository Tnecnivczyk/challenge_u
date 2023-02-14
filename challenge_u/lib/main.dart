import 'package:challenge_u/classes/Utils.dart';
import 'package:challenge_u/widgets/loginWidgets/signInSignUpManager.dart';
import 'package:challenge_u/widgets/loginWidgets/verifyEmail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
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
      themeMode: ThemeMode.light,
      theme: FlexColorScheme.light(scheme: FlexScheme.money, useMaterial3: true)
          .toTheme,
      darkTheme:
          FlexColorScheme.dark(scheme: FlexScheme.money, useMaterial3: true)
              .toTheme,
      home: MyHomePage(),
    );
  }
}

// The main widget of the app, representing the homepage.
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const VerifyEmail();
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        } else {
          return signInSignUpManager();
        }
      },
    );
  }
}
