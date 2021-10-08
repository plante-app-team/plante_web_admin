import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:plante/base/permissions_manager.dart';
import 'package:plante/base/result.dart';
import 'package:plante/base/settings.dart';
import 'package:plante/lang/countries_lang_codes_table.dart';
import 'package:plante/lang/sys_lang_code_holder.dart';
import 'package:plante/lang/user_langs_manager.dart';
import 'package:plante/location/ip_location_provider.dart';
import 'package:plante/location/location_controller.dart';
import 'package:plante/logging/analytics.dart';
import 'package:plante/model/coords_bounds.dart';
import 'package:plante/model/shared_preferences_holder.dart';
import 'package:plante/outside/backend/backend.dart';
import 'package:plante/outside/backend/user_params_auto_wiper.dart';
import 'package:plante/outside/http_client.dart';
import 'package:plante/outside/identity/google_authorizer.dart';
import 'package:plante/outside/map/address_obtainer.dart';
import 'package:plante/outside/map/osm_cached_territory.dart';
import 'package:plante/outside/map/osm_cacher.dart';
import 'package:plante/outside/map/osm_road.dart';
import 'package:plante/outside/map/osm_shop.dart';
import 'package:plante/outside/map/shops_manager.dart';
import 'package:plante/outside/off/off_api.dart';
import 'package:plante/outside/map/open_street_map.dart';
import 'package:plante/model/user_params_controller.dart';
import 'package:plante/outside/products/products_manager.dart';
import 'package:plante/outside/products/products_obtainer.dart';
import 'package:plante/outside/products/taken_products_images_storage.dart';
import 'package:plante/user_params_fetcher.dart';
import 'package:sqflite_common/sqlite_api.dart';

void initDI() {
  GetIt.I.registerSingleton<RouteObserver<ModalRoute>>(
      RouteObserver<ModalRoute>());

  GetIt.I.registerSingleton<Settings>(_FakeSettings());
  GetIt.I.registerSingleton<Analytics>(_FakeAnalytics());
  GetIt.I.registerSingleton<TakenProductsImagesStorage>(
      _FakeTakenProductsImagesStorage());

  GetIt.I.registerSingleton<SharedPreferencesHolder>(SharedPreferencesHolder());
  GetIt.I.registerSingleton<SysLangCodeHolder>(SysLangCodeHolder());
  GetIt.I.registerSingleton<UserParamsController>(UserParamsController());
  GetIt.I.registerSingleton<HttpClient>(HttpClient());
  GetIt.I.registerSingleton<OpenStreetMap>(
      OpenStreetMap(GetIt.I.get<HttpClient>(), GetIt.I.get<Analytics>()));
  GetIt.I.registerSingleton<GoogleAuthorizer>(GoogleAuthorizer());
  GetIt.I.registerSingleton<Backend>(Backend(
      GetIt.I.get<Analytics>(),
      GetIt.I.get<UserParamsController>(),
      GetIt.I.get<HttpClient>(),
      GetIt.I.get<Settings>()));
  GetIt.I.registerSingleton<UserParamsAutoWiper>(UserParamsAutoWiper(
      GetIt.I.get<Backend>(), GetIt.I.get<UserParamsController>()));
  GetIt.I.registerSingleton<OffApi>(OffApi(GetIt.I.get<Settings>()));
  GetIt.I.registerSingleton<ProductsManager>(ProductsManager(
      GetIt.I.get<OffApi>(),
      GetIt.I.get<Backend>(),
      GetIt.I.get<TakenProductsImagesStorage>(),
      GetIt.I.get<Analytics>()));
  GetIt.I.registerSingleton<UserParamsFetcher>(UserParamsFetcher(
      GetIt.I.get<Backend>(), GetIt.I.get<UserParamsController>()));

  GetIt.I.registerSingleton<IpLocationProvider>(
      IpLocationProvider(GetIt.I.get<HttpClient>()));
  GetIt.I.registerSingleton<LocationController>(LocationController(
    GetIt.I.get<IpLocationProvider>(),
    _FakePermissionsManager(),
    GetIt.I.get<SharedPreferencesHolder>(),
  ));
  GetIt.I.registerSingleton<AddressObtainer>(
      AddressObtainer(GetIt.I.get<OpenStreetMap>()));
  GetIt.I.registerSingleton<UserLangsManager>(UserLangsManager(
      GetIt.I.get<SysLangCodeHolder>(),
      CountriesLangCodesTable(GetIt.I.get<Analytics>()),
      GetIt.I.get<LocationController>(),
      GetIt.I.get<AddressObtainer>(),
      GetIt.I.get<SharedPreferencesHolder>(),
      GetIt.I.get<UserParamsController>(),
      GetIt.I.get<Backend>(),
      GetIt.I.get<Analytics>()));

  GetIt.I.registerSingleton<ProductsObtainer>(ProductsObtainer(
      GetIt.I.get<ProductsManager>(), GetIt.I.get<UserLangsManager>()));
  GetIt.I.registerSingleton<ShopsManager>(ShopsManager(
      GetIt.I.get<OpenStreetMap>(),
      GetIt.I.get<Backend>(),
      GetIt.I.get<ProductsObtainer>(),
      GetIt.I.get<Analytics>(),
      _FakeOsmCacher()));
}

class _FakeSettings implements Settings {
  @override
  Future<bool> fakeOffApiProductNotFound() async => false;

  @override
  Future<void> setFakeOffApiProductNotFound(bool value) async {}

  @override
  Future<void> setTestingBackends(bool value) async {}

  @override
  Future<bool> testingBackends() async => false;

  @override
  Future<void> setTestingBackendsQuickAnswers(bool value) async {}

  @override
  Future<bool> testingBackendsQuickAnswers() async => true;
}

class _FakeAnalytics implements Analytics {
  @override
  void onPageHidden(String? pageName) {}

  @override
  void onPageShown(String? pageName) {}

  @override
  void sendEvent(String event, [Map<String, dynamic>? params]) {}
}

class _FakeTakenProductsImagesStorage implements TakenProductsImagesStorage {
  @override
  Future<void> clearForTesting() async {
    throw UnimplementedError();
  }

  @override
  Future<bool> contains(Uri localFile) async {
    return false;
  }

  @override
  String get fileName => 'nope.json';

  @override
  Future<void>? get initDelayForTesting => throw UnimplementedError();

  @override
  bool get loaded => true;

  @override
  Future<void> get loadedFuture => Future.value();

  @override
  Future<void> store(Uri localFile) async {}
}

class _FakePermissionsManager implements PermissionsManager {
  @override
  Future<bool> openAppSettings() {
    throw UnimplementedError();
  }

  @override
  Future<PermissionState> request(PermissionKind permission) async {
    return PermissionState.permanentlyDenied;
  }

  @override
  Future<PermissionState> status(PermissionKind permission) async {
    return PermissionState.permanentlyDenied;
  }
}

class _FakeOsmCacher implements OsmCacher {
  @override
  Future<Result<OsmCachedTerritory<OsmRoad>, OsmCacherError>> addRoadToCache(
      int territoryId, OsmRoad road) {
    throw UnimplementedError();
  }

  @override
  Future<Result<OsmCachedTerritory<OsmShop>, OsmCacherError>> addShopToCache(
      int territoryId, OsmShop shop) {
    throw UnimplementedError();
  }

  @override
  Future<OsmCachedTerritory<OsmRoad>> cacheRoads(
      DateTime whenObtained, CoordsBounds bounds, List<OsmRoad> roads) {
    throw UnimplementedError();
  }

  @override
  Future<OsmCachedTerritory<OsmShop>> cacheShops(
      DateTime whenObtained, CoordsBounds bounds, List<OsmShop> shops) {
    throw UnimplementedError();
  }

  @override
  Future<Database> get dbForTesting => throw UnimplementedError();

  @override
  Future<void> deleteCachedTerritory(int territoryId) async {}

  @override
  Future<List<OsmCachedTerritory<OsmRoad>>> getCachedRoads() async {
    return const [];
  }

  @override
  Future<List<OsmCachedTerritory<OsmShop>>> getCachedShops() async {
    return const [];
  }
}
