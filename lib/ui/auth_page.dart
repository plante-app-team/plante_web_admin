import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:platform_device_id/platform_device_id.dart';
import 'package:plante_web_admin/backend.dart';

import 'package:plante_web_admin/google_authorizer.dart';
import 'package:plante_web_admin/model/user.dart';

class AuthPage extends StatefulWidget {
  final Function() doneCallback;

  AuthPage(this.doneCallback);
  
  @override
  _AuthPageState createState() => _AuthPageState(doneCallback);
}

class _AuthPageState extends State<AuthPage> {
  final Function() doneCallback;
  bool loading = false;

  _AuthPageState(this.doneCallback);

  @override
  Widget build(BuildContext context) {
    if (User.currentNullable != null) {
      doneCallback.call();
    }
    return Center(child:
    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      if (loading) CircularProgressIndicator(),
      OutlinedButton(
          child: Text("Войти через Google"),
          onPressed: () async {
            try {
              setState(() {
                loading = true;
              });
              final googleAccount = await GoogleAuthorizer.auth();
              final deviceId = await PlatformDeviceId.getDeviceId;
              final deviceIdEncoded = base64Encode(deviceId!.codeUnits);
              var resp = await Backend.get(
                  "login_user/",
                  {"googleIdToken": googleAccount.idToken,
                    "deviceId": deviceIdEncoded});

              if (kDebugMode) {
                final json = jsonDecode(resp.body);
                if (json["error"] == "not_registered") {
                  await Backend.get(
                      "register_user/",
                      {"googleIdToken": googleAccount.idToken,
                        "deviceId": deviceIdEncoded,
                        "userName": "local always moderator"});
                  resp = await Backend.get(
                      "login_user/",
                      {"googleIdToken": googleAccount.idToken,
                        "deviceId": deviceIdEncoded});
                }
              }

              final user = User.fromJson(jsonDecode(resp.body));
              if (user != null && user.userGroup == 1) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(
                        "Пользователь не является модераторором")));
                return;
              }
              User.currentNullable = user;
              doneCallback.call();
            } finally {
              setState(() {
                loading = false;
              });
            }
          }),
    ])
    );
  }
}
