import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:plante/outside/backend/backend.dart';
import 'package:plante/outside/map/osm/osm_uid.dart';
import 'package:plante/outside/map/osm/osm_element_type.dart';
import 'package:plante/ui/base/components/input_field_plante.dart';
import 'package:plante/ui/base/snack_bar_utils.dart';
import 'package:plante_web_admin/backend_extensions.dart';
import 'package:plante_web_admin/model/moderator_task.dart';
import 'package:plante_web_admin/ui/components/checkbox_text.dart';
import 'package:plante_web_admin/ui/components/linkify_url.dart';
import 'package:plante/l10n/strings.dart';
import 'package:plante_web_admin/ui/moderator_task/page/moderator_page_base.dart';
import 'package:plante_web_admin/utils/moderation_utils.dart';

abstract class ShopModerationPageBase extends ModeratorTaskPage {
  final VoidCallback callback;
  final ModeratorTask task;
  final OsmUID osmUID;

  ShopModerationPageBase(this.callback, this.task, this.osmUID, {Key? key})
      : super(key: key);
}

abstract class ShopModerationPageStateBase<T extends ShopModerationPageBase>
    extends ModeratorPageStateBase<T> {
  final _backend = GetIt.I.get<Backend>();

  bool _deleteShopAndMoveProducts = false;
  final _urlOfShopWhereToMoveProductsTo = TextEditingController();

  var _deleteShop = false;

  ShopModerationPageStateBase(VoidCallback callback, ModeratorTask task)
      : super(callback, task);

  @override
  void initState() {
    super.initState();
    _urlOfShopWhereToMoveProductsTo.addListener(() {
      setState(() {
        // Update!
      });
    });
  }

  Widget buildTaskTypeSpecificHeader();

  @nonVirtual
  @override
  Widget buildPage(BuildContext context) {
    final osmUID = widget.task.osmUID!;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      buildTaskTypeSpecificHeader(),
      SizedBox(height: 50),
      Row(children: [
        Text(context.strings.web_global_shop_is,
            style: Theme.of(context).textTheme.headline6),
        LinkifyUrl(
            "https://www.openstreetmap.org/${osmUID.type.name}/${osmUID.osmId}/"),
      ]),
      Row(children: [
        Text(context.strings.web_global_user_is,
            style: Theme.of(context).textTheme.headline6),
        SelectableText(widget.task.taskSourceUserId)
      ]),
      const SizedBox(height: 16),
      Text(context.strings.web_osm_shop_creation_task_page_danger_title,
          style: Theme.of(context).textTheme.headline6),
      Row(children: [
        CheckboxText(
            text: context.strings
                .web_osm_shop_creation_task_page_delete_shop_move_products_to,
            value: _deleteShopAndMoveProducts,
            onChanged: _onDeleteShopAndMoveProductsChange),
        Expanded(
            child: InputFieldPlante(
          label: context.strings.web_osm_shop_creation_task_page_osm_url_label,
          hint: 'www.openstreetmap.org/node/123',
          controller: _urlOfShopWhereToMoveProductsTo,
          readOnly: !_deleteShopAndMoveProducts,
        )),
      ]),
      SizedBox(height: 8),
      Row(children: [
        CheckboxText(
            text: context
                .strings.web_shop_manual_validation_task_page_delete_shop,
            value: _deleteShop,
            onChanged: _onDeleteShopChange),
      ])
    ]);
  }

  void _onDeleteShopAndMoveProductsChange(bool? value) async {
    setState(() {
      _deleteShopAndMoveProducts = value ?? false;
      if (_deleteShopAndMoveProducts == true) {
        _deleteShop = false;
      }
    });
  }

  void _onDeleteShopChange(bool? value) async {
    setState(() {
      _deleteShop = value ?? false;
      if (_deleteShop == true) {
        _deleteShopAndMoveProducts = false;
        _urlOfShopWhereToMoveProductsTo.text = '';
      }
    });
  }

  @protected
  @override
  bool get canSend {
    if (_deleteShopAndMoveProducts) {
      return _uidOfShopWhereToMoveProductsTo() != null;
    }
    return true;
  }

  OsmUID? _uidOfShopWhereToMoveProductsTo() {
    final urlStr = _urlOfShopWhereToMoveProductsTo.text.trim();
    final osmRegex = RegExp(r'openstreetmap.org/(node|way|relation)/\d+$');
    if (!osmRegex.hasMatch(urlStr)) {
      return null;
    }

    final OsmElementType osmType;
    if (urlStr.contains('/node/')) {
      osmType = OsmElementType.NODE;
    } else if (urlStr.contains('/way/')) {
      osmType = OsmElementType.WAY;
    } else if (urlStr.contains('/relation/')) {
      osmType = OsmElementType.RELATION;
    } else {
      throw Exception('Invalid regex - passed through $urlStr');
    }

    final lastSlash = urlStr.lastIndexOf('/');
    final osmId = urlStr.substring(lastSlash + 1);
    return OsmUID(osmType, osmId);
  }

  @override
  @nonVirtual
  @protected
  Future<bool> sendExtraData() async {
    if (_deleteShopAndMoveProducts && _deleteShop) {
      showSnackBar('Cannot perform all deletion actions', context);
      return false;
    }

    if (_deleteShopAndMoveProducts) {
      final resp = await backend.customGet('move_products_delete_shop/', {
        'badOsmUID': task.osmUID.toString(),
        'goodOsmUID': _uidOfShopWhereToMoveProductsTo().toString(),
      });
      if (resp.isError) {
        showSnackBar('Backend error: $resp', context);
        return false;
      }
    } else if (_deleteShop) {
      final result = await _backend.deleteShop(widget.osmUID);
      if (result.isErr) {
        showSnackBar('Backend error: $result', context);
        return false;
      }
    }
    return true;
  }

  @nonVirtual
  @override
  Future<String> plannedActionPastTense() async {
    final task = widget.task;
    final shopAndAddressRes =
        await ModerationUtils.shopAndAddress(task.osmUID!);
    final String shopStr;
    final String addressStr;
    if (shopAndAddressRes.isErr) {
      shopStr = '{INVALID SHOP ${task.osmUID}';
      addressStr = '{INVALID ADDR ${task.osmUID}';
    } else {
      final shop = shopAndAddressRes.unwrap().first;
      final address = shopAndAddressRes.unwrap().second;
      shopStr = '${shop.name} (${shop.osmUID})';
      addressStr = address.toString();
    }

    var action = 'Moderated shop $shopStr located at $addressStr.';
    if (_deleteShopAndMoveProducts) {
      action += ' Deleted it and moved '
          'products to ${_urlOfShopWhereToMoveProductsTo.text}.';
    } else if (_deleteShop) {
      action += ' Deleted it.';
    }

    return action;
  }
}
