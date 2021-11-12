import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:plante/outside/backend/backend.dart';
import 'package:plante/l10n/strings.dart';
import 'package:plante_web_admin/backend_extensions.dart';

class ManageUsersPage extends StatefulWidget {
  @override
  _ManageUsersPageState createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage> {
  var _loading = false;
  final _userIdController = TextEditingController();
  final _backend = GetIt.I.get<Backend>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.only(left: 100, right: 100),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText:
                            context.strings.web_manage_users_page_user_id,
                      ),
                      controller: _userIdController,
                    ),
                    SizedBox(height: 50),
                    OutlinedButton(
                        child: Text(
                            context.strings.web_manage_users_page_delete_user),
                        onPressed: deleteUser),
                  ]),
            )));
  }

  void deleteUser() {
    final deletedUserId = _userIdController.text;

    showDialog<void>(
        context: context,
        builder: (BuildContext context) => StatefulBuilder(
            builder: (context, setState) => AlertDialog(
                  title: Row(children: [
                    if (_loading) CircularProgressIndicator(),
                    Text(context.strings
                        .web_manage_users_page_user_deletion_dialog_title)
                  ]),
                  content: Text(
                      context.strings.web_manage_users_page_deletion_dialog_q),
                  actions: <Widget>[
                    TextButton(
                      child: Text(context.strings
                          .web_manage_users_page_deletion_dialog_positive),
                      onPressed: () async {
                        setState(() {
                          _loading = true;
                        });
                        try {
                          final recordResp =
                              await _backend.recordCustomModerationAction(
                                  'User deletion: $deletedUserId');
                          if (recordResp.isErr) {
                            throw Exception(
                                'Backend error: ${recordResp.unwrapErr()}');
                          }
                          final resp = await _backend.customGet(
                              "delete_user/", {"userId": deletedUserId});
                          final json = jsonDecode(resp.body);
                          if (json["result"] == "ok") {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(context.strings
                                    .web_manage_users_page_user_deleted)));
                            _userIdController.clear();
                          } else if (json["error"] == "user_not_found") {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(context.strings
                                    .web_manage_users_page_user_not_found)));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(context.strings
                                    .web_manage_users_page_error_occurred)));
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(context.strings
                                  .web_manage_users_page_error_occurred)));
                        } finally {
                          setState(() {
                            _loading = false;
                          });
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )));
  }
}
