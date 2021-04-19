import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:untitled_vegan_app_web_admin/backend.dart';
import 'package:untitled_vegan_app_web_admin/model/backend_product.dart';
import 'package:untitled_vegan_app_web_admin/model/moderator_task.dart';
import 'package:untitled_vegan_app_web_admin/model/veg_status.dart';
import 'package:untitled_vegan_app_web_admin/ui/moderator_task/_initial_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '_next_page_callback.dart';

class UserReportTaskPage extends StatefulWidget {
  final NextPageCallback callback;
  final ModeratorTask task;
  final BackendProduct? backendProduct;

  UserReportTaskPage(this.callback, this.task, this.backendProduct);

  @override
  _UserReportTaskPageState createState() =>
      _UserReportTaskPageState(callback, task, backendProduct);
}

class _UserReportTaskPageState extends State<UserReportTaskPage> {
  final NextPageCallback callback;
  final ModeratorTask task;
  final BackendProduct? product;

  bool loading = false;

  bool editVegStatuses = false;
  VegStatus? vegetarianStatus;
  VegStatus? veganStatus;
  bool moderated = false;

  bool get canSend {
    if (editVegStatuses) {
      if (vegetarianStatus == null || veganStatus == null) {
        return false;
      }
    }
    return moderated;
  }

  _UserReportTaskPageState(this.callback, this.task, BackendProduct? product):
      product = product,
      vegetarianStatus = VegStatus.safeValueOf(product?.vegetarianStatus ?? ""),
      veganStatus = VegStatus.safeValueOf(product?.veganStatus ?? "");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: SizedBox(width: 700, child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (loading) CircularProgressIndicator(),
          Row(children: [
            Text("Продукт: ", style: Theme.of(context).textTheme.headline6),
            Linkify(
              text: "https://ru.openfoodfacts.org/product/${task.barcode}/",
              onOpen: (e) {
                launch(e.url);
              },
            )
          ]),
          Row(children: [
            Text("Жалоба: ", style: Theme.of(context).textTheme.headline6),
            SizedBox(width: 400, child: Text(
                task.textFromUser ?? "NO TEXT",
                maxLines: null,
                textAlign: TextAlign.left))
          ]),

          if (product != null) vegStatusesWidget(product!),
          if (product == null) SizedBox(width: double.infinity, child: Text(
              "Продукт существует только в Open Food Facts")),

          SizedBox(height: 50),

          Row(children: [
            Checkbox(
                value: moderated,
                onChanged: (bool? value) {
                  setState(() {
                    moderated = value ?? false;
                  });
                }),
            Text("Промодерировано")
          ]),
          OutlinedButton(
              child: Text("Отправить"),
              onPressed: canSend ? onSendClicked : null)
    ])));
  }

  Widget vegStatusesWidget(BackendProduct product) {
    return Row(children: [
      Column(children: [
        Row(children: [
          Checkbox(
              value: editVegStatuses,
              onChanged: (bool? value) {
                setState(() {
                  editVegStatuses = value ?? false;
                });
                if (editVegStatuses) {
                  showModerateBothStatusesWarning();
                }
              }),
          Text("Изменить вег-статусы")
        ]),

        Text("Вегетарианский статус, источник: ${product.vegetarianStatusSource}"),
        Row(children: [
          Row(children: [
            Radio<VegStatus>(
                value: VegStatus.positive,
                groupValue: vegetarianStatus,
                onChanged: !editVegStatuses ? null : (VegStatus? value) {
                  setState(() {
                    vegetarianStatus = value;
                  });
                }),
            Text("Точно да"),
          ]),
          Row(children: [
            Radio<VegStatus>(
                value: VegStatus.negative,
                groupValue: vegetarianStatus,
                onChanged: !editVegStatuses ? null : (VegStatus? value) {
                  setState(() {
                    vegetarianStatus = value;
                  });
                }),
            Text("Точно нет"),
          ]),
          Row(children: [
            Radio<VegStatus>(
                value: VegStatus.possible,
                groupValue: vegetarianStatus,
                onChanged: !editVegStatuses ? null : (VegStatus? value) {
                  setState(() {
                    vegetarianStatus = value;
                  });
                }),
            Text("Возможно, зависит от производства"),
          ]),
          Row(children: [
            Radio<VegStatus>(
                value: VegStatus.unknown,
                groupValue: vegetarianStatus,
                onChanged: !editVegStatuses ? null : (VegStatus? value) {
                  setState(() {
                    vegetarianStatus = value;
                  });
                }),
            Text("Непонятно"),
          ]),
        ]),
      ]),
      Column(children: [
        Text("Веганский статус, источник: ${product.veganStatusSource}"),
        Row(children: [
          Row(children: [
            Radio<VegStatus>(
                value: VegStatus.positive,
                groupValue: veganStatus,
                onChanged: !editVegStatuses ? null : (VegStatus? value) {
                  setState(() {
                    veganStatus = value;
                  });
                }),
            Text("Точно да"),
          ]),
          Row(children: [
            Radio<VegStatus>(
                value: VegStatus.negative,
                groupValue: veganStatus,
                onChanged: !editVegStatuses ? null : (VegStatus? value) {
                  setState(() {
                    veganStatus = value;
                  });
                }),
            Text("Точно нет"),
          ]),
          Row(children: [
            Radio<VegStatus>(
                value: VegStatus.possible,
                groupValue: veganStatus,
                onChanged: !editVegStatuses ? null : (VegStatus? value) {
                  setState(() {
                    veganStatus = value;
                  });
                }),
            Text("Возможно, зависит от производства"),
          ]),
          Row(children: [
            Radio<VegStatus>(
                value: VegStatus.unknown,
                groupValue: veganStatus,
                onChanged: !editVegStatuses ? null : (VegStatus? value) {
                  setState(() {
                    veganStatus = value;
                  });
                }),
            Text("Непонятно"),
          ]),
        ]),
      ])
    ]);
  }

  void showModerateBothStatusesWarning() {
    Widget okButton = OutlinedButton(
      child: Text("OK"),
      onPressed: () { Navigator.of(context).pop(); },
    );
    AlertDialog alert = AlertDialog(
      content: Text("Пожалуйста, промодерируйте оба статуса - и вегетарианский, и веганский"),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void onSendClicked() async {
    try {
      setState(() {
        loading = true;
      });
      if (editVegStatuses) {
        final resp = await Backend.get("moderate_product_veg_statuses/", {
          "barcode": task.barcode,
          "vegetarianStatus": vegetarianStatus!.name,
          "veganStatus": veganStatus!.name
        });
        assert(jsonDecode(resp.body)["result"] == "ok");
      }
      final resp = await Backend.get("resolve_moderator_task/", {
        "taskId": task.id.toString()
      });
      assert(jsonDecode(resp.body)["result"] == "ok");
      callback.call(InitialPage(callback));
    } finally {
      setState(() {
        loading = false;
      });
    }
  }
}
