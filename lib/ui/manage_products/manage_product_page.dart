import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:plante/outside/backend/backend.dart';
import 'package:plante/outside/backend/backend_product.dart';
import 'package:plante/ui/base/components/button_outlined_plante.dart';
import 'package:plante/ui/base/components/input_field_plante.dart';
import 'package:plante/ui/base/snack_bar_utils.dart';
import 'package:plante_web_admin/ui/components/checkbox_text.dart';
import 'package:plante_web_admin/ui/components/veg_statuses_widget.dart';
import 'package:plante/l10n/strings.dart';
import 'package:plante_web_admin/backend_extensions.dart';

class ManageProductPage extends StatefulWidget {
  const ManageProductPage({Key? key}) : super(key: key);

  @override
  _ManageProductPageState createState() => _ManageProductPageState();
}

class _ManageProductPageState extends State<ManageProductPage> {
  final _backend = GetIt.I.get<Backend>();
  final _barcodeInputController = TextEditingController();
  BackendProduct? _foundProduct;
  BackendProduct? _foundProductUnchanged;
  bool _loading = false;

  bool _changeProductVegStatuses = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: SingleChildScrollView(
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
                        Text(context
                            .strings.web_manage_product_page_type_barcode),
                      if (!_loading && _foundProduct != null)
                        Column(children: [
                          VegStatusesWidget(_onProductVegStatusesChange,
                              _changeProductVegStatuses, _foundProduct!),
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
                    ])))));
  }

  void _onProductSearch() async {
    _performNetworkAction(() async {
      final productRes =
          await _backend.requestProducts([_barcodeInputController.text], 0);
      final products = productRes.maybeOk()?.products;
      if (products != null && products.isNotEmpty) {
        _foundProduct = products.first;
        _foundProductUnchanged = _foundProduct;
      } else {
        _foundProduct = null;
        _foundProductUnchanged = null;
      }
      _changeProductVegStatuses = false;
    });
  }

  void _onProductVegStatusesChange(BackendProduct backendProduct) {
    setState(() {
      _foundProduct = backendProduct;
    });
  }

  bool _canSendModifications() {
    if (_foundProduct == null) {
      return false;
    }
    return true;
  }

  void _onSendModifications() async {
    _performNetworkAction(() async {
      final product = _foundProduct!;
      final initialProduct = _foundProductUnchanged!;
      if (_changeProductVegStatuses) {
        var resp = await _backend.recordCustomModerationAction(
            'Modified product from $initialProduct to $product',
            barcode: product.barcode);
        if (resp.isErr) {
          throw Exception('Backend error: ${resp.unwrapErr()}');
        }
        resp = await _backend.moderateProduct(
            product.barcode,
            product.veganStatus,
            product.moderatorVeganChoiceReasons,
            product.moderatorVeganSourcesText);
        if (resp.isErr) {
          throw Exception('Backend error: ${resp.unwrapErr()}');
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
