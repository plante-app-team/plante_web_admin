import 'package:flutter/material.dart';
import 'package:plante_web_admin/ui/main_page.dart';
import 'package:plante_web_admin/model/user.dart';

void main() async {
  await User.staticInit();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Untitled Vegan App Web Admin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}
