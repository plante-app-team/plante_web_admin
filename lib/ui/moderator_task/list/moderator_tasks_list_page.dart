import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:plante/base/base.dart';
import 'package:plante/outside/backend/backend.dart';
import 'package:plante/ui/base/components/button_outlined_plante.dart';
import 'package:plante/ui/base/snack_bar_utils.dart';
import 'package:plante_web_admin/model/moderator_task.dart';
import 'package:plante_web_admin/ui/moderator_task/list/moderator_task_list_item.dart';
import 'package:plante_web_admin/ui/moderator_task/no_tasks_page.dart';
import 'package:plante/l10n/strings.dart';

class ModeratorTasksListPage extends StatefulWidget {
  static const NAME = '/list_moderator_tasks';
  final String? lang;
  final bool tasksWithoutLangs;
  final List<String> includeTypes = [];
  final List<String> excludeTypes = [];

  @override
  _ModeratorTasksListPageState createState() => _ModeratorTasksListPageState();

  ModeratorTasksListPage.createFor(Uri uri)
      : lang = uri.queryParameters['lang'],
        tasksWithoutLangs = uri.queryParameters['tasksWithoutLangs'] == 'true' {
    if (uri.queryParameters.containsKey('includeTypes')) {
      includeTypes.addAll(uri.queryParameters['includeTypes']!.split('.'));
    }
    if (uri.queryParameters.containsKey('excludeTypes')) {
      excludeTypes.addAll(uri.queryParameters['excludeTypes']!.split('.'));
    }
  }

  static Future<void> openForLang(BuildContext context, String lang,
      {List<String> includeTypes = const [],
      List<String> excludeTypes = const []}) async {
    final typesParams = makeTypesParams(includeTypes, excludeTypes);
    await Navigator.pushNamed(context, '$NAME?lang=$lang$typesParams');
  }

  static String makeTypesParams(
      List<String> includeTypes, List<String> excludeTypes) {
    var includeParam = '';
    if (includeTypes.isNotEmpty) {
      includeParam = 'includeTypes=${includeTypes.join('.')}';
    }
    var excludeParam = '';
    if (excludeTypes.isNotEmpty) {
      excludeParam = 'excludeTypes=${excludeTypes.join('.')}';
    }
    final result = [
      if (includeParam.isNotEmpty) includeParam,
      if (excludeParam.isNotEmpty) excludeParam,
    ];
    if (result.isNotEmpty) {
      return '&' + result.join('&');
    }
    return '';
  }

  static Future<void> openForAllLangs(BuildContext context,
      {List<String> includeTypes = const [],
      List<String> excludeTypes = const []}) async {
    final typesParams = makeTypesParams(includeTypes, excludeTypes);
    await Navigator.pushNamed(context, '$NAME?$typesParams');
  }

  static Future<void> openForTasksWithoutLangs(BuildContext context,
      {List<String> includeTypes = const [],
      List<String> excludeTypes = const []}) async {
    final typesParams = makeTypesParams(includeTypes, excludeTypes);
    await Navigator.pushNamed(
        context, '$NAME?tasksWithoutLangs=true$typesParams');
  }
}

class _ModeratorTasksListPageState extends State<ModeratorTasksListPage> {
  final _backend = GetIt.I.get<Backend>();
  var _loading = true;
  var _pageNumber = 0;
  var _page = <ModeratorTask>[];
  var _nextPage = <ModeratorTask>[];

  @override
  void initState() {
    super.initState();
    _moveToPage(0);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(child: CircularProgressIndicator());
    }
    if (_page.isEmpty) {
      return Scaffold(body: Center(child: NoTasksPage()));
    }
    return Scaffold(
        body: Center(
            child: SizedBox(
                width: 1000,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: 300,
                                child: ButtonOutlinedPlante.withText(
                                    context.strings
                                        .web_moderator_tasks_list_page_backward,
                                    onPressed:
                                        _pageNumber > 0 ? _pageBack : null)),
                            SizedBox(
                                width: 300,
                                child: ButtonOutlinedPlante.withText(
                                    context.strings
                                        .web_moderator_tasks_list_page_forward,
                                    onPressed: _nextPage.isNotEmpty
                                        ? _pageForward
                                        : null)),
                          ]),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _page
                              .map((e) => _ListItemWrapper(
                                  ModeratorTaskListItem(e), e, _onTaskClick))
                              .toList())
                    ]))));
  }

  void _onTaskClick(ModeratorTask task) async {
    await Navigator.pushNamed(
        context, '/unassigned_moderator_task?taskId=${task.id}');
    _reload();
  }

  void _pageBack() {
    _moveToPage(_pageNumber - 1);
  }

  void _pageForward() {
    _moveToPage(_pageNumber + 1);
  }

  void _reload() {
    _moveToPage(_pageNumber);
  }

  void _moveToPage(int pageNumber) async {
    _performNetworkAction(() async {
      _pageNumber = pageNumber;
      final resp1 = await _backend.customGet(
          'all_moderator_tasks_data/', _queryParamsForPage(_pageNumber));
      final resp2 = await _backend.customGet(
          'all_moderator_tasks_data/', _queryParamsForPage(_pageNumber + 1));

      final json1 = jsonDecode(resp1.body);
      final json2 = jsonDecode(resp2.body);

      _page = (json1['tasks'] as List<dynamic>)
          .map((e) => ModeratorTask.fromJson(e as Map<String, dynamic>))
          .toList();
      _nextPage = (json2['tasks'] as List<dynamic>)
          .map((e) => ModeratorTask.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }

  Map<String, dynamic> _queryParamsForPage(int page) {
    return {
      'page': page.toString(),
      if (widget.lang != null) 'lang': widget.lang!,
      if (widget.tasksWithoutLangs) 'onlyWithNoLang': 'true',
      if (widget.includeTypes.isNotEmpty) 'includeTypes': widget.includeTypes,
      if (widget.excludeTypes.isNotEmpty) 'excludeTypes': widget.excludeTypes,
    };
  }

  void _performNetworkAction(dynamic Function() action) async {
    try {
      setState(() {
        _loading = true;
      });
      await action.call();
    } catch (e) {
      showSnackBar(e.toString(), context);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
}

class _ListItemWrapper extends StatelessWidget {
  final Widget child;
  final ModeratorTask task;
  final ArgCallback<ModeratorTask> callback;
  const _ListItemWrapper(this.child, this.task, this.callback, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  callback.call(task);
                },
                child: child,
              ),
            ),
          )),
    );
  }
}
