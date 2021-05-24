import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:plante_web_admin/backend.dart';
import 'package:plante_web_admin/model/moderator_task.dart';
import 'package:url_launcher/url_launcher.dart';

import '_initial_page.dart';
import '_next_page_callback.dart';

class OsmShopCreationTaskPage extends StatefulWidget {
  final NextPageCallback callback;
  final ModeratorTask task;
  final String osmId;

  const OsmShopCreationTaskPage(this.callback, this.task, this.osmId, {Key? key}) : super(key: key);

  @override
  _OsmShopCreationTaskPageState createState() => _OsmShopCreationTaskPageState();
}

class _OsmShopCreationTaskPageState extends State<OsmShopCreationTaskPage> {
  bool loading = false;
  bool moderated = false;

  bool get canSend => moderated;

  @override
  Widget build(BuildContext context) {
    return Center(child: SizedBox(width: 700, child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (loading) CircularProgressIndicator(),

          Text("Магазин создан в Open Street Map", style: Theme.of(context).textTheme.headline5),
          Text("Пожалуйста, убедитесь, что созданный магазин в Open Street Map:\n"
              "- имеет нормальное название\n"
              "- имеет правдоподобную локацию\n"
              "Если с магазином что-то не так, его следует удалить"),
          SizedBox(height: 50),

          Row(children: [
            Text("Магазин: ", style: Theme.of(context).textTheme.headline6),
            Linkify(
              text: "https://www.openstreetmap.org/node/${widget.task.osmId}/",
              onOpen: (e) {
                launch(e.url);
              },
            )
          ]),
          Row(children: [
            Text("Пользователь: ", style: Theme.of(context).textTheme.headline6),
            SelectableText(widget.task.taskSourceUserId)
          ]),

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

  void onSendClicked() async {
    try {
      setState(() {
        loading = true;
      });
      final resp = await Backend.get("resolve_moderator_task/", {
        "taskId": widget.task.id.toString()
      });
      assert(jsonDecode(resp.body)["result"] == "ok");
      widget.callback.call(InitialPage(widget.callback));
    } finally {
      setState(() {
        loading = false;
      });
    }
  }
}
