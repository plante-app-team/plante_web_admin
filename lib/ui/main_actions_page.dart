import 'package:flutter/material.dart';

class MainActionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        OutlinedButton(
            child: Text("Следующая задача модерации"),
            onPressed: () {
              Navigator.pushNamed(context, '/next_moderator_task');
            })
      ]),
    );
  }
}
