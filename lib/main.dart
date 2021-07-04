import 'package:flutter/material.dart';
import 'package:plante_web_admin/di.dart';
import 'package:plante_web_admin/ui/main_page.dart';
import 'package:plante_web_admin/ui/manage_users/manage_users_page.dart';
import 'package:plante_web_admin/ui/moderator_task/list/moderator_tasks_list_page.dart';
import 'package:plante_web_admin/ui/moderator_task/list/unassigned_moderator_task_page.dart';
import 'package:plante_web_admin/ui/moderator_task/page/auto_moderator_task_page.dart';
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
        '/list_moderator_tasks': (context) => Builder(builder: (b) {
              return ModeratorTasksListPage();
            }),
        '/next_moderator_task': (context) => Builder(builder: (b) {
              return AutoModeratorTaskPage();
            }),
        '/manage_users': (context) => Builder(builder: (b) {
              return ManageUsersPage();
            }),
      },
      onGenerateRoute: (settings) {
        if (settings.name!.contains("/unassigned_moderator_task")) {
          final settingsUri = Uri.parse(settings.name ?? '');
          final taskId = settingsUri.queryParameters['taskId']!;
          return MaterialPageRoute(
            settings: settings,
            builder: (context) {
              return UnassignedModeratorTaskPage(taskId);
            },
          );
        }
        return null;
      },
    );
  }
}
