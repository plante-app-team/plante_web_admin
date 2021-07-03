import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get_it/get_it.dart';
import 'package:plante/model/veg_status.dart';
import 'package:plante/outside/backend/backend.dart';
import 'package:plante/outside/backend/backend_product.dart';
import 'package:plante_web_admin/model/moderator_task.dart';
import 'package:plante_web_admin/ui/moderator_task/_initial_page.dart';
import 'package:plante_web_admin/ui/moderator_task/veg_statuses_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '_next_page_callback.dart';

class ProductChangeTaskPage extends StatefulWidget {
  final NextPageCallback callback;
  final ModeratorTask task;
  final BackendProduct backendProduct;

  ProductChangeTaskPage(this.callback, this.task, this.backendProduct);

  @override
  _ProductChangeTaskPageState createState() =>
      _ProductChangeTaskPageState(callback, task, backendProduct);
}

class _ProductChangeTaskPageState extends State<ProductChangeTaskPage> {
  final _backend = GetIt.I.get<Backend>();

  final NextPageCallback callback;
  final ModeratorTask task;
  final BackendProduct product;

  bool loading = false;

  VegStatus? vegetarianStatus;
  VegStatus? veganStatus;
  bool moderated = false;

  bool get canSend {
    if (vegetarianStatus == null || veganStatus == null) {
      return false;
    }
    return moderated;
  }

  _ProductChangeTaskPageState(this.callback, this.task, BackendProduct product)
      : product = product,
        vegetarianStatus =
            VegStatus.safeValueOf(product.vegetarianStatus ?? ""),
        veganStatus = VegStatus.safeValueOf(product.veganStatus ?? "");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            width: 700,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              if (loading) CircularProgressIndicator(),
              Text("Продукт создан/изменён",
                  style: Theme.of(context).textTheme.headline5),
              Text("Пожалуйста, убедитесь, что продукт в Open Food Facts:\n"
                  "- имеет нормальное фото упаковки\n"
                  "- имеет нормальное фото состава\n"
                  "- текст состава соответствует фото\n"
                  "- имя бренда и категорий, если есть, соответствуют продукту.\n"
                  "По составу продукта в Open Food Facts (и возможно гуглением) "
                  "нужно понять правильные вег-статусы продукта и выбрать их."),
              SizedBox(height: 50),
              if (product.barcode.isNotEmpty)
                Row(children: [
                  Text("Продукт: ",
                      style: Theme.of(context).textTheme.headline6),
                  Linkify(
                    text:
                        "https://ru.openfoodfacts.org/product/${task.barcode}/",
                    onOpen: (e) {
                      launch(e.url);
                    },
                  )
                ]),
              if (product.barcode.isEmpty)
                Text(
                    "Пустой продукт - произошла серверная ошибка. "
                    "Нажмите \"Промодерировано\" и сообщите о об ошибке разработчику",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: Colors.red)),
              Row(children: [
                Text("Пользователь: ",
                    style: Theme.of(context).textTheme.headline6),
                SelectableText(task.taskSourceUserId)
              ]),
              vegStatusesWidget(product),
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

  Widget vegStatusesWidget(BackendProduct product) =>
      VegStatusesWidget((vegetarianStatus, veganStatus) {
        setState(() {
          this.vegetarianStatus = vegetarianStatus;
          this.veganStatus = veganStatus;
        });
      }, true, vegetarianStatus, product.vegetarianStatusSource, veganStatus,
          product.veganStatusSource);

  void onSendClicked() async {
    try {
      setState(() {
        loading = true;
      });
      if (task.barcode != null && task.barcode!.trim().isNotEmpty) {
        final resp =
            await _backend.customGet("moderate_product_veg_statuses/", {
          "barcode": task.barcode!,
          "vegetarianStatus": vegetarianStatus!.name,
          "veganStatus": veganStatus!.name
        });
        assert(jsonDecode(resp.body)["result"] == "ok");
      }
      final resp = await _backend
          .customGet("resolve_moderator_task/", {"taskId": task.id.toString()});
      assert(jsonDecode(resp.body)["result"] == "ok");
      callback.call(InitialPage(callback));
    } finally {
      setState(() {
        loading = false;
      });
    }
  }
}
