import 'dart:async';

import 'package:openfoodfacts/utils/HttpHelper.dart';
import 'package:plante/outside/backend/backend.dart';
import 'package:http/http.dart' as http;

class OffHttpInterceptor extends HttpInterceptor {
  final Backend _backend;

  OffHttpInterceptor(this._backend);

  @override
  Future<http.Request>? interceptGet(Uri uri) {
    return null;
  }

  Future<http.Response>? fullyInterceptGet(Uri uri) async {
    final completer = Completer<http.Response>();
    final asyncFun = () async {
      final resp = await _backend.customGet(
          '/off_proxy_get/' + uri.path, uri.queryParameters);
      completer.complete(http.Response(
        resp.body,
        resp.statusCode ?? 0,
        headers: resp.headers,
        reasonPhrase: resp.reasonPhrase,
      ));
    };
    asyncFun.call();
    return completer.future;
  }

  @override
  Future<http.Request>? interceptPost(Uri uri) {
    return null;
  }

  @override
  Future<http.MultipartRequest>? interceptMultipart(String method, Uri uri) {
    return null;
  }
}
