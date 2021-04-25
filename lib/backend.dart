import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:plante_web_admin/model/user.dart';

const _LOCAL_BACKEND_ADDRESS = 'localhost:8080';
const _BACKEND_ADDRESS = 'planteapp.com';
const _CONNECT_TO_LOCAL_SERVER = kDebugMode;

class Backend {
  static Function()? unauthCallback;

  static Future<http.Response> get(
      String path,
      [Map<String, String>? queryParams,
       Map<String, String>? headers]) async {
    final url;
    if (_CONNECT_TO_LOCAL_SERVER) {
      url = Uri.http(_LOCAL_BACKEND_ADDRESS, "/$path", queryParams);
    } else {
      url = Uri.https(_BACKEND_ADDRESS, "/backend/$path", queryParams);
    }
    print("Request start: ${url.toString()}");
    final headersReally = Map<String, String>.from(headers ?? Map<String, String>());
    if (User.currentNullable != null) {
      headersReally["Authorization"] = "Bearer ${User.current.backendClientToken}";
    }
    final response = await http.get(url, headers: headersReally);
    if (response.statusCode == 401) {
      User.currentNullable = null;
      unauthCallback?.call();
    }
    print("Request finished: ${url.toString()}");
    return response;
  }
}
