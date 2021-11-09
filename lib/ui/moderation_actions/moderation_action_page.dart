import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:plante/model/user_params.dart';
import 'package:plante/outside/backend/backend.dart';
import 'package:plante/ui/base/text_styles.dart';
import 'package:plante_web_admin/model/moderator_task.dart';
import 'package:plante_web_admin/ui/components/linkify_url.dart';
import 'package:plante/outside/map/osm_element_type.dart';
import 'package:plante/l10n/strings.dart';

class ModerationActionPage extends StatefulWidget {
  static const NAME = '/moderation_action';
  final String taskId;
  ModerationActionPage.createFor(Uri uri)
      : taskId = uri.queryParameters['taskId']!;

  static Future<void> openFor(BuildContext context, String taskId) async {
    await Navigator.pushNamed(context, '$NAME?taskId=$taskId');
  }

  @override
  _ModerationActionPageState createState() => _ModerationActionPageState();
}

class _ModerationActionPageState extends State<ModerationActionPage> {
  final _backend = GetIt.I.get<Backend>();
  ModeratorTask? _task;
  String? _moderator;

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  void _initAsync() async {
    var resp = await _backend.customGet('/moderator_task_data/', {
      'taskId': widget.taskId,
    });
    var json = jsonDecode(resp.body);
    final task = ModeratorTask.fromJson(json);

    var moderator = '???';
    if (task.resolver != null) {
      resp = await _backend.customGet('/users_data/', {
        'ids': [task.resolver],
      });
      json = jsonDecode(resp.body);
      final user = UserParams.fromJson(json['result'][0])!;
      if (user.name != null) {
        moderator = '${user.name} (${user.requireBackendID()})';
      } else {
        moderator = user.requireBackendID();
      }
    }

    setState(() {
      _task = task;
      _moderator = moderator;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: _task == null
                ? CircularProgressIndicator()
                : SingleChildScrollView(
                    child: SizedBox(width: 700, child: _content()))));
  }

  Widget _content() {
    final task = _task!;
    if (task.resolutionTime == null) {
      return Text(context.strings.web_global_task_not_resolved,
          style: TextStyles.normal);
    }
    final lang = task.lang ?? 'world';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.strings.web_moderation_action_page_title,
            style: TextStyles.headline1),
        const SizedBox(height: 16),
        Row(children: [
          Text(context.strings.web_moderation_action_page_task_type,
              style: TextStyles.headline2),
          SelectableText(task.taskType, style: TextStyles.normal),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Text(context.strings.web_moderation_action_page_moderator_is,
              style: TextStyles.headline2),
          SelectableText(_moderator!, style: TextStyles.normal),
        ]),
        if (task.barcode != null)
          Column(children: [
            const SizedBox(height: 8),
            Row(children: [
              Text(context.strings.web_global_product_is,
                  style: TextStyles.headline2),
              LinkifyUrl(
                  "https://$lang.openfoodfacts.org/product/${task.barcode}/"),
            ]),
          ]),
        if (task.osmUID != null)
          Column(children: [
            const SizedBox(height: 8),
            Row(children: [
              Text(context.strings.web_global_shop_is,
                  style: TextStyles.headline2),
              LinkifyUrl(
                  "https://www.openstreetmap.org/${task.osmUID!.type.name}/${task.osmUID!.osmId}/"),
            ]),
          ]),
        const SizedBox(height: 8),
        Text(context.strings.web_moderation_action_page_performed_action_is,
            style: TextStyles.headline2),
        const SizedBox(height: 4),
        SelectableText(task.resolverAction ?? '???'),
      ],
    );
  }
}
