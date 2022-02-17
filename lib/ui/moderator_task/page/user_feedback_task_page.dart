import 'package:flutter/material.dart';
import 'package:plante_web_admin/model/moderator_task.dart';
import 'package:plante/l10n/strings.dart';

import 'moderator_page_base.dart';

class UserFeedbackTaskPage extends ModeratorTaskPage {
  final VoidCallback callback;
  final ModeratorTask task;

  UserFeedbackTaskPage(this.callback, this.task, {Key? key})
      : super(key: key);

  @override
  _UserFeedbackTaskPageState createState() =>
      _UserFeedbackTaskPageState(callback, task);
}

class _UserFeedbackTaskPageState
    extends ModeratorPageStateBase<UserFeedbackTaskPage> {
  @override
  bool get canSend {
    return true;
  }

  _UserFeedbackTaskPageState(
      VoidCallback callback, ModeratorTask task)
      : super(callback, task);

  @override
  Widget buildPage(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(context.strings.web_user_feedback_task_page_title,
          style: Theme.of(context).textTheme.headline5),
      Text(context.strings.web_user_feedback_task_page_descr),
      SizedBox(height: 50),
      Row(children: [
        Text(context.strings.web_global_user_is,
            style: Theme.of(context).textTheme.headline6),
        SelectableText(task.taskSourceUserId)
      ]),
      Row(children: [
        Text(context.strings.web_user_feedback_task_page_feedback,
            style: Theme.of(context).textTheme.headline6),
        SizedBox(
            width: 400,
            child: SelectableText(task.textFromUser ?? "NO TEXT",
                maxLines: null, textAlign: TextAlign.left))
      ]),
    ]);
  }

  @override
  Future<String> plannedActionPastTense() async {
    final task = widget.task;
    return 'Moderated feedback from ${task.taskSourceUserId}, text: "${task.textFromUser}"';
  }
}
