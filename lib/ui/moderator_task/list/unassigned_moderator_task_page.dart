import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:plante/outside/backend/backend.dart';
import 'package:plante/ui/base/snack_bar_utils.dart';
import 'package:plante_web_admin/model/moderator_task.dart';
import 'package:plante_web_admin/ui/moderator_task/page/moderator_page_base.dart';

class UnassignedModeratorTaskPage extends StatefulWidget {
  final String taskId;
  const UnassignedModeratorTaskPage(this.taskId, {Key? key}) : super(key: key);

  @override
  _UnassignedModeratorTaskPageState createState() =>
      _UnassignedModeratorTaskPageState();
}

class _UnassignedModeratorTaskPageState
    extends State<UnassignedModeratorTaskPage> {
  final _backend = GetIt.I.get<Backend>();
  ModeratorTaskPage? _taskPage;
  var _inited = false;

  @override
  Widget build(BuildContext context) {
    if (!_inited) {
      _init(context);
      _inited = true;
    }

    if (_taskPage == null) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(body: _taskPage!);
  }

  Future<void> _init(BuildContext context) async {
    try {
      final resp = await _backend
          .customGet('moderator_task_data/', {'taskId': widget.taskId});
      final json = jsonDecode(resp.body);
      final task = ModeratorTask.fromJson(json);
      final pop = () {
        Navigator.of(context).pop();
      };
      _taskPage = await ModeratorTaskPage.create(task, pop, context);
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        setState(() {
          // Update!
        });
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }
}
