import 'package:flutter/widgets.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:plante/ui/base/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkifyUrl extends StatelessWidget {
  final String url;
  const LinkifyUrl(this.url, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectableLinkify(
      text: url,
      linkStyle: TextStyles.url,
      onOpen: (e) {
        launch(e.url);
      },
    );
  }
}
