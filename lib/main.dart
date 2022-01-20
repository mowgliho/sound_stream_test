import 'package:sound_stream_test/homepage.dart';
import 'package:flutter/material.dart' hide Feedback;

void main() async {
  runApp(Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sound Stream Test',
      home: Homepage(),
    );
  }
}
