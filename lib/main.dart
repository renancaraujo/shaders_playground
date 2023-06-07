import 'package:flutter/material.dart';
import 'package:shaders_playground/playground_scrollable.dart';
import 'package:shaders_playground/raw_playground.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My shader playground',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        // body: ShadersPlayground(),
        body: ShadersRawPlayground(),
      ),
    );
  }
}
