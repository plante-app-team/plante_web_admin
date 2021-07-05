import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:plante/model/veg_status.dart';
import 'package:plante/outside/backend/backend_product.dart';
import 'package:plante_web_admin/model/moderator_task.dart';
import 'package:plante_web_admin/ui/components/veg_statuses_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:plante/l10n/strings.dart';

import 'moderator_page_base.dart';

class UserReportTaskPage extends ModeratorTaskPage {
  final VoidCallback callback;
  final ModeratorTask task;
  final BackendProduct? backendProduct;

  UserReportTaskPage(this.callback, this.task, this.backendProduct, {Key? key})
      : super(key: key);

  @override
  _UserReportTaskPageState createState() =>
      _UserReportTaskPageState(callback, task, backendProduct);
}

class _UserReportTaskPageState
    extends ModeratorPageStateBase<UserReportTaskPage> {
  final BackendProduct? product;

  bool editVegStatuses = false;
  VegStatus? vegetarianStatus;
  VegStatus? veganStatus;

  @override
  bool get canSend {
    if (editVegStatuses) {
      if (vegetarianStatus == null && veganStatus == null) {
        // Erased
        return true;
      } else if (vegetarianStatus != null && veganStatus != null) {
        // Filled
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  _UserReportTaskPageState(
      VoidCallback callback, ModeratorTask task, BackendProduct? product)
      : product = product,
        vegetarianStatus =
            VegStatus.safeValueOf(product?.vegetarianStatus ?? ""),
        veganStatus = VegStatus.safeValueOf(product?.veganStatus ?? ""),
        super(callback, task);

  @override
  Widget buildPage(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(context.strings.web_user_report_task_page_title,
          style: Theme.of(context).textTheme.headline5),
      Text(context.strings.web_user_report_task_page_descr),
      SizedBox(height: 50),
      Row(children: [
        Text(context.strings.web_user_report_task_page_product,
            style: Theme.of(context).textTheme.headline6),
        Linkify(
          text: "https://ru.openfoodfacts.org/product/${task.barcode}/",
          onOpen: (e) {
            launch(e.url);
          },
        )
      ]),
      Row(children: [
        Text(context.strings.web_user_report_task_page_user,
            style: Theme.of(context).textTheme.headline6),
        SelectableText(task.taskSourceUserId)
      ]),
      Row(children: [
        Text(context.strings.web_user_report_task_page_complaint,
            style: Theme.of(context).textTheme.headline6),
        SizedBox(
            width: 400,
            child: SelectableText(task.textFromUser ?? "NO TEXT",
                maxLines: null, textAlign: TextAlign.left))
      ]),
      if (product != null) vegStatusesWidget(product!),
      if (product == null)
        SizedBox(
            width: double.infinity,
            child: Text(context
                .strings.web_user_report_task_page_product_exists_only_in_off)),
    ]);
  }

  Widget vegStatusesWidget(BackendProduct product) => Column(children: [
        Row(children: [
          Checkbox(
              value: editVegStatuses,
              onChanged: (bool? value) {
                setState(() {
                  editVegStatuses = value ?? false;
                });
                if (editVegStatuses) {
                  showModerateBothStatusesWarning();
                }
              }),
          Text(context.strings.web_user_report_task_page_change_veg_statuses)
        ]),
        VegStatusesWidget((vegetarianStatus, veganStatus) {
          setState(() {
            this.vegetarianStatus = vegetarianStatus;
            this.veganStatus = veganStatus;
          });
        }, editVegStatuses, vegetarianStatus, product.vegetarianStatusSource,
            veganStatus, product.veganStatusSource)
      ]);

  void showModerateBothStatusesWarning() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(context.strings
            .web_user_report_task_page_please_moderate_both_veg_statuses),
        duration: Duration(seconds: 10)));
  }

  @protected
  Future<bool> sendExtraData() async {
    if (editVegStatuses) {
      if (vegetarianStatus != null && veganStatus != null) {
        final resp = await backend.customGet("moderate_product_veg_statuses/", {
          "barcode": task.barcode!,
          "vegetarianStatus": vegetarianStatus!.name,
          "veganStatus": veganStatus!.name
        });
        return jsonDecode(resp.body)["result"] == "ok";
      } else {
        final resp = await backend.customGet(
            "clear_product_veg_statuses/", {"barcode": task.barcode!});
        return jsonDecode(resp.body)["result"] == "ok";
      }
    }
    return true;
  }
}
