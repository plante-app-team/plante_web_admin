import 'package:flutter/material.dart';
import 'package:plante/outside/map/osm/osm_uid.dart';
import 'package:plante/outside/map/osm/osm_element_type.dart';
import 'package:plante/ui/base/components/input_field_plante.dart';
import 'package:plante/ui/base/snack_bar_utils.dart';
import 'package:plante/ui/base/text_styles.dart';
import 'package:plante_web_admin/model/moderator_task.dart';
import 'package:plante_web_admin/ui/components/checkbox_text.dart';
import 'package:plante_web_admin/ui/components/linkify_url.dart';
import 'package:plante/l10n/strings.dart';
import 'package:plante_web_admin/utils/moderation_utils.dart';

import 'moderator_page_base.dart';

class OsmShopCreationTaskPage extends ModeratorTaskPage {
  final VoidCallback callback;
  final ModeratorTask task;
  final OsmUID osmUID;

  OsmShopCreationTaskPage(this.callback, this.task, this.osmUID, {Key? key})
      : super(key: key);

  @override
  _OsmShopCreationTaskPageState createState() =>
      _OsmShopCreationTaskPageState(callback, task);
}

class _OsmShopCreationTaskPageState
    extends ModeratorPageStateBase<OsmShopCreationTaskPage> {
  bool _deleteShopAndMoveProducts = false;
  final _urlOfShopWhereToMoveProductsTo = TextEditingController();

  _OsmShopCreationTaskPageState(VoidCallback callback, ModeratorTask task)
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

  @override
  Widget buildPage(BuildContext context) {
    final osmUID = widget.task.osmUID!;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(context.strings.web_osm_shop_creation_task_page_title,
          style: Theme.of(context).textTheme.headline5),
      Text(context.strings.web_osm_shop_creation_task_page_descr,
          style: TextStyles.headline1),
      LinkifyUrl('https://plante.atlassian.net/wiki/spaces/PS/pages/57966593'),
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
            onChanged: (value) => setState(() {
                  _deleteShopAndMoveProducts = value ?? false;
                })),
        Expanded(
            child: InputFieldPlante(
          label: context.strings.web_osm_shop_creation_task_page_osm_url_label,
          hint: 'www.openstreetmap.org/node/123',
          controller: _urlOfShopWhereToMoveProductsTo,
          readOnly: !_deleteShopAndMoveProducts,
        )),
      ]),
    ]);
  }

  @override
  Future<String> plannedActionPastTense() async {
    final shopAndAddressRes =
        await ModerationUtils.shopAndAddress(widget.task.osmUID!);
    if (shopAndAddressRes.isErr) {
      showSnackBar(context.strings.global_something_went_wrong, context);
      throw Exception(shopAndAddressRes.unwrapErr());
    }
    final shop = shopAndAddressRes.unwrap().first;
    final address = shopAndAddressRes.unwrap().second;
    var action =
        'Moderated shop ${shop.name} (${shop.osmUID}) located at $address';
    if (_deleteShopAndMoveProducts) {
      action += ', deleted it and moved products to ' +
          _urlOfShopWhereToMoveProductsTo.text;
    }
    return action;
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
  @protected
  Future<bool> sendExtraData() async {
    if (_deleteShopAndMoveProducts) {
      final resp = await backend.customGet('move_products_delete_shop/', {
        'badOsmUID': task.osmUID.toString(),
        'goodOsmUID': _uidOfShopWhereToMoveProductsTo().toString(),
      });
      if (resp.isError) {
        showSnackBar('Backend error: $resp', context);
        return false;
      }
    }
    return true;
  }
}
