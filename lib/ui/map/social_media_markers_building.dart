import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:plante/model/shop.dart';
import 'package:plante/ui/base/text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef SocialMediaMarkerClick<T> = void Function(Shop shop, Marker marker);

Future<Marker> buildMarker(
    Shop shop, BuildContext context, SocialMediaMarkerClick onTap) async {
  Marker? marker;
  marker = Marker(
      markerId: MarkerId(shop.osmUID.toString()),
      position: LatLng(shop.latitude, shop.longitude),
      icon: await _getMarkerBitmap(context),
      onTap: () {
        onTap.call(shop, marker!);
      });
  return marker;
}

Future<BitmapDescriptor> _getMarkerBitmap(BuildContext context) async {
  return await _bitmapDescriptorFromSvgAsset(
      context, 'assets/social_media_map_marker.svg', TextStyles.markerFilled);
}

final _imagePaint = Paint();
final _assetsCache = <String, DrawableRoot>{};

/// Copy of a function with same name from the Plante project
Future<BitmapDescriptor> _bitmapDescriptorFromSvgAsset(
    BuildContext context, String assetName, TextStyle textStyle) async {
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

  final img =
      await pictureRecorder.endRecording().toImage(size.round(), size.round());
  final data = await img.toByteData(format: ui.ImageByteFormat.png);

  return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
}
