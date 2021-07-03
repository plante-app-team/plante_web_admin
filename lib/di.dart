import 'package:get_it/get_it.dart';
import 'package:plante/base/settings.dart';
import 'package:plante/logging/analytics.dart';
import 'package:plante/model/shared_preferences_holder.dart';
import 'package:plante/outside/backend/backend.dart';
import 'package:plante/outside/backend/user_params_auto_wiper.dart';
import 'package:plante/outside/http_client.dart';
import 'package:plante/outside/identity/google_authorizer.dart';
import 'package:plante/outside/map/shops_manager.dart';
import 'package:plante/outside/off/off_api.dart';
import 'package:plante/outside/map/open_street_map.dart';
import 'package:plante/model/user_params_controller.dart';
import 'package:plante/outside/products/products_manager.dart';
import 'package:plante/outside/products/taken_products_images_storage.dart';
import 'package:plante/ui/base/lang_code_holder.dart';
import 'package:plante/user_params_fetcher.dart';

void initDI() {
  GetIt.I.registerSingleton<Settings>(_FakeSettings());
  GetIt.I.registerSingleton<Analytics>(_FakeAnalytics());
  GetIt.I.registerSingleton<TakenProductsImagesStorage>(
      _FakeTakenProductsImagesStorage());

  GetIt.I.registerSingleton<SharedPreferencesHolder>(SharedPreferencesHolder());
  GetIt.I.registerSingleton<LangCodeHolder>(LangCodeHolder());
  GetIt.I.registerSingleton<UserParamsController>(UserParamsController());
  GetIt.I.registerSingleton<HttpClient>(HttpClient());
  GetIt.I.registerSingleton<OpenStreetMap>(
      OpenStreetMap(GetIt.I.get<HttpClient>()));
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
      GetIt.I.get<LangCodeHolder>(),
      GetIt.I.get<TakenProductsImagesStorage>()));
  GetIt.I.registerSingleton<UserParamsFetcher>(UserParamsFetcher(
      GetIt.I.get<Backend>(), GetIt.I.get<UserParamsController>()));
  GetIt.I.registerSingleton<ShopsManager>(ShopsManager(
      GetIt.I.get<OpenStreetMap>(),
      GetIt.I.get<Backend>(),
      GetIt.I.get<ProductsManager>(),
      GetIt.I.get<Analytics>()));
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
