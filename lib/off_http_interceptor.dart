import 'dart:async';

import 'package:openfoodfacts/utils/HttpHelper.dart';
import 'package:plante/outside/backend/backend.dart';
import 'package:http/http.dart' as http;
import 'package:plante/outside/backend/backend.dart';

class OffHttpInterceptor extends HttpInterceptor {
  final Backend _backend;

  OffHttpInterceptor(this._backend);

  @override
  Future<http.Request?> interceptGet(Uri uri) async {
    return await _backend.customRequest(
        'off_proxy_get${uri.path}', (uri) => http.Request('GET', uri),
        queryParams: uri.queryParametersAll, headers: null);
  }

  @override
  Future<http.Request?> interceptPost(Uri uri) async {
    return null;
  }

  @override
  Future<http.MultipartRequest?> interceptMultipart(
      String method, Uri uri) async {
    return null;
  }
}
