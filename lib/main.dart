import 'package:flutter/material.dart';
import 'todo_page.dart';
import 'sign_in.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final key = GlobalKey();
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignIn(),
    );
  }
}
