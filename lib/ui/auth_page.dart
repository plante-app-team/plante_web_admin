import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:plante/model/user_params.dart';
import 'package:plante/model/user_params_controller.dart';
import 'package:plante/outside/backend/backend.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:plante_web_admin/google_authorizer.dart';
import 'package:plante/l10n/strings.dart';

class AuthPage extends StatefulWidget {
  final Function() doneCallback;

  AuthPage(this.doneCallback);

  @override
  _AuthPageState createState() => _AuthPageState(doneCallback);
}

class _AuthPageState extends State<AuthPage>
    implements UserParamsControllerObserver {
  final _backend = GetIt.I.get<Backend>();
  final _userParamsController = GetIt.I.get<UserParamsController>();
  UserParams? _user;

  final Function() doneCallback;
  bool loading = false;

  _AuthPageState(this.doneCallback);

  @override
  void initState() {
    super.initState();
    _user = _userParamsController.cachedUserParams;
    _userParamsController.addObserver(this);
  }

  @override
  void dispose() {
    _userParamsController.removeObserver(this);
    super.dispose();
  }

  @override
  void onUserParamsUpdate(UserParams? userParams) {
    setState(() {
      _user = userParams;
      if (_user != null) {
        doneCallback.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      if (loading) CircularProgressIndicator(),
      OutlinedButton(
          child: Text(context.strings.web_auth_page_sign_in_with_google),
          onPressed: () async {
            try {
              setState(() {
                loading = true;
              });
              final googleAccount = await GoogleAuthorizer.auth();
              final deviceId = await PlatformDeviceId.getDeviceId;
              final deviceIdEncoded = base64Encode(deviceId!.codeUnits);
              var resp = await _backend.customGet("login_user/", {
                "googleIdToken": googleAccount.idToken,
                "deviceId": deviceIdEncoded
              });

              if (kDebugMode) {
                final json = jsonDecode(resp.body);
                if (json["error"] == "not_registered") {
                  await _backend.customGet("register_user/", {
                    "googleIdToken": googleAccount.idToken,
                    "deviceId": deviceIdEncoded,
                    "userName": "local always moderator"
                  });
                  resp = await _backend.customGet("login_user/", {
                    "googleIdToken": googleAccount.idToken,
                    "deviceId": deviceIdEncoded
                  });
                }
              }

              final user = UserParams.fromJson(jsonDecode(resp.body));
              if (user != null && (user.userGroup ?? 1) < 3) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(context
                        .strings.web_auth_page_error_user_is_not_moderator)));
                return;
              }
              _userParamsController.setUserParams(user);
              doneCallback.call();
            } finally {
              setState(() {
                loading = false;
              });
            }
          }),
    ]));
  }
}
