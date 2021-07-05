import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:plante/model/veg_status.dart';
import 'package:plante/model/veg_status_source.dart';
import 'package:plante/outside/backend/backend.dart';
import 'package:plante/outside/backend/backend_product.dart';
import 'package:plante/ui/base/components/button_outlined_plante.dart';
import 'package:plante/ui/base/components/input_field_plante.dart';
import 'package:plante/ui/base/snack_bar_utils.dart';
import 'package:plante_web_admin/ui/components/checkbox_text.dart';
import 'package:plante_web_admin/ui/components/veg_statuses_widget.dart';
import 'package:plante/l10n/strings.dart';

class ManageProductPage extends StatefulWidget {
  const ManageProductPage({Key? key}) : super(key: key);

  @override
  _ManageProductPageState createState() => _ManageProductPageState();
}

class _ManageProductPageState extends State<ManageProductPage> {
  final _backend = GetIt.I.get<Backend>();
  final _barcodeInputController = TextEditingController();
  BackendProduct? _foundProduct;
  bool _loading = false;

  bool _changeProductVegStatuses = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                width: 1000,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  SizedBox(
                      width: 400,
                      child: InputFieldPlante(
                        controller: _barcodeInputController,
                        label: context.strings.global_barcode,
                      )),
                  SizedBox(height: 30),
                  SizedBox(
                      width: 400,
                      child: ButtonOutlinedPlante.withText(
                        context.strings.web_manage_product_page_search,
                        onPressed: _onProductSearch,
                      )),
                  SizedBox(height: 50),
                  if (_loading) CircularProgressIndicator(),
                  if (!_loading &&
                      _foundProduct == null &&
                      _barcodeInputController.text.isNotEmpty)
                    Text(context
                        .strings.web_manage_product_page_product_not_found),
                  if (!_loading &&
                      _foundProduct == null &&
                      _barcodeInputController.text.isEmpty)
                    Text(context.strings.web_manage_product_page_type_barcode),
                  if (!_loading && _foundProduct != null)
                    Column(children: [
                      VegStatusesWidget(
                          _onProductVegStatusesChange,
                          _changeProductVegStatuses,
                          VegStatus.safeValueOf(
                              _foundProduct!.vegetarianStatus ?? ''),
                          _foundProduct!.vegetarianStatusSource,
                          VegStatus.safeValueOf(
                              _foundProduct!.veganStatus ?? ''),
                          _foundProduct!.veganStatusSource),
                      SizedBox(height: 25),
                      CheckboxText(
                          text: context.strings
                              .web_user_report_task_page_change_veg_statuses,
                          value: _changeProductVegStatuses,
                          onChanged: (bool? value) {
                            setState(() {
                              _changeProductVegStatuses = value ?? false;
                            });
                          }),
                      SizedBox(height: 50),
                      SizedBox(
                          width: 500,
                          child: ButtonOutlinedPlante.withText(
                            context.strings
                                .web_manage_product_page_send_modifications,
                            onPressed: _canSendModifications()
                                ? _onSendModifications
                                : null,
                          )),
                    ])
                ]))));
  }

  void _onProductSearch() async {
    _performNetworkAction(() async {
      final productRes =
          await _backend.requestProduct(_barcodeInputController.text);
      _foundProduct = productRes.maybeOk();
      _changeProductVegStatuses = false;
    });
  }

  void _onProductVegStatusesChange(
      VegStatus? vegetarianStatus, VegStatus? veganStatus) {
    setState(() {
      _foundProduct = _foundProduct!.rebuild((e) => e
        ..vegetarianStatus = vegetarianStatus?.name
        ..vegetarianStatusSource = VegStatusSource.moderator.name
        ..veganStatus = veganStatus?.name
        ..veganStatusSource = VegStatusSource.moderator.name);
    });
  }

  bool _canSendModifications() {
    if (_foundProduct == null) {
      return false;
    }

    // Both have to be nulls or non-nulls.
    if (_foundProduct!.veganStatus == null &&
        _foundProduct!.vegetarianStatus != null) {
      return false;
    }
    if (_foundProduct!.veganStatus != null &&
        _foundProduct!.vegetarianStatus == null) {
      return false;
    }

    return true;
  }

  void _onSendModifications() async {
    _performNetworkAction(() async {
      final product = _foundProduct!;
      if (_changeProductVegStatuses) {
        if (product.vegetarianStatus != null && product.veganStatus != null) {
          final resp =
              await _backend.customGet("moderate_product_veg_statuses/", {
            "barcode": product.barcode,
            "vegetarianStatus": product.vegetarianStatus!,
            "veganStatus": product.veganStatus!
          });
          if (jsonDecode(resp.body)["result"] != "ok") {
            throw Exception('Unexpected response: ${resp.body}');
          }
        } else {
          final resp = await _backend.customGet(
              "clear_product_veg_statuses/", {"barcode": product.barcode});
          if (jsonDecode(resp.body)["result"] != "ok") {
            throw Exception('Unexpected response: ${resp.body}');
          }
        }
      }
      showSnackBar(context.strings.global_done_thanks, context);
    });
  }

  void _performNetworkAction(dynamic Function() action) async {
    try {
      setState(() {
        _loading = true;
      });
      await action.call();
    } catch (e) {
      showSnackBar(e.toString(), context);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
}
