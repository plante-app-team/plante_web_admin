import 'dart:convert';

import 'package:plante/base/result.dart';
import 'package:plante/outside/backend/backend.dart';
import 'package:plante/outside/backend/backend_error.dart';
import 'package:plante_web_admin/model/latest_products_added_to_shops.dart';

extension BackendExtensions on Backend {
  Future<Result<None, BackendError>> moderateProduct(
      String barcode,
      String? vegetarianStatus,
      String? veganStatus,
      int? vegetarianStatusChoiceReason,
      String? vegetarianStatusChoiceReasonSource,
      int? veganStatusChoiceReason,
      String? veganStatusChoiceReasonSource) async {
    if (vegetarianStatus == null && veganStatus != null) {
      throw Exception(
          'Both vegetarian and vegan statuses must be either set or not set');
    } else if (vegetarianStatus != null && veganStatus == null) {
      throw Exception(
          'Both vegetarian and vegan statuses must be either set or not set');
    }

    if ((vegetarianStatus == null && veganStatus == null) &&
        (vegetarianStatusChoiceReason != null ||
            vegetarianStatusChoiceReasonSource != null ||
            veganStatusChoiceReason != null ||
            veganStatusChoiceReasonSource != null)) {
      throw Exception(
          'Moderator veg-status reasoning does not make sense without the status set');
    }

    if (vegetarianStatus != null && veganStatus != null) {
      var resp = await customGet("moderate_product_veg_statuses/", {
        "barcode": barcode,
        "vegetarianStatus": vegetarianStatus,
        "veganStatus": veganStatus
      });
      if (jsonDecode(resp.body)["result"] != "ok") {
        throw Exception('Unexpected response: ${resp.body}');
      }

      final choiceReasonParams = <String, String>{};
      if (vegetarianStatusChoiceReason != null) {
        choiceReasonParams['vegetarianChoiceReason'] =
            vegetarianStatusChoiceReason.toString();
      }
      if (vegetarianStatusChoiceReasonSource != null) {
        choiceReasonParams['vegetarianSourcesText'] =
            vegetarianStatusChoiceReasonSource;
      }
      if (veganStatusChoiceReason != null) {
        choiceReasonParams['veganChoiceReason'] =
            veganStatusChoiceReason.toString();
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
}
