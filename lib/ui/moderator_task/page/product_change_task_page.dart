import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:plante/model/veg_status.dart';
import 'package:plante/outside/backend/backend_product.dart';
import 'package:plante_web_admin/model/moderator_task.dart';
import 'package:plante_web_admin/ui/components/veg_statuses_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:plante/l10n/strings.dart';
import 'package:plante_web_admin/backend_extensions.dart';

import 'moderator_page_base.dart';

class ProductChangeTaskPage extends ModeratorTaskPage {
  final VoidCallback callback;
  final ModeratorTask task;
  final BackendProduct backendProduct;

  ProductChangeTaskPage(this.callback, this.task, this.backendProduct,
      {Key? key})
      : super(key: key);

  @override
  _ProductChangeTaskPageState createState() =>
      _ProductChangeTaskPageState(callback, task, backendProduct);
}

class _ProductChangeTaskPageState
    extends ModeratorPageStateBase<ProductChangeTaskPage> {
  BackendProduct product;

  VegStatus? get vegetarianStatus =>
      VegStatus.safeValueOf(product.vegetarianStatus ?? '');
  VegStatus? get veganStatus =>
      VegStatus.safeValueOf(product.veganStatus ?? '');

  @override
  bool get canSend {
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

  _ProductChangeTaskPageState(
      VoidCallback callback, ModeratorTask task, BackendProduct product)
      : product = product,
        super(callback, task);

  @override
  Widget buildPage(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(context.strings.web_product_change_task_page_title,
          style: Theme.of(context).textTheme.headline5),
      Text(context.strings.web_product_change_task_page_descr),
      SizedBox(height: 50),
      if (product.barcode.isNotEmpty)
        Row(children: [
          Text(context.strings.web_product_change_task_page_product,
              style: Theme.of(context).textTheme.headline6),
          Linkify(
            text: "https://ru.openfoodfacts.org/product/${task.barcode}/",
            onOpen: (e) {
              launch(e.url);
            },
          )
        ]),
      if (product.barcode.isEmpty)
        Text(
            context
                .strings.web_product_change_task_page_empty_product_error_descr,
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: Colors.red)),
      Row(children: [
        Text(context.strings.web_product_change_task_page_user,
            style: Theme.of(context).textTheme.headline6),
        SelectableText(task.taskSourceUserId)
      ]),
      vegStatusesWidget(),
    ]);
  }

  Widget vegStatusesWidget() => VegStatusesWidget((updatedProduct) {
        setState(() {
          product = updatedProduct;
        });
      }, true, product);

  @protected
  Future<bool> sendExtraData() async {
    if (task.barcode != null && task.barcode!.trim().isNotEmpty) {
      final resp = await backend.moderateProduct(
          product.barcode,
          product.vegetarianStatus,
          product.veganStatus,
          product.moderatorVegetarianChoiceReason,
          product.moderatorVegetarianSourcesText,
          product.moderatorVeganChoiceReason,
          product.moderatorVeganSourcesText);
      if (resp.isErr) {
        throw Exception('Backend error: ${resp.unwrapErr()}');
      }
    }
    return true;
  }
}
