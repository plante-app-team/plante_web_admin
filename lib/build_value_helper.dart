import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:plante/outside/backend/backend_product.dart';
import 'package:plante/outside/backend/backend_shop.dart';
import 'package:plante/outside/map/osm/osm_uid.dart';
import 'package:plante_web_admin/model/latest_products_added_to_shops.dart';
import 'package:plante_web_admin/model/moderator_task.dart';
import 'package:plante_web_admin/model/moderator_tasks_counts.dart';

part 'build_value_helper.g.dart';

@SerializersFor([
  ModeratorTask,
  ModeratorTasksCounts,
  LatestProductsAddedToShops,
])
final Serializers _serializers = _$_serializers;
final _jsonSerializers = (_serializers.toBuilder()
      ..add(OsmUIDBuildValueSerializer())
      ..addPlugin(StandardJsonPlugin())
      ..addBuilderFactory(const FullType(BuiltList, [FullType(BackendShop)]),
          () => ListBuilder<BackendShop>())
      ..addBuilderFactory(const FullType(BuiltList, [FullType(BackendProduct)]),
          () => ListBuilder<BackendProduct>()))
    .build();

class BuildValueHelper {
  static final Serializers serializers = _serializers;
  static final jsonSerializers = _jsonSerializers;
}
