import 'package:flutter/material.dart';
import 'package:plante_web_admin/ui/moderator_task/page/initial_page.dart';

class AutoModeratorTaskPage extends StatefulWidget {
  @override
  _AutoModeratorTaskPageState createState() => _AutoModeratorTaskPageState();
}

class _AutoModeratorTaskPageState extends State<AutoModeratorTaskPage> {
  Widget? realPage;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (realPage == null) {
      realPage = InitialPage((newPage) {
        setState(() {
          realPage = newPage;
        });
      });
    }
    return Scaffold(
      body: realPage!,
    );
  }
}
