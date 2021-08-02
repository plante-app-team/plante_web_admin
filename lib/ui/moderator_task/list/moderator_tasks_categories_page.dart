import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:plante/model/user_params_controller.dart';
import 'package:plante/outside/backend/backend.dart';
import 'package:plante/ui/base/components/button_filled_plante.dart';
import 'package:plante/ui/base/components/button_outlined_plante.dart';
import 'package:plante/ui/base/snack_bar_utils.dart';
import 'package:plante/l10n/strings.dart';
import 'package:plante/ui/base/text_styles.dart';
import 'package:plante_web_admin/model/moderator_tasks_counts.dart';
import 'package:plante_web_admin/ui/moderator_task/list/moderator_tasks_list_page.dart';

class ModeratorTasksCategoriesPage extends StatefulWidget {
  static const NAME = '/moderator_tasks_categories';
  const ModeratorTasksCategoriesPage({Key? key}) : super(key: key);

  @override
  _ModeratorTasksCategoriesPageState createState() =>
      _ModeratorTasksCategoriesPageState();

  static Future<void> open(BuildContext context) async {
    await Navigator.pushNamed(context, NAME);
  }
}

class _ModeratorTasksCategoriesPageState
    extends State<ModeratorTasksCategoriesPage> {
  final _backend = GetIt.I.get<Backend>();
  final _user = GetIt.I.get<UserParamsController>().cachedUserParams!;
  var _loading = true;
  ModeratorTasksCounts? _counts;

  @override
  void initState() {
    super.initState();
    _longAction(() async {
      final response = await _backend.customGet('count_moderator_tasks/');
      if (response.isError) {
        showSnackBar(context.strings.global_something_went_wrong, context);
        return;
      }
      _counts = ModeratorTasksCounts.fromJson(jsonDecode(response.body));
    });
  }

  void _longAction(dynamic Function() action) async {
    setState(() {
      _loading = true;
    });
    try {
      await action.call();
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(child: CircularProgressIndicator());
    }

    final knownLangsCounts = _counts!.langsCounts.entries.where((entry) =>
        (_user.langsPrioritized?.toList() ?? []).contains(entry.key));
    final notKnownLangsCounts = _counts!.langsCounts.entries.where((entry) =>
        !(_user.langsPrioritized?.toList() ?? []).contains(entry.key));

    final langCountToWidget = (MapEntry<String, int> entry) {
      return Column(children: [
        ButtonOutlinedPlante.withText('${entry.key} - ${entry.value}',
            onPressed: () {
          _onLangButtonPress(entry.key);
        }),
        SizedBox(height: 8),
      ]);
    };

    final knownLangsButtons = knownLangsCounts.map(langCountToWidget).toList();
    final notKnownLangsButtons =
        notKnownLangsCounts.map(langCountToWidget).toList();

    return Scaffold(
        body: Center(
            child: SizedBox(
                width: 500,
                child: ListView(shrinkWrap: true, children: [
                  Text(
                      context.strings.web_moderator_tasks_categories_page_title,
                      style: TextStyles.headline1),
                  const SizedBox(height: 24),
                  ButtonFilledPlante.withText(
                      '${context.strings.web_moderator_tasks_categories_page_tasks_without_langs} '
                      '(${_counts!.withoutLangsCount})',
                      onPressed: _onTasksWithoutLangsButtonPressed),
                  const SizedBox(height: 8),
                  ButtonFilledPlante.withText(
                      '${context.strings.web_moderator_tasks_categories_page_all_tasks} '
                      '(${_counts!.totalCount})',
                      onPressed: _onAllTasksButtonPressed),
                  const SizedBox(height: 12),
                  if (knownLangsButtons.isNotEmpty)
                    Column(children: [
                      Text(
                          context.strings
                              .web_moderator_tasks_categories_page_tasks_for_langs_you_know,
                          style: TextStyles.headline3),
                      Column(children: knownLangsButtons),
                    ]),
                  if (notKnownLangsButtons.isNotEmpty)
                    Column(children: [
                      Text(
                          context.strings
                              .web_moderator_tasks_categories_page_tasks_for_langs_you_do_not_know,
                          style: TextStyles.headline3),
                      Column(children: notKnownLangsButtons),
                    ])
                ]))));
  }

  void _onLangButtonPress(String lang) {
    ModeratorTasksListPage.openForLang(context, lang);
  }

  void _onAllTasksButtonPressed() {
    ModeratorTasksListPage.openForAllLangs(context);
  }

  void _onTasksWithoutLangsButtonPressed() {
    ModeratorTasksListPage.openForTasksWithoutLangs(context);
  }
}
