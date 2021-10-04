import 'dart:async';

import 'package:http/http.dart';
import 'package:openfoodfacts/model/Status.dart';
import 'package:openfoodfacts/model/User.dart';
import 'package:openfoodfacts/model/UserAgent.dart';
import 'package:openfoodfacts/utils/HttpHelper.dart';
import 'package:openfoodfacts/utils/QueryType.dart';
import 'package:plante/outside/backend/backend.dart';

class OffHttpInterceptor extends HttpInterceptor {
  final Backend _backend;

  OffHttpInterceptor(this._backend);

  @override
  Future<Response>? interceptGet(
      Uri uri, User? user, UserAgent? userAgent, QueryType? queryType) {
    final completer = Completer<Response>();
    final asyncFun = () async {
      final resp = await _backend.customGet(
          '/off_proxy_get/' + uri.path, uri.queryParameters);
      completer.complete(Response(
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
  Future<Response>? interceptPost(
      Uri uri, Map<String, String?> body, User user, QueryType? queryType) {
    throw UnimplementedError();
  }

  @override
  Future<Status>? interceptMultipart(Uri uri, Map<String, String> body,
      Map<String, Uri>? files, User? user, QueryType? queryType) {
    throw UnimplementedError();
  }
}
