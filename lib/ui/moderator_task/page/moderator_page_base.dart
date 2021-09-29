import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:plante/model/user_params.dart';
import 'package:plante/model/user_params_controller.dart';
import 'package:plante/outside/backend/backend.dart';
import 'package:plante/outside/backend/backend_product.dart';
import 'package:plante/ui/base/components/button_outlined_plante.dart';
import 'package:plante/ui/base/snack_bar_utils.dart';
import 'package:plante/ui/base/ui_utils.dart';
import 'package:plante_web_admin/model/moderator_task.dart';
import 'package:plante/l10n/strings.dart';
import 'package:plante_web_admin/ui/components/checkbox_text.dart';
import 'package:plante_web_admin/ui/moderator_task/page/osm_shop_creation_task_page.dart';
import 'package:plante_web_admin/ui/moderator_task/page/product_change_task_page.dart';
import 'package:plante_web_admin/ui/moderator_task/page/user_report_task_page.dart';

abstract class ModeratorTaskPage extends StatefulWidget {
  ModeratorTaskPage({Key? key}) : super(key: key);

  static Future<ModeratorTaskPage> create(
      ModeratorTask task, VoidCallback callback, BuildContext context,
      {Key? key}) async {
    final backend = GetIt.I.get<Backend>();

    final BackendProduct? product;
    if ((task.barcode ?? '').trim().isNotEmpty) {
      product = await _retrieveProduct(task.barcode!, backend);
    } else {
      product = null;
    }

    if (task.taskType == "user_report") {
      return UserReportTaskPage(callback, task, product);
    } else if (task.taskType == "product_change") {
      return ProductChangeTaskPage(
          callback, task, product ?? BackendProduct.empty);
    } else if (task.taskType == "osm_shop_creation") {
      return OsmShopCreationTaskPage(callback, task, task.osmUID!);
    } else {
      showSnackBar("Error: unknown task type ${task.taskType}", context);
      throw Exception("Error: unknown task type ${task.taskType}");
    }
  }

  static Future<BackendProduct?> _retrieveProduct(
      String barcode, Backend backend) async {
    final resp = await backend.customGet("product_data/", {"barcode": barcode});
    final json = jsonDecode(resp.body);
    if (json["error"] == "product_not_found") {
      return null;
    }
    return BackendProduct.fromJson(json);
  }
}

abstract class ModeratorPageStateBase<T extends StatefulWidget>
    extends State<T> {
  final backend = GetIt.I.get<Backend>();
  final _userParamsController = GetIt.I.get<UserParamsController>();
  final VoidCallback callback;
  final ModeratorTask task;
  bool _loading = false;
  bool _moderated = false;
  UserParams get _user => _userParamsController.cachedUserParams!;

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
              if (task.assignee == _user.backendId)
                Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton(
                      child: Text(
                          context.strings.web_moderator_page_base_unassign),
                      onPressed: _onUnassignClicked,
                    )),
              buildPage(context),
              SizedBox(height: 50),
              Row(children: [
                CheckboxText(
                    text: context.strings.web_user_report_task_page_moderated,
                    value: _moderated,
                    onChanged: (bool? value) {
                      setState(() {
                        _moderated = value ?? false;
                      });
                    }),
              ]),
              SizedBox(
                  width: 500,
                  child: ButtonOutlinedPlante.withText(
                      context.strings.web_global_send,
                      onPressed: _canSend ? _onSendClicked : null))
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
      callback.call();
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
        context.strings.web_moderator_page_base_unassign_dialog_descr,
        context.strings.web_moderator_page_base_unassign_dialog_title,
        _unassign);
  }

  void _unassign() async {
    _performNetworkAction(() async {
      final resp = await backend
          .customGet("reject_moderator_task/", {"taskId": task.id.toString()});
      assert(jsonDecode(resp.body)["result"] == "ok");
      callback.call();
    });
  }
}
