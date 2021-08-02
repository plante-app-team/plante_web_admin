import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:plante_web_admin/build_value_helper.dart';

part 'moderator_tasks_counts.g.dart';

abstract class ModeratorTasksCounts
    implements Built<ModeratorTasksCounts, ModeratorTasksCountsBuilder> {
  @BuiltValueField(wireName: 'total_count')
  int get totalCount;
  @BuiltValueField(wireName: 'langs_counts')
  BuiltMap<String, int> get langsCounts;

  int get withoutLangsCount {
    var withLangsCount = 0;
    for (final langCount in langsCounts.values) {
      withLangsCount += langCount;
    }
    return totalCount - withLangsCount;
  }

  static ModeratorTasksCounts fromJson(Map<String, dynamic> json) {
    return BuildValueHelper.jsonSerializers
        .deserializeWith(ModeratorTasksCounts.serializer, json)!;
  }

  factory ModeratorTasksCounts(
          [void Function(ModeratorTasksCountsBuilder) updates]) =
      _$ModeratorTasksCounts;
  ModeratorTasksCounts._();
  static Serializer<ModeratorTasksCounts> get serializer =>
      _$moderatorTasksCountsSerializer;
}
