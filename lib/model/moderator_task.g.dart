// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderator_task.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ModeratorTask> _$moderatorTaskSerializer =
    new _$ModeratorTaskSerializer();

class _$ModeratorTaskSerializer implements StructuredSerializer<ModeratorTask> {
  @override
  final Iterable<Type> types = const [ModeratorTask, _$ModeratorTask];
  @override
  final String wireName = 'ModeratorTask';

  @override
  Iterable<Object?> serialize(Serializers serializers, ModeratorTask object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'task_type',
      serializers.serialize(object.taskType,
          specifiedType: const FullType(String)),
      'task_source_user_id',
      serializers.serialize(object.taskSourceUserId,
          specifiedType: const FullType(String)),
      'creation_time',
      serializers.serialize(object.creationTime,
          specifiedType: const FullType(int)),
    ];
    Object? value;
    value = object.barcode;
    if (value != null) {
      result
        ..add('barcode')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.osmId;
    if (value != null) {
      result
        ..add('osm_id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.textFromUser;
    if (value != null) {
      result
        ..add('text_from_user')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.assignee;
    if (value != null) {
      result
        ..add('assignee')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.assignTime;
    if (value != null) {
      result
        ..add('assign_time')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.resolutionTime;
    if (value != null) {
      result
        ..add('resolution_time')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.lang;
    if (value != null) {
      result
        ..add('lang')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  ModeratorTask deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ModeratorTaskBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'barcode':
          result.barcode = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'osm_id':
          result.osmId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'task_type':
          result.taskType = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'task_source_user_id':
          result.taskSourceUserId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'text_from_user':
          result.textFromUser = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'creation_time':
          result.creationTime = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'assignee':
          result.assignee = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'assign_time':
          result.assignTime = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'resolution_time':
          result.resolutionTime = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'lang':
          result.lang = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$ModeratorTask extends ModeratorTask {
  @override
  final int id;
  @override
  final String? barcode;
  @override
  final String? osmId;
  @override
  final String taskType;
  @override
  final String taskSourceUserId;
  @override
  final String? textFromUser;
  @override
  final int creationTime;
  @override
  final String? assignee;
  @override
  final int? assignTime;
  @override
  final int? resolutionTime;
  @override
  final String? lang;

  factory _$ModeratorTask([void Function(ModeratorTaskBuilder)? updates]) =>
      (new ModeratorTaskBuilder()..update(updates)).build();

  _$ModeratorTask._(
      {required this.id,
      this.barcode,
      this.osmId,
      required this.taskType,
      required this.taskSourceUserId,
      this.textFromUser,
      required this.creationTime,
      this.assignee,
      this.assignTime,
      this.resolutionTime,
      this.lang})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, 'ModeratorTask', 'id');
    BuiltValueNullFieldError.checkNotNull(
        taskType, 'ModeratorTask', 'taskType');
    BuiltValueNullFieldError.checkNotNull(
        taskSourceUserId, 'ModeratorTask', 'taskSourceUserId');
    BuiltValueNullFieldError.checkNotNull(
        creationTime, 'ModeratorTask', 'creationTime');
  }

  @override
  ModeratorTask rebuild(void Function(ModeratorTaskBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ModeratorTaskBuilder toBuilder() => new ModeratorTaskBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ModeratorTask &&
        id == other.id &&
        barcode == other.barcode &&
        osmId == other.osmId &&
        taskType == other.taskType &&
        taskSourceUserId == other.taskSourceUserId &&
        textFromUser == other.textFromUser &&
        creationTime == other.creationTime &&
        assignee == other.assignee &&
        assignTime == other.assignTime &&
        resolutionTime == other.resolutionTime &&
        lang == other.lang;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc($jc(0, id.hashCode),
                                            barcode.hashCode),
                                        osmId.hashCode),
                                    taskType.hashCode),
                                taskSourceUserId.hashCode),
                            textFromUser.hashCode),
                        creationTime.hashCode),
                    assignee.hashCode),
                assignTime.hashCode),
            resolutionTime.hashCode),
        lang.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ModeratorTask')
          ..add('id', id)
          ..add('barcode', barcode)
          ..add('osmId', osmId)
          ..add('taskType', taskType)
          ..add('taskSourceUserId', taskSourceUserId)
          ..add('textFromUser', textFromUser)
          ..add('creationTime', creationTime)
          ..add('assignee', assignee)
          ..add('assignTime', assignTime)
          ..add('resolutionTime', resolutionTime)
          ..add('lang', lang))
        .toString();
  }
}

class ModeratorTaskBuilder
    implements Builder<ModeratorTask, ModeratorTaskBuilder> {
  _$ModeratorTask? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _barcode;
  String? get barcode => _$this._barcode;
  set barcode(String? barcode) => _$this._barcode = barcode;

  String? _osmId;
  String? get osmId => _$this._osmId;
  set osmId(String? osmId) => _$this._osmId = osmId;

  String? _taskType;
  String? get taskType => _$this._taskType;
  set taskType(String? taskType) => _$this._taskType = taskType;

  String? _taskSourceUserId;
  String? get taskSourceUserId => _$this._taskSourceUserId;
  set taskSourceUserId(String? taskSourceUserId) =>
      _$this._taskSourceUserId = taskSourceUserId;

  String? _textFromUser;
  String? get textFromUser => _$this._textFromUser;
  set textFromUser(String? textFromUser) => _$this._textFromUser = textFromUser;

  int? _creationTime;
  int? get creationTime => _$this._creationTime;
  set creationTime(int? creationTime) => _$this._creationTime = creationTime;

  String? _assignee;
  String? get assignee => _$this._assignee;
  set assignee(String? assignee) => _$this._assignee = assignee;

  int? _assignTime;
  int? get assignTime => _$this._assignTime;
  set assignTime(int? assignTime) => _$this._assignTime = assignTime;

  int? _resolutionTime;
  int? get resolutionTime => _$this._resolutionTime;
  set resolutionTime(int? resolutionTime) =>
      _$this._resolutionTime = resolutionTime;

  String? _lang;
  String? get lang => _$this._lang;
  set lang(String? lang) => _$this._lang = lang;

  ModeratorTaskBuilder();

  ModeratorTaskBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _barcode = $v.barcode;
      _osmId = $v.osmId;
      _taskType = $v.taskType;
      _taskSourceUserId = $v.taskSourceUserId;
      _textFromUser = $v.textFromUser;
      _creationTime = $v.creationTime;
      _assignee = $v.assignee;
      _assignTime = $v.assignTime;
      _resolutionTime = $v.resolutionTime;
      _lang = $v.lang;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ModeratorTask other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ModeratorTask;
  }

  @override
  void update(void Function(ModeratorTaskBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ModeratorTask build() {
    final _$result = _$v ??
        new _$ModeratorTask._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, 'ModeratorTask', 'id'),
            barcode: barcode,
            osmId: osmId,
            taskType: BuiltValueNullFieldError.checkNotNull(
                taskType, 'ModeratorTask', 'taskType'),
            taskSourceUserId: BuiltValueNullFieldError.checkNotNull(
                taskSourceUserId, 'ModeratorTask', 'taskSourceUserId'),
            textFromUser: textFromUser,
            creationTime: BuiltValueNullFieldError.checkNotNull(
                creationTime, 'ModeratorTask', 'creationTime'),
            assignee: assignee,
            assignTime: assignTime,
            resolutionTime: resolutionTime,
            lang: lang);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
