import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:plante/outside/backend/backend.dart';
import 'package:plante/outside/backend/backend_product.dart';
import 'package:plante_web_admin/model/moderator_task.dart';
import 'package:plante_web_admin/ui/moderator_task/osm_shop_creation_task_page.dart';

import 'next_page_callback.dart';
import 'no_tasks_page.dart';
import 'product_change_task_page.dart';
import 'user_report_task_page.dart';

class InitialPage extends StatefulWidget {
  final NextPageCallback callback;

  const InitialPage(this.callback, {Key? key}) : super(key: key);

  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final _backend = GetIt.I.get<Backend>();
  NextPageCallback get callback => widget.callback;

  @override
  Widget build(BuildContext context) {
    () async {
      var tasks = await retrieveTasks();
      if (tasks.isEmpty) {
        await assignTask();
        tasks = await retrieveTasks();
      }
      if (tasks.isNotEmpty) {
        final task = tasks[0];
        final BackendProduct? product;
        if (task.barcode != null && task.barcode!.trim().isNotEmpty) {
          product = await retrieveProduct(task.barcode!);
        } else {
          product = null;
        }

        if (task.taskType == "user_report") {
          callback.call(UserReportTaskPage(callback, tasks[0], product));
        } else if (task.taskType == "product_change") {
          callback.call(ProductChangeTaskPage(
              callback, tasks[0], product ?? BackendProduct.empty));
        } else if (task.taskType == "osm_shop_creation") {
          callback
              .call(OsmShopCreationTaskPage(callback, tasks[0], task.osmId!));
        } else {
          callback.call(Text("Error: unknown task type ${task.taskType}"));
        }
      } else {
        callback.call(NoTasksPage());
      }
    }.call();

    return Center(child: CircularProgressIndicator());
  }

  Future<List<ModeratorTask>> retrieveTasks() async {
    final resp = await _backend.customGet("assigned_moderator_tasks_data/");
    final json = jsonDecode(resp.body);
    final tasksJson = json['tasks'] as List<dynamic>;
    return tasksJson
        .map((e) => ModeratorTask.fromJson(e as Map<String, dynamic>)!)
        .toList();
  }

  Future<void> assignTask() async {
    final resp = await _backend.customGet("assign_moderator_task/");
    final json = jsonDecode(resp.body);
    assert(
        json["result"] == "ok" ||
            json["error"] == "no_unresolved_moderator_tasks",
        json);
  }

  Future<BackendProduct?> retrieveProduct(String barcode) async {
    final resp =
        await _backend.customGet("product_data/", {"barcode": barcode});
    final json = jsonDecode(resp.body);
    if (json["error"] == "product_not_found") {
      return null;
    }
    return BackendProduct.fromJson(json);
  }
}
