import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:plante_web_admin/model/moderator_task.dart';

part 'build_value_helper.g.dart';

@SerializersFor([
  ModeratorTask,
])
final Serializers _serializers = _$_serializers;
final _jsonSerializers =
    (_serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();

class BuildValueHelper {
  static final Serializers serializers = _serializers;
  static final jsonSerializers = _jsonSerializers;
}
