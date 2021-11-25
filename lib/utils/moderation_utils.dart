import 'package:get_it/get_it.dart';
import 'package:plante/base/pair.dart';
import 'package:plante/base/result.dart';
import 'package:plante/model/product.dart';
import 'package:plante/outside/map/address_obtainer.dart';
import 'package:plante/outside/map/open_street_map.dart';
import 'package:plante/outside/map/osm_address.dart';
import 'package:plante/outside/map/osm_shop.dart';
import 'package:plante/outside/map/osm_uid.dart';
import 'package:plante/outside/products/products_obtainer.dart';

class ModerationUtils {
  static Future<Result<Pair<OsmShop, OsmAddress>, String>> shopAndAddress(
      OsmUID uid) async {
    final osm = GetIt.I.get<OpenStreetMap>();
    final addressObtainer = GetIt.I.get<AddressObtainer>();

    final osmShopsRes = await osm
        .withOverpass((overpass) => overpass.fetchShops(osmUIDs: [uid]));
    if (osmShopsRes.isErr) {
      return Err(osmShopsRes.toString());
    }
    final osmShops = osmShopsRes.unwrap();
    if (osmShops.isEmpty) {
      return Err('Shop $uid is not found');
    }
    final shop = osmShops.first;
    final addressRes = await addressObtainer.addressOfCoords(shop.coord);
    if (addressRes.isErr) {
      return Err('Address of $uid could not be obtained: $addressRes');
    }
    final address = addressRes.unwrap();
    return Ok(Pair(shop, address));
  }

  static Future<Result<Product?, String>> productWith(String barcode) async {
    final productsObtainer = GetIt.I.get<ProductsObtainer>();
    final productRes = await productsObtainer.getProduct(barcode);
    if (productRes.isErr) {
      return Err(productRes.toString());
    }
    return Ok(productRes.unwrap());
  }
}
