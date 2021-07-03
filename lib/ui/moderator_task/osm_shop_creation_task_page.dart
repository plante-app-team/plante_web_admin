import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:plante_web_admin/model/moderator_task.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:plante/l10n/strings.dart';

import 'moderator_page_state_base.dart';
import 'next_page_callback.dart';

class OsmShopCreationTaskPage extends StatefulWidget {
  final NextPageCallback callback;
  final ModeratorTask task;
  final String osmId;

  const OsmShopCreationTaskPage(this.callback, this.task, this.osmId,
      {Key? key})
      : super(key: key);

  @override
  _OsmShopCreationTaskPageState createState() =>
      _OsmShopCreationTaskPageState(callback, task);
}

class _OsmShopCreationTaskPageState
    extends ModeratorPageStateBase<OsmShopCreationTaskPage> {
  _OsmShopCreationTaskPageState(NextPageCallback callback, ModeratorTask task)
      : super(callback, task);

  @override
  bool get canSend => true;

  @override
  Widget buildPage(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(context.strings.web_osm_shop_creation_task_page_title,
          style: Theme.of(context).textTheme.headline5),
      Text(context.strings.web_osm_shop_creation_task_page_descr),
      SizedBox(height: 50),
      Row(children: [
        Text(context.strings.web_osm_shop_creation_task_page_shop,
            style: Theme.of(context).textTheme.headline6),
        Linkify(
          text: "https://www.openstreetmap.org/node/${widget.task.osmId}/",
          onOpen: (e) {
            launch(e.url);
          },
        )
      ]),
      Row(children: [
        Text(context.strings.web_osm_shop_creation_task_page_user,
            style: Theme.of(context).textTheme.headline6),
        SelectableText(widget.task.taskSourceUserId)
      ]),
    ]);
  }
}
