import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:openfoodfacts/utils/HttpHelper.dart';
import 'package:plante/outside/backend/backend.dart';
import 'package:plante_web_admin/di.dart';
import 'package:plante_web_admin/off_http_interceptor.dart';
import 'package:plante_web_admin/ui/main_page.dart';
import 'package:plante_web_admin/ui/manage_products/manage_product_page.dart';
import 'package:plante_web_admin/ui/manage_users/manage_users_page.dart';
import 'package:plante_web_admin/ui/map/recently_added_products_map_page.dart';
import 'package:plante_web_admin/ui/map/social_media_added_products_map_page.dart';
import 'package:plante_web_admin/ui/moderator_task/list/moderator_tasks_categories_page.dart';
import 'package:plante_web_admin/ui/moderator_task/list/moderator_tasks_list_page.dart';
import 'package:plante_web_admin/ui/moderator_task/list/unassigned_moderator_task_page.dart';
import 'package:plante_web_admin/ui/moderator_task/page/auto_moderator_task_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  initDI();
  HttpHelper.interceptor = OffHttpInterceptor(GetIt.I.get<Backend>());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [GetIt.I.get<RouteObserver<ModalRoute>>()],
      title: 'Plante Web Admin',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
        ModeratorTasksCategoriesPage.NAME: (context) => Builder(builder: (b) {
              return ModeratorTasksCategoriesPage();
            }),
        '/next_moderator_task': (context) => Builder(builder: (b) {
              return AutoModeratorTaskPage();
            }),
        '/manage_products': (context) => Builder(builder: (b) {
              return ManageProductPage();
            }),
        '/manage_users': (context) => Builder(builder: (b) {
              return ManageUsersPage();
            }),
        '/recently_added_products_map': (context) => Builder(builder: (b) {
              return RecentlyAddedProductsMapPage();
            }),
        '/social_media_added_products_map': (context) => Builder(builder: (b) {
              return SocialMediaAddedProductsMapPage();
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
        } else if (settings.name!.contains(ModeratorTasksListPage.NAME)) {
          final settingsUri = Uri.parse(settings.name ?? '');
          return MaterialPageRoute(
            settings: settings,
            builder: (context) {
              return ModeratorTasksListPage.createFor(settingsUri);
            },
          );
        }
        return null;
      },
    );
  }
}
