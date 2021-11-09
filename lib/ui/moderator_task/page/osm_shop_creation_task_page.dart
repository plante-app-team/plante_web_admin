import 'package:flutter/material.dart';
import 'package:plante/outside/map/osm_uid.dart';
import 'package:plante/outside/map/osm_element_type.dart';
import 'package:plante/ui/base/snack_bar_utils.dart';
import 'package:plante_web_admin/model/moderator_task.dart';
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
  _OsmShopCreationTaskPageState(VoidCallback callback, ModeratorTask task)
      : super(callback, task);

  @override
  bool get canSend => true;

  @override
  Widget buildPage(BuildContext context) {
    final osmUID = widget.task.osmUID!;
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(context.strings.web_osm_shop_creation_task_page_title,
          style: Theme.of(context).textTheme.headline5),
      Text(context.strings.web_osm_shop_creation_task_page_descr),
      SizedBox(height: 50),
      Row(children: [
        Text(context.strings.web_global_shop_is,
            style: Theme.of(context).textTheme.headline6),
        LinkifyUrl(
            "https://www.openstreetmap.org/${osmUID.type.name}/${osmUID.osmId}/"),
      ]),
      Row(children: [
        Text(context.strings.web_osm_shop_creation_task_page_user,
            style: Theme.of(context).textTheme.headline6),
        SelectableText(widget.task.taskSourceUserId)
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
    return 'Moderated shop ${shop.name} (${shop.osmUID}) located at $address';
  }
}
