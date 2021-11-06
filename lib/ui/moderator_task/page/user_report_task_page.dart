import 'package:flutter/material.dart';
import 'package:plante/model/veg_status.dart';
import 'package:plante/outside/backend/backend_product.dart';
import 'package:plante_web_admin/model/moderator_task.dart';
import 'package:plante_web_admin/ui/components/checkbox_text.dart';
import 'package:plante_web_admin/ui/components/linkify_url.dart';
import 'package:plante_web_admin/ui/components/veg_statuses_widget.dart';
import 'package:plante/l10n/strings.dart';
import 'package:plante_web_admin/backend_extensions.dart';

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
  BackendProduct? product;

  bool editVegStatuses = false;

  VegStatus? get veganStatus =>
      VegStatus.safeValueOf(product?.veganStatus ?? '');

  @override
  bool get canSend {
    return true;
  }

  _UserReportTaskPageState(
      VoidCallback callback, ModeratorTask task, BackendProduct? product)
      : product = product,
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
        LinkifyUrl("https://world.openfoodfacts.org/product/${task.barcode}/"),
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
      if (product != null) vegStatusesWidget(),
      if (product == null)
        SizedBox(
            width: double.infinity,
            child: Text(context
                .strings.web_user_report_task_page_product_exists_only_in_off)),
    ]);
  }

  Widget vegStatusesWidget() => Column(children: [
        Row(children: [
          CheckboxText(
              text:
                  context.strings.web_user_report_task_page_change_veg_statuses,
              value: editVegStatuses,
              onChanged: (bool? value) {
                setState(() {
                  editVegStatuses = value ?? false;
                });
              }),
        ]),
        VegStatusesWidget((updatedProduct) {
          setState(() {
            product = updatedProduct;
          });
        }, editVegStatuses, product!)
      ]);

  @protected
  Future<bool> sendExtraData() async {
    if (editVegStatuses && product != null) {
      final resp = await backend.moderateProduct(
          product!.barcode,
          product!.veganStatus,
          product!.moderatorVeganChoiceReason,
          product!.moderatorVeganSourcesText);
      if (resp.isErr) {
        throw Exception('Backend error: ${resp.unwrapErr()}');
      }
    }
    return true;
  }
}
