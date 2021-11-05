import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:plante/model/lang_code.dart';
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
    extends State<ModeratorTasksCategoriesPage> with RouteAware {
  static const _OFF_PRODUCT_TASK_TYPE = 'product_change_in_off';
  final _backend = GetIt.I.get<Backend>();
  final _user = GetIt.I.get<UserParamsController>().cachedUserParams!;
  var _loading = true;
  ModeratorTasksCounts? _highPriorityTasksCounts;
  ModeratorTasksCounts? _offProductsModerationTasksCounts;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    GetIt.I
        .get<RouteObserver<ModalRoute>>()
        .subscribe(this, ModalRoute.of<dynamic>(context)!);
  }

  @override
  void dispose() {
    GetIt.I.get<RouteObserver<ModalRoute>>().unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _reload();
  }

  void _reload() async {
    _longAction(() async {
      final highPriorityRes =
          await _backend.customGet('count_moderator_tasks/', {
        'excludeTypes': _OFF_PRODUCT_TASK_TYPE,
      });
      final offProductsRes = await _backend.customGet(
          'count_moderator_tasks/', {'includeTypes': _OFF_PRODUCT_TASK_TYPE});
      if (highPriorityRes.isError || offProductsRes.isError) {
        showSnackBar(context.strings.global_something_went_wrong, context);
        return;
      }
      _highPriorityTasksCounts =
          ModeratorTasksCounts.fromJson(jsonDecode(highPriorityRes.body));
      _offProductsModerationTasksCounts =
          ModeratorTasksCounts.fromJson(jsonDecode(offProductsRes.body));
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

    final mainCounts = _highPriorityTasksCounts!;
    final offCounts = _offProductsModerationTasksCounts!;

    final knownLangsCounts = mainCounts.langsCounts.entries.where((entry) =>
        (_user.langsPrioritized?.toList() ?? []).contains(entry.key));
    final notKnownLangsCounts = mainCounts.langsCounts.entries.where((entry) =>
        !(_user.langsPrioritized?.toList() ?? []).contains(entry.key));

    final langCountToWidget = (MapEntry<String, int> entry) {
      final langStr =
          LangCode.safeValueOf(entry.key)?.localize(context) ?? entry.key;
      return Column(children: [
        ButtonOutlinedPlante.withText('$langStr - ${entry.value}',
            onPressed: () {
          _onLangButtonPress(entry.key);
        }),
        SizedBox(height: 8),
      ]);
    };

    final knownLangsButtons = knownLangsCounts.map(langCountToWidget).toList();
    final notKnownLangsButtons =
        notKnownLangsCounts.map(langCountToWidget).toList();

    final content = ListView(shrinkWrap: true, children: [
      Text(context.strings.web_moderator_tasks_categories_page_title,
          style: TextStyles.headline1),
      const SizedBox(height: 24),
      ButtonFilledPlante.withText(
          '${context.strings.web_moderator_tasks_categories_page_tasks_without_langs} '
          '(${mainCounts.withoutLangsCount})',
          onPressed: _onTasksWithoutLangsButtonPressed),
      const SizedBox(height: 8),
      ButtonFilledPlante.withText(
          '${context.strings.web_moderator_tasks_categories_page_all_tasks} '
          '(${mainCounts.totalCount})',
          onPressed: _onAllTasksButtonPressed),
      const SizedBox(height: 8),
      ButtonOutlinedPlante.withText(
          '${context.strings.web_moderator_tasks_categories_page_off_products_tasks} '
          '(${offCounts.totalCount})',
          onPressed: _onOffProductsTasksButtonPressed),
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
    ]);

    return Scaffold(body: Center(child: SizedBox(width: 500, child: content)));
  }

  void _onLangButtonPress(String lang) {
    ModeratorTasksListPage.openForLang(context, lang,
        excludeTypes: [_OFF_PRODUCT_TASK_TYPE]);
  }

  void _onAllTasksButtonPressed() {
    ModeratorTasksListPage.openForAllLangs(context,
        excludeTypes: [_OFF_PRODUCT_TASK_TYPE]);
  }

  void _onOffProductsTasksButtonPressed() {
    ModeratorTasksListPage.openForAllLangs(context,
        includeTypes: [_OFF_PRODUCT_TASK_TYPE]);
  }

  void _onTasksWithoutLangsButtonPressed() {
    ModeratorTasksListPage.openForTasksWithoutLangs(context,
        excludeTypes: [_OFF_PRODUCT_TASK_TYPE]);
  }
}
