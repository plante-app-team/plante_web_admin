import 'package:flutter/material.dart';
import 'package:plante_web_admin/model/user.dart';

class MainActionsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final username = User.current.name.isNotEmpty ? User.current.name : "безымянный модератор";
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Привет, $username! "),
          Text("Твой ID: "),
          SelectableText(User.current.backendId)
        ]),

        SizedBox(height: 50),

        OutlinedButton(
            child: Text("Следующая задача модерации"),
            onPressed: () {
              Navigator.pushNamed(context, '/next_moderator_task');
            }),

        SizedBox(height: 10),

        OutlinedButton(
            child: Text("Управление пользователями"),
            onPressed: () {
              Navigator.pushNamed(context, '/manage_users');
            }),
      ]),
    );
  }
}
