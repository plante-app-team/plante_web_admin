import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:plante_web_admin/backend.dart';

class ManageUsersPage extends StatefulWidget {
  @override
  _ManageUsersPageState createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage> {
  var loading = false;
  final userIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.only(left: 100, right: 100),
            child: Center(child:
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: "ID пользователя",
                  ),
                  controller: userIdController,
                ),

                SizedBox(height: 50),

                OutlinedButton(
                    child: Text("Удалить пользователя"),
                    onPressed: deleteUser),
              ]),
            ))
    );
  }

  void deleteUser() {
    final deletedUserId = userIdController.text;

    showDialog<void>(
        context: context,
        builder: (BuildContext context) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Row(children: [
              if (loading) CircularProgressIndicator(),
              Text("Удаление пользователя")
            ]),
            content: Text("Действительно удалить пользователя $deletedUserId?\n"
                "Это действие невозможно отменить"),
            actions: <Widget>[
              TextButton(
                child: Text("Да!"),
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  try {
                    final resp = await Backend.get("delete_user/", {
                      "userId": deletedUserId
                    });
                    final json = jsonDecode(resp.body);
                    if (json["result"] == "ok") {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Пользователь удалён")));
                      userIdController.clear();
                    } else if (json["error"] == "user_not_found") {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Такой пользователь не найден")));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Ошибочка")));
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Ошибочка")));
                  } finally {
                    setState(() {
                      loading = false;
                    });
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          )));
  }
}
