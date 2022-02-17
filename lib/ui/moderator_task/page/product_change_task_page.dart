import 'package:flutter/material.dart';
import 'package:plante/model/veg_status.dart';
import 'package:plante/outside/backend/backend_product.dart';
import 'package:plante/ui/base/snack_bar_utils.dart';
import 'package:plante_web_admin/model/moderator_task.dart';
import 'package:plante_web_admin/ui/components/linkify_url.dart';
import 'package:plante_web_admin/ui/components/veg_statuses_widget.dart';
import 'package:plante/l10n/strings.dart';
import 'package:plante_web_admin/backend_extensions.dart';
import 'package:plante_web_admin/utils/moderation_utils.dart';
import 'package:plante/model/product.dart';

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

  VegStatus? get veganStatus =>
      VegStatus.safeValueOf(product.veganStatus ?? '');

  @override
  bool get canSend {
    return true;
  }

  _ProductChangeTaskPageState(
      VoidCallback callback, ModeratorTask task, BackendProduct product)
      : product = product,
        super(callback, task);

  @override
  Widget buildPage(BuildContext context) {
    final lang = task.lang ?? 'world';

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.strings.web_product_change_task_page_title,
              style: Theme.of(context).textTheme.headline5),
          Text(context.strings.web_product_change_task_page_descr),
          LinkifyUrl(
              'https://github.com/plante-app-team/plante_docs/blob/master/how-to-moderate-products.md'),
          SizedBox(height: 50),
          if (product.barcode.isNotEmpty)
            Row(children: [
              Text(context.strings.web_global_product_is,
                  style: Theme.of(context).textTheme.headline6),
              LinkifyUrl(
                  "https://$lang.openfoodfacts.org/product/${task.barcode}/"),
            ]),
          if (product.barcode.isEmpty)
            Text(
                context.strings
                    .web_product_change_task_page_empty_product_error_descr,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: Colors.red)),
          Row(children: [
            Text(context.strings.web_global_user_is,
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
          product.veganStatus,
          product.moderatorVeganChoiceReasons,
          product.moderatorVeganSourcesText);
      if (resp.isErr) {
        throw Exception('Backend error: ${resp.unwrapErr()}');
      }
    }
    return true;
  }

  @override
  Future<String> plannedActionPastTense() async {
    final task = widget.task;
    final productRes = await ModerationUtils.productWith(task.barcode!);
    if (productRes.isErr) {
      showSnackBar(context.strings.global_something_went_wrong, context);
      throw Exception(productRes.unwrapErr());
    }
    final productFull = productRes.unwrap();
    var action = 'Moderated product ';
    if (productFull != null) {
      action += '${productFull.name} (${productFull.barcode})';
    } else {
      action += 'which was deleted in OFF';
    }
    action += ' and changed product from: ${widget.backendProduct} to $product';
    return action;
  }
}
