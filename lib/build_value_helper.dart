import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:plante_web_admin/model/backend_product.dart';
import 'package:plante_web_admin/model/moderator_task.dart';
import 'package:plante_web_admin/model/user.dart';
import 'package:plante_web_admin/model/veg_status.dart';

part 'build_value_helper.g.dart';

@SerializersFor([
  User,
  ModeratorTask,
  BackendProduct,
  VegStatus,
])
final Serializers _serializers = _$_serializers;
final _jsonSerializers =
(_serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();

class BuildValueHelper {
  static final Serializers serializers = _serializers;
  static final jsonSerializers = _jsonSerializers;
}
