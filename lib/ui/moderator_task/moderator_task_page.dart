import 'package:flutter/material.dart';
import 'package:plante_web_admin/ui/moderator_task/_initial_page.dart';

class ModeratorTaskPage extends StatefulWidget {
  @override
  _ModeratorTaskPageState createState() => _ModeratorTaskPageState();
}

class _ModeratorTaskPageState extends State<ModeratorTaskPage> {
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
    return realPage!;
  }
}
