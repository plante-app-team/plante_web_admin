import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:plante/logging/log.dart';
import 'package:plante/outside/backend/backend.dart';
import 'package:plante/l10n/strings.dart';
import 'package:plante/outside/map/open_street_map.dart';
import 'package:plante/ui/base/components/button_outlined_plante.dart';
import 'package:plante/ui/base/components/input_field_plante.dart';
import 'package:plante/ui/base/snack_bar_utils.dart';
import 'package:plante/ui/base/text_styles.dart';
import 'package:plante/ui/base/ui_utils.dart';
import 'package:plante_web_admin/backend_extensions.dart';
import 'package:plante_web_admin/ui/map/markers_building.dart';

const _PRODUCTS_LIMIT_DEFAULT = 100;

class RecentlyAddedProductsMapPage extends StatefulWidget {
  const RecentlyAddedProductsMapPage({Key? key}) : super(key: key);

  @override
  _RecentlyAddedProductsMapPageState createState() =>
      _RecentlyAddedProductsMapPageState();
}

class _RecentlyAddedProductsMapPageState
    extends State<RecentlyAddedProductsMapPage> {
  final _backend = GetIt.I.get<Backend>();
  final _osm = GetIt.I.get<OpenStreetMap>();

  Set<Marker>? _markers;
  var _productsLimit = _PRODUCTS_LIMIT_DEFAULT;

  final _limitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _limitController.text = _productsLimit.toString();
    _reload();
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
            ids: backendShops.map((e) => e.osmId).toSet()));
    if (osmShopsRes.isErr) {
      showSnackBar(context.strings.global_something_went_wrong, context);
      return;
    }

    final osmShopsMap = {
      for (var shop in osmShopsRes.unwrap()) shop.osmId: shop
    };

    final markers = <Marker>{};
    var index = 0;
    for (final shop in backendShops) {
      index += 1;
      final osmShop = osmShopsMap[shop.osmId];
      if (osmShop == null) {
        Log.w('Backend shop not found in OSM: $shop');
        continue;
      }
      markers.add(await buildMarker(index, osmShop.coord, context));
    }
    setState(() {
      _markers = markers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      GoogleMap(
        mapToolbarEnabled: false,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        initialCameraPosition:
            const CameraPosition(target: LatLng(51.509865, -0.118092), zoom: 3),
        onMapCreated: (GoogleMapController controller) {},
        markers: _markers ?? const {},
      ),
      Column(children: [
        const SizedBox(height: 25),
        Center(
            child: SizedBox(
                width: 1000,
                child: Text(
                    context.strings.web_recently_added_products_map_page_descr
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
      ]),
      AnimatedSwitcher(
          duration: DURATION_DEFAULT,
          child: _markers == null
              ? const LinearProgressIndicator()
              : const SizedBox.shrink())
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
