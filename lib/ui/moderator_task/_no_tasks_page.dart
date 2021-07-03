import 'package:flutter/widgets.dart';

import 'package:plante/l10n/strings.dart';

class NoTasksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(context.strings.web_no_tasks_page_title));
  }
}
