import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:plante/model/user_params.dart';
import 'package:plante/model/user_params_controller.dart';
import 'package:plante/l10n/strings.dart';

class MainActionsWidget extends StatefulWidget {
  const MainActionsWidget({Key? key}) : super(key: key);

  @override
  _MainActionsWidgetState createState() => _MainActionsWidgetState();
}

class _MainActionsWidgetState extends State<MainActionsWidget>
    implements UserParamsControllerObserver {
  final _userParamsController = GetIt.I.get<UserParamsController>();
  UserParams? _user;

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
    final username = _user?.name ??
        context.strings.web_main_actions_widget_nameless_moderator;
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("${context.strings.web_main_actions_widget_hello} $username! "),
          Text(context.strings.web_main_actions_widget_your_id),
          SelectableText(_user?.backendId ?? "")
        ]),
        SizedBox(height: 50),
        OutlinedButton(
            child: Text(
                context.strings.web_main_actions_widget_list_moderation_tasks),
            onPressed: () {
              Navigator.pushNamed(context, '/list_moderator_tasks');
            }),
        SizedBox(height: 10),
        OutlinedButton(
            child: Text(
                context.strings.web_main_actions_widget_next_moderation_task),
            onPressed: () {
              Navigator.pushNamed(context, '/next_moderator_task');
            }),
        SizedBox(height: 10),
        OutlinedButton(
            child: Text(
                context.strings.web_main_actions_widget_next_users_management),
            onPressed: () {
              Navigator.pushNamed(context, '/manage_users');
            }),
      ]),
    );
  }
}
