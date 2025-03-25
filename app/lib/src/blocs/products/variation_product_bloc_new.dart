import 'dart:convert';
import 'package:admin/src/models/error/wp_rest_api_error.dart';
import 'package:admin/src/models/product/product_variation_model.dart';
import 'package:rxdart/rxdart.dart';
import '../../resources/api_provider.dart';
import '../../resources/wc_api.dart';

class VariationProductBloc {

  int page = 1;
  late List<ProductVariation> variationProducts;
  var variationFilter = new Map<String, dynamic>();
  final apiProvider = ApiProvider();
  final _variationProductsFetcher = BehaviorSubject<List<ProductVariation>>();
  ValueStream<List<ProductVariation>> get allVariationProducts => _variationProductsFetcher.stream;

  Future<void> getVariationProducts(int id) async {
    page = 1;
    variationFilter['per_page'] = 100;
    final response = await apiProvider.get("products/" + id.toString() + "/variations" + getQueryString(variationFilter));
    variationProducts = productVariationFromJson(response);
    _variationProductsFetcher.sink.add(variationProducts);
  }

  Future<void> loadMore(int id) async {
    page = page + 1;
    variationFilter['page'] = page.toString();
    final response = await apiProvider.get("products/" + id.toString() + "/variations" + getQueryString(variationFilter));
    variationProducts = productVariationFromJson(response);
    _variationProductsFetcher.sink.add(variationProducts);
  }

  Future<ProductVariation> addVariationProduct(int id, ProductVariation variationProduct) async {
    final response = await apiProvider.post("products/" + id.toString() + "/variations", variationProduct.toJson());
    ProductVariation productVariation = ProductVariation.fromJson(json.decode(response));
    variationProducts.add(productVariation);
    _variationProductsFetcher.sink.add(variationProducts);
    return ProductVariation.fromJson(json.decode(response));
  }

  Future<bool> editVariationProduct(int productId, ProductVariation variationProduct) async {
    final response = await apiProvider.put("products/" + productId.toString() + "/variations/" + variationProduct.id.toString(), variationProduct.toJson());
    return true;
  }

  Future<bool> deleteVariationProduct(int id, int variationId) async {
    variationProducts.removeWhere((element) => element.id == variationId);
    _variationProductsFetcher.sink.add(variationProducts);
    final response = await apiProvider.delete("products/" + id.toString() + "/variations/" + variationId.toString() + '?force=true');
    return true;
  }

  dispose() {
    _variationProductsFetcher.close();
  }
}

String getQueryString(Map params,
    {String prefix = '&', bool inRecursion = false}) {
  String query = '?';

  params['flutter_app'] = '1';

  params.forEach((key, value) {
    if (inRecursion) {
      key = '[$key]';
    }

    if (value is String || value is int || value is double || value is bool) {
      query += '$prefix$key=$value';
    } else if (value is List || value is Map) {
      if (value is List) value = value.asMap();
      value.forEach((k, v) {
        query +=
            getQueryString({k: v}, prefix: '$prefix$key', inRecursion: false);
      });
    }
  });

  return query;
}
