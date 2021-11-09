import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:plante/outside/backend/backend.dart';
import 'package:plante/outside/map/osm_shop.dart';
import 'package:plante/outside/map/osm_uid.dart';
import 'package:plante/outside/map/osm_element_type.dart';
import 'package:plante/ui/base/ui_utils.dart';
import 'package:plante_web_admin/model/moderator_task.dart';
import 'package:plante_web_admin/ui/components/checkbox_text.dart';
import 'package:plante_web_admin/ui/components/linkify_url.dart';
import 'package:plante/l10n/strings.dart';
import 'package:plante_web_admin/backend_extensions.dart';
import 'package:plante_web_admin/utils/moderation_utils.dart';

import 'moderator_page_base.dart';

class ShopManualValidationTaskPage extends ModeratorTaskPage {
  final VoidCallback callback;
  final ModeratorTask task;
  final OsmUID osmUID;

  ShopManualValidationTaskPage(this.callback, this.task, this.osmUID,
      {Key? key})
      : super(key: key);

  @override
  _ShopManualValidationTaskPageState createState() =>
      _ShopManualValidationTaskPageState(callback, task);
}

class _ShopManualValidationTaskPageState
    extends ModeratorPageStateBase<ShopManualValidationTaskPage> {
  final _backend = GetIt.I.get<Backend>();
  var _deleteShop = false;

  _ShopManualValidationTaskPageState(VoidCallback callback, ModeratorTask task)
      : super(callback, task);

  @override
  bool get canSend => true;

  @override
  Widget buildPage(BuildContext context) {
    final osmUID = widget.task.osmUID!;
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(context.strings.web_shop_manual_validation_task_page_title,
          style: Theme.of(context).textTheme.headline5),
      SelectableText(context.strings.web_shop_manual_validation_task_page_descr
          .replaceAll("<SHOP>", osmUID.toString())),
      SizedBox(height: 50),
      Row(children: [
        Text(context.strings.web_global_shop_is,
            style: Theme.of(context).textTheme.headline6),
        LinkifyUrl(
            "https://www.openstreetmap.org/${osmUID.type.name}/${osmUID.osmId}/"),
      ]),
      Row(children: [
        Text(context.strings.web_shop_manual_validation_task_page_user,
            style: Theme.of(context).textTheme.headline6),
        SelectableText(widget.task.taskSourceUserId)
      ]),
      SizedBox(height: 25),
      CheckboxText(
          text:
              context.strings.web_shop_manual_validation_task_page_delete_shop,
          value: _deleteShop,
          onChanged: _onDeleteShopChange),
    ]);
  }

  void _onDeleteShopChange(bool? value) async {
    if (value == true) {
      final delete = await showYesNoDialog(
          context,
          context
              .strings.web_shop_manual_validation_task_page_delete_shop_warning,
          () {});
      setState(() {
        _deleteShop = delete;
      });
    }
  }

  @protected
  Future<bool> sendExtraData() async {
    if (!_deleteShop) {
      return true;
    }
    final result = await _backend.deleteShop(widget.osmUID);
    return result.isOk;
  }

  @override
  Future<String> plannedActionPastTense() async {
    final task = widget.task;
    final shopAndAddressRes =
        await ModerationUtils.shopAndAddress(task.osmUID!);
    final OsmShop? shop;
    if (shopAndAddressRes.isErr) {
      shop = null;
    } else {
      shop = shopAndAddressRes.unwrap().first;
    }
    final shopStr = shop?.name ?? '{INVALID SHOP ${task.osmUID}';

    var action = 'Performed manual validation of $shopStr';
    if (_deleteShop) {
      action += ', among other action also deleted it';
    }
    return action;
  }
}
