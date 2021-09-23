import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:plante/ui/base/text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plante/model/coord.dart';

Future<Marker> buildMarker(
    int number, Coord coord, BuildContext context) async {
  return Marker(
    markerId: MarkerId(number.toString()),
    position: LatLng(coord.lat, coord.lon),
    icon: await _getMarkerBitmap(number, context),
    zIndex: -number.toDouble(),
  );
}

Future<BitmapDescriptor> _getMarkerBitmap(
    int number, BuildContext context) async {
  return await _bitmapDescriptorFromSvgAsset(
      context,
      'assets/map_marker_latest_product_order.svg',
      number,
      TextStyles.markerFilled);
}

final _imagePaint = Paint();
final _textPainter = TextPainter(textDirection: TextDirection.ltr);
final _assetsCache = <String, DrawableRoot>{};

/// Copy of a function with same name from the Plante project
Future<BitmapDescriptor> _bitmapDescriptorFromSvgAsset(BuildContext context,
    String assetName, int number, TextStyle textStyle) async {
  final pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);

  // Marker image
  var size = 45.0; // SVG original size
  final DrawableRoot svgDrawableRoot;
  if (_assetsCache.containsKey(assetName)) {
    svgDrawableRoot = _assetsCache[assetName]!;
  } else {
    final svgString =
        await DefaultAssetBundle.of(context).loadString(assetName);
    svgDrawableRoot = await svg.fromSvgString(svgString, '');
    _assetsCache[assetName] = svgDrawableRoot;
  }
  // toPicture() and toImage() don't seem to be pixel ratio aware,
  // so we calculate the actual sizes here
  final queryData = MediaQuery.of(context);
  final devicePixelRatio = queryData.devicePixelRatio;
  size = size * devicePixelRatio;
  final picture = svgDrawableRoot.toPicture(size: Size(size, size));
  final image = await picture.toImage(size.round(), size.round());
  canvas.drawImage(image, Offset.zero, _imagePaint);

  // Text
  _textPainter.text = TextSpan(
      text: number.toString(),
      style:
          textStyle.copyWith(fontSize: textStyle.fontSize! * devicePixelRatio));
  _textPainter.layout();
  // Magic numbers! Figured out manually, might be wrong
  final double xOffset;
  if (number == 2) {
    xOffset = 23 * devicePixelRatio;
  } else if (number == 4) {
    xOffset = 22.5 * devicePixelRatio;
  } else if (number == 6) {
    xOffset = 22.75 * devicePixelRatio;
  } else if (number == 8) {
    xOffset = 23 * devicePixelRatio;
  } else if (number > 9) {
    xOffset = 23 * devicePixelRatio;
  } else {
    xOffset = 23.5 * devicePixelRatio;
  }

  final yOffset = 10.5 * devicePixelRatio;
  _textPainter.paint(canvas, Offset(xOffset - _textPainter.width / 2, yOffset));

  final img =
      await pictureRecorder.endRecording().toImage(size.round(), size.round());
  final data = await img.toByteData(format: ui.ImageByteFormat.png);

  return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
}
