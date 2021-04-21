import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:plante_web_admin/backend.dart';
import 'package:plante_web_admin/model/backend_product.dart';
import 'package:plante_web_admin/model/moderator_task.dart';

import '_next_page_callback.dart';
import '_no_tasks_page.dart';
import '_product_change_task_page.dart';
import '_user_report_task_page.dart';

class InitialPage extends StatelessWidget {
  final NextPageCallback callback;

  InitialPage(this.callback);
  
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
        final product = await retrieveProduct(task.barcode);

        if (task.taskType == "user_report") {
          callback.call(UserReportTaskPage(callback, tasks[0], product));
        } else if (task.taskType == "product_change") {
          callback.call(ProductChangeTaskPage(callback, tasks[0], product!));
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
    final resp = await Backend.get("assigned_moderator_tasks_data/");
    final json = jsonDecode(resp.body);
    final tasksJson = json['tasks'] as List<dynamic>;
    return tasksJson.map((e) => ModeratorTask.fromJson(e as Map<String, dynamic>)!).toList();
  }

  Future<void> assignTask() async {
    final resp = await Backend.get("assign_moderator_task/");
    final json = jsonDecode(resp.body);
    assert(json["result"] == "ok" || json["error"] == "no_unresolved_moderator_tasks", json);
  }

  Future<BackendProduct?> retrieveProduct(String barcode) async {
    final resp = await Backend.get("product_data/", { "barcode": barcode });
    final json = jsonDecode(resp.body);
    if (json["error"] == "product_not_found") {
      return null;
    }
    return BackendProduct.fromJson(json);
  }
}
