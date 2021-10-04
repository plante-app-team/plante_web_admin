import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:plante/base/base.dart';
import 'package:plante/logging/log.dart';
import 'package:plante/model/product.dart';
import 'package:plante/ui/base/colors_plante.dart';
import 'package:plante/ui/base/components/uri_image_plante.dart';
import 'package:plante/ui/base/ui_utils.dart';

// Stolen from ProductCard
class SocialMediaProductSquareImage extends StatefulWidget {
  final Product product;

  const SocialMediaProductSquareImage({Key? key, required this.product})
      : super(key: key);

  @override
  _SocialMediaProductSquareImageState createState() =>
      _SocialMediaProductSquareImageState();
}

class _SocialMediaProductSquareImageState
    extends State<SocialMediaProductSquareImage> {
  Color? dominantColor;

  _SocialMediaProductSquareImageState();

  @override
  Widget build(BuildContext context) {
    Uri? uri;
    // ignore: prefer_function_declarations_over_variables
    final imageProviderCallback = (ImageProvider provider) async {
      if (dominantColor != null || isInTests()) {
        // PaletteGenerator.fromImageProvider is not very friendly with
        // tests - it starts a timer and gives no way to stop it, tests
        // hate that.
        return;
      }
      final paletteGenerator =
          await PaletteGenerator.fromImageProvider(provider);
      if (mounted) {
        setState(() {
          dominantColor = paletteGenerator.dominantColor?.color ??
              ColorsPlante.primaryDisabled;
          _dominantColorsCache[uri!] = dominantColor!;
        });
      }
    };
    final img = photo(imageProviderCallback);
    uri = img?.uri;
    Color defaultDominantColor = ColorsPlante.primaryDisabled;
    if (uri != null && _dominantColorsCache.containsKey(uri)) {
      defaultDominantColor = _dominantColorsCache[uri]!;
    }

    return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: Column(children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            AnimatedContainer(
              height: 109 * 1.3,
              duration: DURATION_DEFAULT,
              padding: const EdgeInsets.all(10 * 1.3),
              decoration: BoxDecoration(
                color: dominantColor?.withAlpha(150) ?? defaultDominantColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: img,
                  )),
            ),
          ]),
        ]));
  }

  UriImagePlante? photo(
      dynamic Function(ImageProvider image) imageProviderCallback) {
    final Uri uri;
    if (widget.product.imageFrontThumb != null) {
      uri = widget.product.imageFrontThumb!;
    } else if (widget.product.imageFront != null) {
      uri = widget.product.imageFront!;
    } else {
      Log.w(
          "Product in SocialMediaProductSquareImage doesn't have a front image: "
          '${widget.product}');
      return null;
    }
    return UriImagePlante(uri, imageProviderCallback: imageProviderCallback);
  }
}

final _dominantColorsCache = <Uri, Color>{};
