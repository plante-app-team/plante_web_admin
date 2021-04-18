import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:platform_device_id/platform_device_id.dart';
import 'package:untitled_vegan_app_web_admin/constants.dart';

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
            final resp = await http.get(Uri.http(
                BACKEND_ADDRESS,
                'login_user/',
                {"googleIdToken": googleAccount.idToken,
                  "deviceId": deviceIdEncoded}));

            final json = jsonDecode(resp.body);
            final name = json['name'];
            final id = json['user_id'];
            final backendToken = json['client_token'];
            User.currentNullable = User(backendToken, id, name);
            doneCallback.call();
          }),
    );
  }
}
