import 'package:http/http.dart' as http;
import 'package:untitled_vegan_app_web_admin/model/user.dart';

const _BACKEND_ADDRESS = '185.52.2.206:8080';

class Backend {
  static Function()? unauthCallback;

  static Future<http.Response> get(
      String path,
      [Map<String, String>? queryParams,
       Map<String, String>? headers]) async {
    final url = Uri.http(_BACKEND_ADDRESS, path, queryParams);
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
