import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:plante/outside/backend/backend.dart';
import 'package:plante/ui/base/ui_utils.dart';
import 'package:plante_web_admin/model/moderator_task.dart';
import 'package:plante_web_admin/ui/moderator_task/next_page_callback.dart';
import 'package:plante/l10n/strings.dart';

import 'initial_page.dart';

abstract class ModeratorPageStateBase<T extends StatefulWidget>
    extends State<T> {
  final backend = GetIt.I.get<Backend>();
  final NextPageCallback callback;
  final ModeratorTask task;
  bool _loading = false;
  bool _moderated = false;

  ModeratorPageStateBase(this.callback, this.task);

  bool get _canSend {
    return canSend && _moderated;
  }

  @protected
  bool get canSend;
  @protected
  Widget buildPage(BuildContext context);
  @protected
  Future<bool> sendExtraData() async => true;

  @nonVirtual
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            width: 700,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              if (_loading) CircularProgressIndicator(),
              Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton(
                    child:
                        Text(context.strings.web_moderator_page_base_unassign),
                    onPressed: _onUnassignClicked,
                  )),
              buildPage(context),
              SizedBox(height: 50),
              Row(children: [
                Checkbox(
                    value: _moderated,
                    onChanged: (bool? value) {
                      setState(() {
                        _moderated = value ?? false;
                      });
                    }),
                Text(context.strings.web_user_report_task_page_moderated)
              ]),
              OutlinedButton(
                  child: Text(context.strings.web_global_send),
                  onPressed: _canSend ? _onSendClicked : null)
            ])));
  }

  void _onSendClicked() async {
    _performNetworkAction(() async {
      final extraSent = await sendExtraData();
      if (!extraSent) {
        return;
      }
      final resp = await backend
          .customGet("resolve_moderator_task/", {"taskId": task.id.toString()});
      assert(jsonDecode(resp.body)["result"] == "ok");
      callback.call(InitialPage(callback));
    });
  }

  void _performNetworkAction(dynamic Function() action) async {
    try {
      setState(() {
        _loading = true;
      });
      await action.call();
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _onUnassignClicked() async {
    showDoOrCancelDialog(
        context,
        context.strings.web_moderator_page_base_unassign_dialog_title,
        context.strings.web_moderator_page_base_unassign_dialog_descr,
        _unassign);
  }

  void _unassign() async {
    _performNetworkAction(() async {
      final resp = await backend
          .customGet("reject_moderator_task/", {"taskId": task.id.toString()});
      assert(jsonDecode(resp.body)["result"] == "ok");
      callback.call(InitialPage(callback));
    });
  }
}
