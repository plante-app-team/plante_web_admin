import 'package:flutter/material.dart';
import 'package:plante_web_admin/di.dart';
import 'package:plante_web_admin/ui/main_page.dart';
import 'package:plante_web_admin/ui/manage_users/manage_users_page.dart';
import 'package:plante_web_admin/ui/moderator_task/moderator_task_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  initDI();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plante Web Admin',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
        '/next_moderator_task': (context) => Builder(builder: (b) {
              return ModeratorTaskPage();
            }),
        '/manage_users': (context) => Builder(builder: (b) {
              return ManageUsersPage();
            }),
      },
    );
  }
}
