import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:plante/base/date_time_extensions.dart';
import 'package:plante/model/user_params.dart';
import 'package:plante/outside/backend/backend.dart';
import 'package:plante/ui/base/components/button_filled_plante.dart';
import 'package:plante/ui/base/text_styles.dart';
import 'package:plante_web_admin/model/moderator_task.dart';
import 'package:plante_web_admin/ui/moderation_actions/latest_moderator_actions_page.dart';
import 'package:plante_web_admin/ui/moderation_actions/moderation_action_list_item.dart';
import 'package:plante_web_admin/ui/moderation_actions/moderation_action_page.dart';
import 'package:plante/l10n/strings.dart';

class AllLatestModerationActionsPage extends StatefulWidget {
  static const HOW_MANY_DAYS_CONSIDERED_LATEST = 30;
  const AllLatestModerationActionsPage({Key? key}) : super(key: key);

  @override
  _AllLatestModerationActionsPageState createState() =>
      _AllLatestModerationActionsPageState();
}

class _AllLatestModerationActionsPageState
    extends State<AllLatestModerationActionsPage> {
  final _backend = GetIt.I.get<Backend>();
  Map<UserParams, List<ModeratorTask>>? _tasks;
  List<ModeratorTask>? _unknownResolverTasks;

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  void _initAsync() async {
    const days = AllLatestModerationActionsPage.HOW_MANY_DAYS_CONSIDERED_LATEST;
    final since =
        DateTime.now().subtract(const Duration(days: days)).secondsSinceEpoch;
    var resp = await _backend.customGet('/moderators_activities/', {
      'since': since.toString(),
    });
    var json = jsonDecode(resp.body);

    final tasksWithUsersIds = <String, List<ModeratorTask>>{};
    for (final taskJson in json['result']) {
      final task = ModeratorTask.fromJson(taskJson);
      final resolver = task.resolver ?? '';
      if (!tasksWithUsersIds.containsKey(resolver)) {
        tasksWithUsersIds[resolver] = [];
      }
      tasksWithUsersIds[resolver]!.add(task);
    }

    final usersIds = tasksWithUsersIds.keys.where((e) => e.isNotEmpty).toList();
    if (usersIds.isEmpty) {
      setState(() {
        _tasks = const {};
        _unknownResolverTasks = const [];
      });
      return;
    }
    resp = await _backend.customGet('/users_data/', {
      'ids': usersIds,
    });
    json = jsonDecode(resp.body);
    final tasks = <UserParams, List<ModeratorTask>>{};
    for (final userJson in json['result']) {
      final user = UserParams.fromJson(userJson)!;
      tasks[user] = tasksWithUsersIds[user.backendId]!;
    }

    setState(() {
      _tasks = tasks;
      _unknownResolverTasks = tasksWithUsersIds[''] ?? const [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: _tasks == null
                ? CircularProgressIndicator()
                : SingleChildScrollView(
                    child: SizedBox(
                        width: 700,
                        child: Column(
                          children: [
                            Text(
                                context.strings
                                    .web_all_latest_moderation_actions_page_title,
                                style: TextStyles.headline3),
                            const SizedBox(height: 16),
                            ..._moderatorsButtons(),
                            const SizedBox(height: 16),
                            Text(
                                context.strings
                                    .web_all_latest_moderation_actions_page_latest_activity,
                                style: TextStyles.headline3),
                            ..._allLatestActivity(),
                          ],
                        )))));
  }

  List<Widget> _moderatorsButtons() {
    final tasks = _tasks!;
    final users = tasks.keys.toList();
    users.sort((lhs, rhs) {
      final lhsName = lhs.name ?? '';
      final rhsName = rhs.name ?? '';
      return lhsName.compareTo(rhsName);
    });
    final usersTasksCount = <String, int>{};
    for (final keyVal in tasks.entries) {
      usersTasksCount[keyVal.key.name ?? ''] = keyVal.value.length;
    }
    final buttons = <Widget>[];
    final createButton = (String name, String moderatorId, int count) {
      return Column(children: [
        SizedBox(
          width: 400,
          child: ButtonFilledPlante.withText('$name: $count', onPressed: () {
            LatestModeratorActionsPage.openFor(context, moderatorId);
          }),
        ),
        SizedBox(height: 8)
      ]);
    };
    for (final user in users) {
      buttons.add(createButton(user.name ?? user.requireBackendID(),
          user.requireBackendID(), usersTasksCount[user.name] ?? -1));
    }
    return buttons;
  }

  List<Widget> _allLatestActivity() {
    final allTasks = <ModeratorTask>[];
    for (final tasks in _tasks!.values) {
      allTasks.addAll(tasks);
    }
    allTasks.addAll(_unknownResolverTasks!);
    allTasks.sort((lhs, rhs) => rhs.resolutionTime! - lhs.resolutionTime!);

    final moderators = <String, String>{};
    for (final user in _tasks!.keys) {
      moderators[user.backendId!] = user.name ?? user.requireBackendID();
    }

    final result = <Widget>[];
    for (final task in allTasks) {
      String moderator = context.strings.web_global_unknown_user;
      if (task.resolver != null && moderators[task.resolver!] != null) {
        moderator = moderators[task.resolver!]!;
      }
      result.add(ModerationActionListItem(
          moderator: moderator,
          task: task,
          clickCallback: (task) {
            ModerationActionPage.openFor(context, task.id.toString());
          }));
    }
    return result;
  }
}
