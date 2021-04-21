import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plante_web_admin/build_value_helper.dart';

part 'user.g.dart';

const _PREFS_NAME = "USER_v1";

abstract class User implements Built<User, UserBuilder> {
  @BuiltValueField(wireName: 'user_id')
  String get backendId;
  @BuiltValueField(wireName: 'client_token')
  String get backendClientToken;
  @BuiltValueField(wireName: 'name')
  String get name;
  @BuiltValueField(wireName: 'rights_group')
  int get userGroup;

  static User? fromJson(Map<String, dynamic> json) {
    return BuildValueHelper.jsonSerializers.deserializeWith(User.serializer, json);
  }

  Map<String, dynamic> toJson() {
    return BuildValueHelper.jsonSerializers.serializeWith(
        User.serializer, this) as Map<String, dynamic>;
  }

  static Future<void> staticInit() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_PREFS_NAME)) {
      currentNullable = fromJson(jsonDecode(prefs.getString(_PREFS_NAME)!));
    }
  }
  static User? _current;

  static User? get currentNullable => _current;
  static set currentNullable(User? value) {
    _current = value;
    () async {
      final prefs = await SharedPreferences.getInstance();
      if (value == null) {
        prefs.remove(_PREFS_NAME);
      } else {
        prefs.setString(_PREFS_NAME, jsonEncode(value.toJson()));
      }
    }.call();
  }

  static User get current => currentNullable!;


  factory User([void Function(UserBuilder) updates]) = _$User;
  User._();
  static Serializer<User> get serializer => _$userSerializer;
}
