import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:plante/logging/log.dart';
import 'package:plante/model/product.dart';
import 'package:plante/model/shop.dart';
import 'package:plante/outside/backend/backend.dart';
import 'package:plante/l10n/strings.dart';
import 'package:plante/outside/map/open_street_map.dart';
import 'package:plante/ui/base/components/button_outlined_plante.dart';
import 'package:plante/ui/base/components/checkbox_plante.dart';
import 'package:plante/ui/base/components/input_field_plante.dart';
import 'package:plante/ui/base/snack_bar_utils.dart';
import 'package:plante/ui/base/text_styles.dart';
import 'package:plante/ui/base/ui_utils.dart';
import 'package:plante_web_admin/backend_extensions.dart';
import 'package:plante_web_admin/ui/components/checkbox_text.dart';
import 'package:plante_web_admin/ui/components/positioned_draggable_widget.dart';
import 'package:plante_web_admin/ui/map/select_products_dialog.dart';
import 'package:plante_web_admin/ui/map/social_media_markers_building.dart';
import 'package:plante_web_admin/ui/map/social_media_product_square_image.dart';

const _PRODUCTS_LIMIT_DEFAULT = 100;

class SocialMediaAddedProductsMapPage extends StatefulWidget {
  const SocialMediaAddedProductsMapPage({Key? key}) : super(key: key);

  @override
  _SocialMediaAddedProductsMapPageState createState() =>
      _SocialMediaAddedProductsMapPageState();
}

class _SocialMediaAddedProductsMapPageState
    extends State<SocialMediaAddedProductsMapPage> {
  final _backend = GetIt.I.get<Backend>();
  final _osm = GetIt.I.get<OpenStreetMap>();
  final _mapController = Completer<GoogleMapController>();

  var _showControls = true;
  var _enableMapGestures = true;

  Map<Shop, Marker>? _markers;
  final _productsImages = <Widget>[];

  var _productsLimit = _PRODUCTS_LIMIT_DEFAULT;
  final _limitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _limitController.text = _productsLimit.toString();
    _initMapAsync();
    _reload();
  }

  void _initMapAsync() async {
    final mapController = await _mapController.future;
    // https://developers.google.com/maps/documentation/javascript/style-reference
    const noBusinessesStyle = '''
      [
        {
          "featureType": "poi.business",
          "elementType": "all",
          "stylers": [ { "visibility": "off" } ]
        },
        {
          "featureType": "poi.attraction",
          "elementType": "all",
          "stylers": [ { "visibility": "off" } ]
        },
        {
          "featureType": "poi.government",
          "elementType": "all",
          "stylers": [ { "visibility": "off" } ]
        },
        {
          "featureType": "poi.medical",
          "elementType": "all",
          "stylers": [ { "visibility": "off" } ]
        },
                {
          "featureType": "poi.place_of_worship",
          "elementType": "all",
          "stylers": [ { "visibility": "off" } ]
        },
        {
          "featureType": "poi.school",
          "elementType": "all",
          "stylers": [ { "visibility": "off" } ]
        },
        {
          "featureType": "road.arterial",
          "elementType": "labels",
          "stylers": [ { "visibility": "off" } ]
        },
        {
          "featureType": "road.highway",
          "elementType": "labels",
          "stylers": [ { "visibility": "off" } ]
        },
        {
          "featureType": "road.local",
          "elementType": "labels",
          "stylers": [ { "visibility": "off" } ]
        },
        {
          "featureType": "transit.station",
          "elementType": "labels",
          "stylers": [ { "visibility": "off" } ]
        }
      ]
      ''';
    await mapController.setMapStyle(noBusinessesStyle);
  }

  void _reload() async {
    setState(() {
      _markers = null;
    });

    final latestProductsRes =
        await _backend.latestProductsAddedToShops(_productsLimit);
    if (latestProductsRes.isErr) {
      showSnackBar(context.strings.global_something_went_wrong, context);
      return;
    }
    final backendShops = latestProductsRes.unwrap().shopsOrdered.toList();
    final osmShopsRes = await _osm.withOverpass((overpass) async =>
        await overpass.fetchShops(
            osmUIDs: backendShops.map((e) => e.osmUID).toSet()));
    if (osmShopsRes.isErr) {
      showSnackBar(context.strings.global_something_went_wrong, context);
      return;
    }

    final osmShopsMap = {
      for (var shop in osmShopsRes.unwrap()) shop.osmUID: shop
    };

    final markers = <Shop, Marker>{};
    for (final backendShop in backendShops) {
      final osmShop = osmShopsMap[backendShop.osmUID];
      if (osmShop == null) {
        Log.w('Backend shop not found in OSM: $backendShop');
        continue;
      }
      final shop = Shop((e) => e
        ..osmShop.replace(osmShop)
        ..backendShop.replace(backendShop));
      markers[shop] = await buildMarker(shop, context, _onShopTap);
    }
    setState(() {
      _markers = markers;
    });
  }

  void _onShopTap(Shop shop, Marker marker) async {
    const DELETE_MARKER = 1;
    const BRING_PRODUCTS_ICONS = 2;

    final items = <PopupMenuItem<int>>[
      PopupMenuItem<int>(
        value: DELETE_MARKER,
        child: Text(context
            .strings.web_social_media_added_products_map_page_hide_marker),
      ),
      PopupMenuItem<int>(
        value: BRING_PRODUCTS_ICONS,
        child: Text(context.strings
            .web_social_media_added_products_map_page_bring_products_icons),
      ),
    ];

    double middleWidth = MediaQuery.of(context).size.width / 2;
    double middleHeight = MediaQuery.of(context).size.height / 2;

    final selected = await showMenu<int?>(
      context: context,
      position: RelativeRect.fromLTRB(
          middleWidth, middleHeight, middleWidth, middleHeight),
      items: items,
    );

    if (selected == DELETE_MARKER) {
      setState(() {
        _markers?.remove(shop);
      });
    } else if (selected == BRING_PRODUCTS_ICONS) {
      _bringProductsIconsToTheMap(shop);
    }
  }

  void _bringProductsIconsToTheMap(Shop shop) async {
    setState(() {
      _enableMapGestures = false;
    });
    final selectedProducts = await showDialog<Iterable<Product>?>(
        context: context,
        builder: (BuildContext context) {
          return SelectProductsDialog(shop: shop);
        });
    setState(() {
      _enableMapGestures = true;
    });

    if (selectedProducts != null) {
      double middleWidth = MediaQuery.of(context).size.width / 2;
      double middleHeight = MediaQuery.of(context).size.height / 2;

      for (final product in selectedProducts) {
        Widget? image;
        image = PositionedDraggableWidget(
          top: middleHeight,
          left: middleWidth,
          onSecondaryTap: () {
            setState(() {
              _productsImages.remove(image);
            });
          },
          child: SocialMediaProductSquareImage(product: product),
        );
        setState(() {
          _productsImages.add(image!);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      GoogleMap(
        rotateGesturesEnabled: _enableMapGestures,
        scrollGesturesEnabled: _enableMapGestures,
        zoomGesturesEnabled: _enableMapGestures,
        tiltGesturesEnabled: _enableMapGestures,
        mapToolbarEnabled: false,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        initialCameraPosition:
            const CameraPosition(target: LatLng(51.509865, -0.118092), zoom: 3),
        onMapCreated: (GoogleMapController controller) {
          _mapController.complete(controller);
        },
        markers: _markers?.values.toSet() ?? const {},
      ),
      if (_showControls)
        Column(children: [
          const SizedBox(height: 25),
          Center(
              child: SizedBox(
                  width: 200,
                  child: Text(
                      context.strings
                          .web_social_media_added_products_map_page_descr
                          .replaceAll('<LIMIT>', '$_productsLimit'),
                      style: TextStyles.headline4))),
          Center(
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(
                        context
                            .strings.web_recently_added_products_map_page_limit,
                        style: TextStyles.headline4),
                    SizedBox(
                        width: 200,
                        child: InputFieldPlante(
                            controller: _limitController,
                            keyboardType: TextInputType.number)),
                    ButtonOutlinedPlante.withText(
                        context
                            .strings.web_recently_added_products_map_page_apply,
                        onPressed: _applyNewLimit),
                  ]))),
          Center(
              child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(
                context.strings
                    .web_social_media_added_products_map_page_enable_map_gestures,
                style: TextStyles.headline4),
            CheckboxPlante(
              value: _enableMapGestures,
              onChanged: (val) {
                setState(() {
                  _enableMapGestures = val ?? false;
                });
              },
            ),
          ])),
        ]),
      ..._productsImages,
      Align(
          alignment: Alignment.topRight,
          child: CheckboxText(
              text: context.strings
                  .web_social_media_added_products_map_page_show_controls,
              value: _showControls,
              onChanged: (value) {
                setState(() {
                  _showControls = value ?? false;
                });
              })),
      AnimatedSwitcher(
          duration: DURATION_DEFAULT,
          child: _markers == null
              ? const LinearProgressIndicator()
              : const SizedBox.shrink()),
    ]));
  }

  void _applyNewLimit() {
    setState(() {
      _productsLimit =
          int.tryParse(_limitController.text) ?? _PRODUCTS_LIMIT_DEFAULT;
    });
    _reload();
  }
}
