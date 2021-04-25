import 'package:flutter/material.dart';
import 'package:plante_web_admin/ui/auth_page.dart';
import 'package:plante_web_admin/backend.dart';
import 'package:plante_web_admin/ui/main_actions_widget.dart';
import 'package:plante_web_admin/model/user.dart';

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
            : MainActionsWidget()
    ));
  }
}
