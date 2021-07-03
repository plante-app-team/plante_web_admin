import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:plante/model/user_params.dart';
import 'package:plante/model/user_params_controller.dart';

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
    final username = _user?.name ?? "безымянный модератор";
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Привет, $username! "),
          Text("Твой ID: "),
          SelectableText(_user?.backendId ?? "")
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
