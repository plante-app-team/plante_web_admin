import 'package:flutter/material.dart';
import 'package:plante/outside/map/osm/osm_uid.dart';
import 'package:plante_web_admin/model/moderator_task.dart';
import 'package:plante/l10n/strings.dart';
import 'package:plante_web_admin/ui/moderator_task/page/shop_moderation_page_base.dart';

class ShopManualValidationTaskPage extends ShopModerationPageBase {
  ShopManualValidationTaskPage(
      VoidCallback callback, ModeratorTask task, OsmUID osmUID,
      {Key? key})
      : super(callback, task, osmUID, key: key);

  @override
  _ShopManualValidationTaskPageState createState() =>
      _ShopManualValidationTaskPageState(callback, task);
}

class _ShopManualValidationTaskPageState
    extends ShopModerationPageStateBase<ShopManualValidationTaskPage> {
  _ShopManualValidationTaskPageState(VoidCallback callback, ModeratorTask task)
      : super(callback, task);

  @override
  Widget buildTaskTypeSpecificHeader() {
    final osmUID = widget.task.osmUID!;
    return Column(children: [
      Text(context.strings.web_shop_manual_validation_task_page_title,
          style: Theme.of(context).textTheme.headline5),
      SelectableText(context.strings.web_shop_manual_validation_task_page_descr
          .replaceAll("<SHOP>", osmUID.toString())),
    ]);
  }
}
