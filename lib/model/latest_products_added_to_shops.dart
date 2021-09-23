import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:plante/outside/backend/backend_product.dart';
import 'package:plante/outside/backend/backend_shop.dart';
import 'package:plante_web_admin/build_value_helper.dart';

part 'latest_products_added_to_shops.g.dart';

abstract class LatestProductsAddedToShops
    implements
        Built<LatestProductsAddedToShops, LatestProductsAddedToShopsBuilder> {
  @BuiltValueField(wireName: 'shops_ordered')
  BuiltList<BackendShop> get shopsOrdered;
  @BuiltValueField(wireName: 'products_ordered')
  BuiltList<BackendProduct> get productsOrdered;
  @BuiltValueField(wireName: 'when_added_ordered')
  BuiltList<int> get whenAddedOrdered;

  static LatestProductsAddedToShops fromJson(Map<String, dynamic> json) {
    return BuildValueHelper.jsonSerializers
        .deserializeWith(LatestProductsAddedToShops.serializer, json)!;
  }

  Map<String, dynamic> toJson() {
    return BuildValueHelper.jsonSerializers.serializeWith(
        LatestProductsAddedToShops.serializer, this) as Map<String, dynamic>;
  }

  factory LatestProductsAddedToShops(
          [void Function(LatestProductsAddedToShopsBuilder) updates]) =
      _$LatestProductsAddedToShops;
  LatestProductsAddedToShops._();
  static Serializer<LatestProductsAddedToShops> get serializer =>
      _$latestProductsAddedToShopsSerializer;
}
