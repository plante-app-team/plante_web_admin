// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<User> _$userSerializer = new _$UserSerializer();

class _$UserSerializer implements StructuredSerializer<User> {
  @override
  final Iterable<Type> types = const [User, _$User];
  @override
  final String wireName = 'User';

  @override
  Iterable<Object?> serialize(Serializers serializers, User object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'user_id',
      serializers.serialize(object.backendId,
          specifiedType: const FullType(String)),
      'client_token',
      serializers.serialize(object.backendClientToken,
          specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'rights_group',
      serializers.serialize(object.userGroup,
          specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  User deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new UserBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'user_id':
          result.backendId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'client_token':
          result.backendClientToken = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'rights_group':
          result.userGroup = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$User extends User {
  @override
  final String backendId;
  @override
  final String backendClientToken;
  @override
  final String name;
  @override
  final int userGroup;

  factory _$User([void Function(UserBuilder)? updates]) =>
      (new UserBuilder()..update(updates)).build();

  _$User._(
      {required this.backendId,
      required this.backendClientToken,
      required this.name,
      required this.userGroup})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(backendId, 'User', 'backendId');
    BuiltValueNullFieldError.checkNotNull(
        backendClientToken, 'User', 'backendClientToken');
    BuiltValueNullFieldError.checkNotNull(name, 'User', 'name');
    BuiltValueNullFieldError.checkNotNull(userGroup, 'User', 'userGroup');
  }

  @override
  User rebuild(void Function(UserBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserBuilder toBuilder() => new UserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is User &&
        backendId == other.backendId &&
        backendClientToken == other.backendClientToken &&
        name == other.name &&
        userGroup == other.userGroup;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, backendId.hashCode), backendClientToken.hashCode),
            name.hashCode),
        userGroup.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('User')
          ..add('backendId', backendId)
          ..add('backendClientToken', backendClientToken)
          ..add('name', name)
          ..add('userGroup', userGroup))
        .toString();
  }
}

class UserBuilder implements Builder<User, UserBuilder> {
  _$User? _$v;

  String? _backendId;
  String? get backendId => _$this._backendId;
  set backendId(String? backendId) => _$this._backendId = backendId;

  String? _backendClientToken;
  String? get backendClientToken => _$this._backendClientToken;
  set backendClientToken(String? backendClientToken) =>
      _$this._backendClientToken = backendClientToken;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _userGroup;
  int? get userGroup => _$this._userGroup;
  set userGroup(int? userGroup) => _$this._userGroup = userGroup;

  UserBuilder();

  UserBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _backendId = $v.backendId;
      _backendClientToken = $v.backendClientToken;
      _name = $v.name;
      _userGroup = $v.userGroup;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(User other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$User;
  }

  @override
  void update(void Function(UserBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$User build() {
    final _$result = _$v ??
        new _$User._(
            backendId: BuiltValueNullFieldError.checkNotNull(
                backendId, 'User', 'backendId'),
            backendClientToken: BuiltValueNullFieldError.checkNotNull(
                backendClientToken, 'User', 'backendClientToken'),
            name: BuiltValueNullFieldError.checkNotNull(name, 'User', 'name'),
            userGroup: BuiltValueNullFieldError.checkNotNull(
                userGroup, 'User', 'userGroup'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
