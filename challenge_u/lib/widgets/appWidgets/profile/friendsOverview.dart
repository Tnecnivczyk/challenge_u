import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FreindsOverview extends StatelessWidget {
  const FreindsOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friends"),
      ),
      // The main content of the app, shown in a Column widget.
      body: PageView(children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(5),
          ),
        ),
      ]),
    );
  }
}
