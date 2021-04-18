import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:platform_device_id/platform_device_id.dart';
import 'package:untitled_vegan_app_web_admin/backend.dart';

import 'package:untitled_vegan_app_web_admin/google_authorizer.dart';
import 'package:untitled_vegan_app_web_admin/user.dart';

class AuthPage extends StatelessWidget {
  final Function() doneCallback;

  AuthPage(this.doneCallback);

  @override
  Widget build(BuildContext context) {
    if (User.currentNullable != null) {
      doneCallback.call();
    }
    return Center(child:
      OutlinedButton(
          child: Text("Войти через Google"),
          onPressed: () async {
            final googleAccount = await GoogleAuthorizer.auth();
            final deviceId = await PlatformDeviceId.getDeviceId;
            final deviceIdEncoded = base64Encode(deviceId!.codeUnits);
            final resp = await Backend.get(
                'login_user/',
                {"googleIdToken": googleAccount.idToken,
                  "deviceId": deviceIdEncoded});

            User.currentNullable = User.fromJson(jsonDecode(resp.body));
            doneCallback.call();
          }),
    );
  }
}
