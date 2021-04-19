import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:untitled_vegan_app_web_admin/model/moderator_task.dart';
import 'package:untitled_vegan_app_web_admin/model/user.dart';

part 'build_value_helper.g.dart';

@SerializersFor([
  User,
  ModeratorTask,
])
final Serializers _serializers = _$_serializers;
final _jsonSerializers =
(_serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();

class BuildValueHelper {
  static final Serializers serializers = _serializers;
  static final jsonSerializers = _jsonSerializers;
}
