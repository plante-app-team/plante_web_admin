import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plante/base/base.dart';
import 'package:plante/ui/base/text_styles.dart';
import 'package:plante_web_admin/model/moderator_task.dart';
import 'package:plante/l10n/strings.dart';

class ModerationActionListItem extends StatelessWidget {
  final String? moderator;
  final ModeratorTask task;
  final ArgCallback<ModeratorTask> clickCallback;

  const ModerationActionListItem(
      {Key? key,
      this.moderator,
      required this.task,
      required this.clickCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String resolutionTime = context.strings.web_global_task_not_resolved;
    if (task.resolutionTime != null) {
      final date =
          DateTime.fromMillisecondsSinceEpoch(task.resolutionTime! * 1000);
      resolutionTime = DateFormat.yMd().add_Hm().format(date);
    }
    final actionStr = task.resolverAction ?? '???';
    final moderatorStr = moderator != null ? '$moderator: ' : '';
    return Container(
      color: Colors.grey,
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 1),
          child: Container(
            color: Colors.white,
            width: 600,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                  onTap: () async {
                    clickCallback.call(task);
                  },
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(resolutionTime, style: TextStyles.hint),
                        Text('$moderatorStr$actionStr',
                            style: TextStyles.normal,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ])),
            ),
          )),
    );
  }
}
