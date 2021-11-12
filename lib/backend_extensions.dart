import 'dart:convert';

import 'package:plante/base/result.dart';
import 'package:plante/model/lang_code.dart';
import 'package:plante/model/moderator_choice_reason.dart';
import 'package:plante/outside/backend/backend.dart';
import 'package:plante/outside/backend/backend_error.dart';
import 'package:plante/outside/map/osm_uid.dart';
import 'package:plante_web_admin/model/latest_products_added_to_shops.dart';

extension BackendExtensions on Backend {
  Future<Result<None, BackendError>> moderateProduct(
      String barcode,
      String? veganStatus,
      String? veganStatusChoiceReasonsStr,
      String? veganStatusChoiceReasonSource) async {
    final veganStatusChoiceReasons =
        moderatorChoiceReasonFromPersistentIdsStr(veganStatusChoiceReasonsStr);
    if (veganStatus == null &&
        (veganStatusChoiceReasons.isNotEmpty ||
            veganStatusChoiceReasonSource != null)) {
      throw Exception(
          'Moderator veg-status reasoning does not make sense without the status set');
    }

    if (veganStatus != null) {
      var resp = await customGet("moderate_product_veg_statuses/",
          {"barcode": barcode, "veganStatus": veganStatus});
      if (jsonDecode(resp.body)["result"] != "ok") {
        throw Exception('Unexpected response: ${resp.body}');
      }

      final choiceReasonParams = <String, dynamic>{};
      if (veganStatusChoiceReasons.isNotEmpty) {
        choiceReasonParams['veganChoiceReasons'] =
            veganStatusChoiceReasons.map((e) => '${e.persistentId}');
      }
      if (veganStatusChoiceReasonSource != null) {
        choiceReasonParams['veganSourcesText'] = veganStatusChoiceReasonSource;
      }
      if (choiceReasonParams.isNotEmpty) {
        choiceReasonParams['barcode'] = barcode;
        resp = await customGet(
            "specify_moderator_choice_reason/", choiceReasonParams);
        if (jsonDecode(resp.body)["result"] != "ok") {
          throw Exception('Unexpected response: ${resp.body}');
        }
      }
    } else {
      final resp =
          await customGet("clear_product_veg_statuses/", {"barcode": barcode});
      if (jsonDecode(resp.body)["result"] != "ok") {
        throw Exception('Unexpected response: ${resp.body}');
      }
    }
    return Ok(None());
  }

  Future<Result<LatestProductsAddedToShops, BackendError>>
      latestProductsAddedToShops(int limit) async {
    var resp = await customGet("latest_products_added_to_shops_data/", {
      "limit": limit.toString(),
    });
    return Ok(LatestProductsAddedToShops.fromJson(jsonDecode(resp.body)));
  }

  Future<Result<None, BackendError>> changeModeratorTaskLanguage(
      int taskId, LangCode? lang) async {
    final params = {
      "taskId": "$taskId",
    };
    if (lang != null) {
      params["lang"] = lang.name;
    }
    var resp = await customGet("change_moderator_task_lang/", params);
    if (resp.isOk) {
      return Ok(None());
    } else {
      return Err(BackendError.fromResp(resp));
    }
  }

  Future<Result<None, BackendError>> deleteShop(OsmUID shopUid) async {
    var resp = await customGet("delete_shop_locally/", {
      "shopOsmUID": shopUid.toString(),
    });
    if (resp.isOk) {
      return Ok(None());
    } else {
      return Err(BackendError.fromResp(resp));
    }
  }
}
