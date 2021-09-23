// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'latest_products_added_to_shops.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<LatestProductsAddedToShops> _$latestProductsAddedToShopsSerializer =
    new _$LatestProductsAddedToShopsSerializer();

class _$LatestProductsAddedToShopsSerializer
    implements StructuredSerializer<LatestProductsAddedToShops> {
  @override
  final Iterable<Type> types = const [
    LatestProductsAddedToShops,
    _$LatestProductsAddedToShops
  ];
  @override
  final String wireName = 'LatestProductsAddedToShops';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, LatestProductsAddedToShops object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'shops_ordered',
      serializers.serialize(object.shopsOrdered,
          specifiedType:
              const FullType(BuiltList, const [const FullType(BackendShop)])),
      'products_ordered',
      serializers.serialize(object.productsOrdered,
          specifiedType: const FullType(
              BuiltList, const [const FullType(BackendProduct)])),
      'when_added_ordered',
      serializers.serialize(object.whenAddedOrdered,
          specifiedType:
              const FullType(BuiltList, const [const FullType(int)])),
    ];

    return result;
  }

  @override
  LatestProductsAddedToShops deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new LatestProductsAddedToShopsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'shops_ordered':
          result.shopsOrdered.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(BackendShop)]))!
              as BuiltList<Object?>);
          break;
        case 'products_ordered':
          result.productsOrdered.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(BackendProduct)]))!
              as BuiltList<Object?>);
          break;
        case 'when_added_ordered':
          result.whenAddedOrdered.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(int)]))!
              as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$LatestProductsAddedToShops extends LatestProductsAddedToShops {
  @override
  final BuiltList<BackendShop> shopsOrdered;
  @override
  final BuiltList<BackendProduct> productsOrdered;
  @override
  final BuiltList<int> whenAddedOrdered;

  factory _$LatestProductsAddedToShops(
          [void Function(LatestProductsAddedToShopsBuilder)? updates]) =>
      (new LatestProductsAddedToShopsBuilder()..update(updates)).build();

  _$LatestProductsAddedToShops._(
      {required this.shopsOrdered,
      required this.productsOrdered,
      required this.whenAddedOrdered})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        shopsOrdered, 'LatestProductsAddedToShops', 'shopsOrdered');
    BuiltValueNullFieldError.checkNotNull(
        productsOrdered, 'LatestProductsAddedToShops', 'productsOrdered');
    BuiltValueNullFieldError.checkNotNull(
        whenAddedOrdered, 'LatestProductsAddedToShops', 'whenAddedOrdered');
  }

  @override
  LatestProductsAddedToShops rebuild(
          void Function(LatestProductsAddedToShopsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LatestProductsAddedToShopsBuilder toBuilder() =>
      new LatestProductsAddedToShopsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LatestProductsAddedToShops &&
        shopsOrdered == other.shopsOrdered &&
        productsOrdered == other.productsOrdered &&
        whenAddedOrdered == other.whenAddedOrdered;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, shopsOrdered.hashCode), productsOrdered.hashCode),
        whenAddedOrdered.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('LatestProductsAddedToShops')
          ..add('shopsOrdered', shopsOrdered)
          ..add('productsOrdered', productsOrdered)
          ..add('whenAddedOrdered', whenAddedOrdered))
        .toString();
  }
}

class LatestProductsAddedToShopsBuilder
    implements
        Builder<LatestProductsAddedToShops, LatestProductsAddedToShopsBuilder> {
  _$LatestProductsAddedToShops? _$v;

  ListBuilder<BackendShop>? _shopsOrdered;
  ListBuilder<BackendShop> get shopsOrdered =>
      _$this._shopsOrdered ??= new ListBuilder<BackendShop>();
  set shopsOrdered(ListBuilder<BackendShop>? shopsOrdered) =>
      _$this._shopsOrdered = shopsOrdered;

  ListBuilder<BackendProduct>? _productsOrdered;
  ListBuilder<BackendProduct> get productsOrdered =>
      _$this._productsOrdered ??= new ListBuilder<BackendProduct>();
  set productsOrdered(ListBuilder<BackendProduct>? productsOrdered) =>
      _$this._productsOrdered = productsOrdered;

  ListBuilder<int>? _whenAddedOrdered;
  ListBuilder<int> get whenAddedOrdered =>
      _$this._whenAddedOrdered ??= new ListBuilder<int>();
  set whenAddedOrdered(ListBuilder<int>? whenAddedOrdered) =>
      _$this._whenAddedOrdered = whenAddedOrdered;

  LatestProductsAddedToShopsBuilder();

  LatestProductsAddedToShopsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _shopsOrdered = $v.shopsOrdered.toBuilder();
      _productsOrdered = $v.productsOrdered.toBuilder();
      _whenAddedOrdered = $v.whenAddedOrdered.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LatestProductsAddedToShops other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$LatestProductsAddedToShops;
  }

  @override
  void update(void Function(LatestProductsAddedToShopsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$LatestProductsAddedToShops build() {
    _$LatestProductsAddedToShops _$result;
    try {
      _$result = _$v ??
          new _$LatestProductsAddedToShops._(
              shopsOrdered: shopsOrdered.build(),
              productsOrdered: productsOrdered.build(),
              whenAddedOrdered: whenAddedOrdered.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'shopsOrdered';
        shopsOrdered.build();
        _$failedField = 'productsOrdered';
        productsOrdered.build();
        _$failedField = 'whenAddedOrdered';
        whenAddedOrdered.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'LatestProductsAddedToShops', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
