import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:plante_web_admin/build_value_helper.dart';

part 'moderator_task.g.dart';

abstract class ModeratorTask
    implements Built<ModeratorTask, ModeratorTaskBuilder> {
  @BuiltValueField(wireName: 'id')
  int get id;
  @BuiltValueField(wireName: 'barcode')
  String? get barcode;
  @BuiltValueField(wireName: 'osm_id')
  String? get osmId;
  @BuiltValueField(wireName: 'task_type')
  String get taskType;
  @BuiltValueField(wireName: 'task_source_user_id')
  String get taskSourceUserId;
  @BuiltValueField(wireName: 'text_from_user')
  String? get textFromUser;
  @BuiltValueField(wireName: 'creation_time')
  int get creationTime;

  @BuiltValueField(wireName: 'assignee')
  String? get assignee;
  @BuiltValueField(wireName: 'assign_time')
  int? get assignTime;
  @BuiltValueField(wireName: 'resolution_time')
  int? get resolutionTime;

  static ModeratorTask fromJson(Map<String, dynamic> json) {
    return BuildValueHelper.jsonSerializers
        .deserializeWith(ModeratorTask.serializer, json)!;
  }

  Map<String, dynamic> toJson() {
    return BuildValueHelper.jsonSerializers
        .serializeWith(ModeratorTask.serializer, this) as Map<String, dynamic>;
  }

  factory ModeratorTask([void Function(ModeratorTaskBuilder) updates]) =
      _$ModeratorTask;
  ModeratorTask._();
  static Serializer<ModeratorTask> get serializer => _$moderatorTaskSerializer;
}
