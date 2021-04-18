import 'package:flutter/material.dart';
import 'package:untitled_vegan_app_web_admin/auth_page.dart';
import 'package:untitled_vegan_app_web_admin/backend.dart';
import 'package:untitled_vegan_app_web_admin/user.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    Backend.unauthCallback = () {
      setState(() {
        User.currentNullable = null;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child:
        User.currentNullable == null
            ? AuthPage(() { setState((){}); })
            : Text("Yee haa! Hello, ${User.current.name}")
    ));
  }
}
