import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:plante/model/user_params.dart';
import 'package:plante/model/user_params_controller.dart';
import 'package:plante/ui/base/lang_code_holder.dart';
import 'package:plante_web_admin/ui/auth_page.dart';
import 'package:plante_web_admin/ui/main_actions_widget.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    implements UserParamsControllerObserver {
  final _userParamsController = GetIt.I.get<UserParamsController>();
  UserParams? _user;
  bool _initedLang = false;

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
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initedLang) {
      GetIt.I.get<LangCodeHolder>().langCode =
          Localizations.localeOf(context).languageCode;
      _initedLang = true;
    }
    return Scaffold(
        body: Container(
            child: _user == null
                ? AuthPage(() {
                    setState(() {});
                  })
                : MainActionsWidget()));
  }
}
