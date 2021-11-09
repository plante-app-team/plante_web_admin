import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:plante/model/user_params.dart';
import 'package:plante/outside/backend/backend.dart';
import 'package:plante/ui/base/text_styles.dart';
import 'package:plante_web_admin/model/moderator_task.dart';
import 'package:plante_web_admin/ui/moderation_actions/all_latest_moderation_actions_page.dart';
import 'package:plante/base/date_time_extensions.dart';
import 'package:plante_web_admin/ui/moderation_actions/moderation_action_list_item.dart';
import 'package:plante_web_admin/ui/moderation_actions/moderation_action_page.dart';
import 'package:plante/l10n/strings.dart';

class LatestModeratorActionsPage extends StatefulWidget {
  static const NAME = '/latest_moderator_actions';
  final String moderatorId;
  LatestModeratorActionsPage.createFor(Uri uri)
      : moderatorId = uri.queryParameters['moderatorId']!;

  static Future<void> openFor(BuildContext context, String moderatorId) async {
    await Navigator.pushNamed(context, '$NAME?moderatorId=$moderatorId');
  }

  @override
  _LatestModeratorActionsPageState createState() =>
      _LatestModeratorActionsPageState();
}

class _LatestModeratorActionsPageState
    extends State<LatestModeratorActionsPage> {
  final _backend = GetIt.I.get<Backend>();
  List<ModeratorTask>? _tasks;
  UserParams? _moderator;

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

    final tasks = <ModeratorTask>[];
    for (final taskJson in json['result']) {
      final task = ModeratorTask.fromJson(taskJson);
      if (task.resolver == widget.moderatorId) {
        tasks.add(task);
      }
    }
    tasks.sort((lhs, rhs) => rhs.resolutionTime! - lhs.resolutionTime!);

    resp = await _backend.customGet('/users_data/', {
      'ids': [widget.moderatorId],
    });
    json = jsonDecode(resp.body);
    final user = UserParams.fromJson(json['result'][0])!;

    setState(() {
      _tasks = tasks;
      _moderator = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: _tasks == null ? CircularProgressIndicator() : _content()));
  }

  Widget _content() {
    return SingleChildScrollView(
        child: SizedBox(
            width: 700,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(_moderatorName(), style: TextStyles.headline1),
                const SizedBox(height: 16),
                Text(context.strings.web_latest_moderator_actions_page,
                    style: TextStyles.headline2),
                const SizedBox(height: 8),
                ..._latestActions(),
              ],
            )));
  }

  String _moderatorName() {
    final String name;
    if (_moderator!.name != null) {
      name = '${_moderator!.name} (${_moderator!.requireBackendID()})';
    } else {
      name = _moderator!.requireBackendID();
    }
    return name;
  }

  List<Widget> _latestActions() {
    final result = <Widget>[];
    for (final task in _tasks!) {
      result.add(ModerationActionListItem(
          task: task,
          clickCallback: (task) {
            ModerationActionPage.openFor(context, task.id.toString());
          }));
    }
    return result;
  }
}
