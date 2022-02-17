import 'package:flutter/material.dart';
import 'package:plante/outside/map/osm/osm_uid.dart';
import 'package:plante/ui/base/text_styles.dart';
import 'package:plante_web_admin/model/moderator_task.dart';
import 'package:plante_web_admin/ui/components/linkify_url.dart';
import 'package:plante/l10n/strings.dart';
import 'package:plante_web_admin/ui/moderator_task/page/shop_moderation_page_base.dart';

class OsmShopCreationTaskPage extends ShopModerationPageBase {
  OsmShopCreationTaskPage(
      VoidCallback callback, ModeratorTask task, OsmUID osmUID,
      {Key? key})
      : super(callback, task, osmUID, key: key);

  @override
  _OsmShopCreationTaskPageState createState() =>
      _OsmShopCreationTaskPageState(callback, task);
}

class _OsmShopCreationTaskPageState
    extends ShopModerationPageStateBase<OsmShopCreationTaskPage> {
  _OsmShopCreationTaskPageState(VoidCallback callback, ModeratorTask task)
      : super(callback, task);

  @override
  Widget buildTaskTypeSpecificHeader() {
    return Column(children: [
      Text(context.strings.web_osm_shop_creation_task_page_title,
          style: Theme.of(context).textTheme.headline5),
      Text(context.strings.web_osm_shop_creation_task_page_descr,
          style: TextStyles.headline1),
      LinkifyUrl(
          'https://github.com/plante-app-team/plante_docs/blob/master/how-to-moderate-new-shops.md'),
    ]);
  }
}
