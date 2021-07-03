import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get_it/get_it.dart';
import 'package:plante/outside/backend/backend.dart';
import 'package:plante_web_admin/model/moderator_task.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:plante/l10n/strings.dart';

import 'initial_page.dart';
import 'next_page_callback.dart';

class OsmShopCreationTaskPage extends StatefulWidget {
  final NextPageCallback callback;
  final ModeratorTask task;
  final String osmId;

  const OsmShopCreationTaskPage(this.callback, this.task, this.osmId,
      {Key? key})
      : super(key: key);

  @override
  _OsmShopCreationTaskPageState createState() =>
      _OsmShopCreationTaskPageState();
}

class _OsmShopCreationTaskPageState extends State<OsmShopCreationTaskPage> {
  final _backend = GetIt.I.get<Backend>();

  bool loading = false;
  bool moderated = false;

  bool get canSend => moderated;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            width: 700,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              if (loading) CircularProgressIndicator(),
              Text(context.strings.web_osm_shop_creation_task_page_title,
                  style: Theme.of(context).textTheme.headline5),
              Text(context.strings.web_osm_shop_creation_task_page_descr),
              SizedBox(height: 50),
              Row(children: [
                Text(context.strings.web_osm_shop_creation_task_page_shop,
                    style: Theme.of(context).textTheme.headline6),
                Linkify(
                  text:
                      "https://www.openstreetmap.org/node/${widget.task.osmId}/",
                  onOpen: (e) {
                    launch(e.url);
                  },
                )
              ]),
              Row(children: [
                Text(context.strings.web_osm_shop_creation_task_page_user,
                    style: Theme.of(context).textTheme.headline6),
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
                Text(context.strings.web_osm_shop_creation_task_page_moderated)
              ]),
              OutlinedButton(
                  child: Text(
                      context.strings.web_osm_shop_creation_task_page_send),
                  onPressed: canSend ? onSendClicked : null)
            ])));
  }

  void onSendClicked() async {
    try {
      setState(() {
        loading = true;
      });
      final resp = await _backend.customGet(
          "resolve_moderator_task/", {"taskId": widget.task.id.toString()});
      assert(jsonDecode(resp.body)["result"] == "ok");
      widget.callback.call(InitialPage(widget.callback));
    } finally {
      setState(() {
        loading = false;
      });
    }
  }
}
