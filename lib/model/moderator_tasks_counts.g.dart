// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderator_tasks_counts.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ModeratorTasksCounts> _$moderatorTasksCountsSerializer =
    new _$ModeratorTasksCountsSerializer();

class _$ModeratorTasksCountsSerializer
    implements StructuredSerializer<ModeratorTasksCounts> {
  @override
  final Iterable<Type> types = const [
    ModeratorTasksCounts,
    _$ModeratorTasksCounts
  ];
  @override
  final String wireName = 'ModeratorTasksCounts';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, ModeratorTasksCounts object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'total_count',
      serializers.serialize(object.totalCount,
          specifiedType: const FullType(int)),
      'langs_counts',
      serializers.serialize(object.langsCounts,
          specifiedType: const FullType(
              BuiltMap, const [const FullType(String), const FullType(int)])),
    ];

    return result;
  }

  @override
  ModeratorTasksCounts deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ModeratorTasksCountsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'total_count':
          result.totalCount = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'langs_counts':
          result.langsCounts.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap,
                  const [const FullType(String), const FullType(int)]))!);
          break;
      }
    }

    return result.build();
  }
}

class _$ModeratorTasksCounts extends ModeratorTasksCounts {
  @override
  final int totalCount;
  @override
  final BuiltMap<String, int> langsCounts;

  factory _$ModeratorTasksCounts(
          [void Function(ModeratorTasksCountsBuilder)? updates]) =>
      (new ModeratorTasksCountsBuilder()..update(updates)).build();

  _$ModeratorTasksCounts._(
      {required this.totalCount, required this.langsCounts})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        totalCount, 'ModeratorTasksCounts', 'totalCount');
    BuiltValueNullFieldError.checkNotNull(
        langsCounts, 'ModeratorTasksCounts', 'langsCounts');
  }

  @override
  ModeratorTasksCounts rebuild(
          void Function(ModeratorTasksCountsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ModeratorTasksCountsBuilder toBuilder() =>
      new ModeratorTasksCountsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ModeratorTasksCounts &&
        totalCount == other.totalCount &&
        langsCounts == other.langsCounts;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, totalCount.hashCode), langsCounts.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ModeratorTasksCounts')
          ..add('totalCount', totalCount)
          ..add('langsCounts', langsCounts))
        .toString();
  }
}

class ModeratorTasksCountsBuilder
    implements Builder<ModeratorTasksCounts, ModeratorTasksCountsBuilder> {
  _$ModeratorTasksCounts? _$v;

  int? _totalCount;
  int? get totalCount => _$this._totalCount;
  set totalCount(int? totalCount) => _$this._totalCount = totalCount;

  MapBuilder<String, int>? _langsCounts;
  MapBuilder<String, int> get langsCounts =>
      _$this._langsCounts ??= new MapBuilder<String, int>();
  set langsCounts(MapBuilder<String, int>? langsCounts) =>
      _$this._langsCounts = langsCounts;

  ModeratorTasksCountsBuilder();

  ModeratorTasksCountsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _totalCount = $v.totalCount;
      _langsCounts = $v.langsCounts.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ModeratorTasksCounts other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ModeratorTasksCounts;
  }

  @override
  void update(void Function(ModeratorTasksCountsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ModeratorTasksCounts build() {
    _$ModeratorTasksCounts _$result;
    try {
      _$result = _$v ??
          new _$ModeratorTasksCounts._(
              totalCount: BuiltValueNullFieldError.checkNotNull(
                  totalCount, 'ModeratorTasksCounts', 'totalCount'),
              langsCounts: langsCounts.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'langsCounts';
        langsCounts.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'ModeratorTasksCounts', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
