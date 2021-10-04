import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:plante/model/product.dart';
import 'package:plante/model/shop.dart';
import 'package:plante/model/user_params_controller.dart';
import 'package:plante/outside/map/shops_manager.dart';
import 'package:plante/ui/base/components/button_filled_plante.dart';
import 'package:plante/ui/base/components/checkbox_plante.dart';
import 'package:plante/ui/base/components/dialog_plante.dart';
import 'package:plante/ui/base/components/product_card.dart';
import 'package:plante/ui/base/snack_bar_utils.dart';
import 'package:plante/l10n/strings.dart';
import 'package:plante/ui/base/text_styles.dart';

class SelectProductsDialog extends StatefulWidget {
  final List<Product>? products;
  final Shop? shop;
  const SelectProductsDialog({Key? key, this.products, this.shop})
      : super(key: key);

  @override
  _SelectProductsDialogState createState() => _SelectProductsDialogState();
}

class _SelectProductsDialogState extends State<SelectProductsDialog> {
  final _shopsManager = GetIt.I.get<ShopsManager>();
  final _userParamsController = GetIt.I.get<UserParamsController>();
  List<Product>? _products;
  final _selectedProducts = <Product>{};

  @override
  void initState() {
    super.initState();
    if (widget.shop == null && widget.products == null) {
      throw ArgumentError('Either shop or products must be non-null');
    } else if (widget.shop != null && widget.products != null) {
      throw ArgumentError('Both shop and products cannot be non-null');
    }
    _initAsync();
  }

  void _initAsync() async {
    if (widget.products != null) {
      setState(() {
        _products = widget.products;
      });
      return;
    }
    final shop = widget.shop!;
    final rangeRes =
        await _shopsManager.fetchShopProductRange(shop, noCache: true);
    if (rangeRes.isErr) {
      showSnackBar(context.strings.global_something_went_wrong, context);
      return;
    }
    setState(() {
      _products = rangeRes.unwrap().products.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DialogPlante(
      contentWidth: 600,
      contentHeight: 800,
      title: Row(children: [
        if (_products == null) CircularProgressIndicator(),
        Text(
            widget.shop?.name ??
                context.strings.web_select_products_dialog_default_title,
            style: TextStyles.headline3)
      ]),
      content: ListView(
          children:
              (_products ?? const []).map((e) => _productWidget(e)).toList()),
      actions: ButtonFilledPlante.withText(context.strings.global_done,
          onPressed: () {
        Navigator.of(context).pop(_selectedProducts);
      }),
    );
  }

  Widget _productWidget(Product product) {
    return Stack(children: [
      ProductCard(
        product: product,
        beholder: _userParamsController.cachedUserParams!,
        onTap: () {
          setState(() {
            if (_selectedProducts.contains(product)) {
              _selectedProducts.remove(product);
            } else {
              _selectedProducts.add(product);
            }
          });
        },
      ),
      CheckboxPlante(
          value: _selectedProducts.contains(product),
          onChanged: (checked) {
            setState(() {
              if (checked ?? false) {
                _selectedProducts.add(product);
              } else {
                _selectedProducts.remove(product);
              }
            });
          })
    ]);
  }
}
