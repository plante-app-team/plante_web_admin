import 'package:flutter/material.dart';
import 'package:plante/ui/base/text_styles.dart';
import 'package:plante_web_admin/model/moderator_task.dart';
import 'package:plante/l10n/strings.dart';

abstract class ModeratorTaskListItem extends StatelessWidget {
  ModeratorTaskListItem._({Key? key}) : super(key: key);

  factory ModeratorTaskListItem(ModeratorTask task, {Key? key}) {
    if (task.taskType == "user_report") {
      return _UserReportTaskListItem(task, key: key);
    } else if (task.taskType == "product_change" ||
        task.taskType == "product_change_in_off") {
      return _ProductChangeTaskListItem(task, key: key);
    } else if (task.taskType == "osm_shop_creation") {
      return _ShopCreatedTaskListItem(task, key: key);
    } else if (task.taskType == "osm_shop_needs_manual_validation") {
      return _ShopNeedsManualValidationTaskListItem(task, key: key);
    } else {
      throw Exception(
          'ModeratorTaskListItem Error: unknown task type ${task.taskType}');
    }
  }
}

class _UserReportTaskListItem extends ModeratorTaskListItem {
  final ModeratorTask task;

  _UserReportTaskListItem(this.task, {Key? key}) : super._(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(context.strings.web_moderator_task_list_item_task_user_complaint,
          style: TextStyles.headline4),
      Text(task.textFromUser ?? '',
          style: TextStyles.hint, maxLines: 1, overflow: TextOverflow.ellipsis),
    ]);
  }
}

class _ProductChangeTaskListItem extends ModeratorTaskListItem {
  final ModeratorTask task;

  _ProductChangeTaskListItem(this.task, {Key? key}) : super._(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(context.strings.web_moderator_task_list_item_task_product_update,
          style: TextStyles.headline4),
      Text(task.barcode ?? '',
          style: TextStyles.hint, maxLines: 1, overflow: TextOverflow.ellipsis),
    ]);
  }
}

class _ShopCreatedTaskListItem extends ModeratorTaskListItem {
  final ModeratorTask task;

  _ShopCreatedTaskListItem(this.task, {Key? key}) : super._(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(context.strings.web_moderator_task_list_item_task_shop_created,
          style: TextStyles.headline4),
      Text(task.osmUID?.toString() ?? '',
          style: TextStyles.hint, maxLines: 1, overflow: TextOverflow.ellipsis),
    ]);
  }
}

class _ShopNeedsManualValidationTaskListItem extends ModeratorTaskListItem {
  final ModeratorTask task;

  _ShopNeedsManualValidationTaskListItem(this.task, {Key? key})
      : super._(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
          context.strings
              .web_moderator_task_list_item_task_shop_needs_manual_validation,
          style: TextStyles.headline4),
      Text(task.osmUID?.toString() ?? '',
          style: TextStyles.hint, maxLines: 1, overflow: TextOverflow.ellipsis),
    ]);
  }
}
