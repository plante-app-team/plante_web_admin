import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:plante/outside/map/osm_uid.dart';
import 'package:plante/outside/map/osm_element_type.dart';
import 'package:plante_web_admin/model/moderator_task.dart';
import 'package:plante_web_admin/ui/components/linkify_url.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:plante/l10n/strings.dart';

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
        Text(context.strings.web_osm_shop_creation_task_page_shop,
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
}
