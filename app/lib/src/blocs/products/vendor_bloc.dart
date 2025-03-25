import 'dart:convert';
import 'package:admin/src/models/orders/orders_model.dart';
import 'package:admin/src/resources/api_provider.dart';
import 'package:admin/src/models/product/checkout_form_model.dart';
import '../../models/product/product_variation_model.dart';
import '../../models/product/vendor_product_model.dart';
import 'package:rxdart/rxdart.dart';

class VendorBloc {
  late List<VendorProduct> products;
  late List<ProductVariation> variationProducts;
  var productFilter = new Map<String, dynamic>();
  var orderFilter = new Map<String, dynamic>();
  var variationFilter = new Map<String, dynamic>();
  int productPage = 0;
  String initialSelectedCountry = 'IN';

  var formData = new Map<String, String>();
  int ordersPage = 0;

  final apiProvider = ApiProvider();

  final _vendorProductsFetcher = BehaviorSubject<List<VendorProduct>>();
  final _vendorVariationProductsFetcher =
  BehaviorSubject<List<ProductVariation>>();
  final _ordersFetcher = BehaviorSubject<List<Order>>();
  final _vendorOrderFormFetcher = BehaviorSubject<CheckoutFormModel>();

  ValueStream<List<Order>> get allOrders => _ordersFetcher.stream;
  ValueStream<List<VendorProduct>> get allVendorProducts =>
      _vendorProductsFetcher.stream;
  ValueStream<List<ProductVariation>> get allVendorVariationProducts =>
      _vendorVariationProductsFetcher.stream;
  ValueStream<CheckoutFormModel> get vendorOrderForm =>
      _vendorOrderFormFetcher.stream;

  fetchAllProducts([String? query]) async {
    productFilter['page'] = 1;
    productFilter['per_page'] = 20;
    final response =
    await apiProvider.get("products" + getQueryString(productFilter));
    products = productFromJson(response);
    _vendorProductsFetcher.sink.add(products);
  }

  Future<VendorProduct> addProduct(VendorProduct product) async {
    final response = await apiProvider.post("products", product.toJson());
    return VendorProduct.fromJson(json.decode(response));
  }

  Future<VendorProduct> editProduct(VendorProduct product) async {
    final response = await apiProvider.put(
        "products/" + product.id.toString(), product.toJson());
    return VendorProduct.fromJson(json.decode(response));
  }

  Future<VendorProduct> deleteProduct(VendorProduct product) async {
    final response =
    await apiProvider.delete("products/" + product.id.toString());
    return VendorProduct.fromJson(json.decode(response));
  }

  Future<bool> loadMoreProducts() async {
    productFilter['page'] =
    productFilter['page'] == null ? 1 : productFilter['page'] + 1;
    final response =
    await apiProvider.get('products' + getQueryString(productFilter));
    List<VendorProduct> moreProducts = productFromJson(response);
    products.addAll(moreProducts);
    _vendorProductsFetcher.sink.add(products);
    if (moreProducts.length == 0) {
      return false;
    } else
      return true;
  }

  //orders

  List<Order> orders = [];

  getOrders([String? query]) async {
    orderFilter['page'] = 1;
    orderFilter['per_page'] = 20;
    final response =
    await apiProvider.get("orders" + getQueryString(orderFilter));
    orders = orderFromJson(response);
    _ordersFetcher.sink.add(orders);
    //_hasMoreOrdersFetcher.sink.add(true);
  }

  Future<bool> loadMoreOrders() async {
    orderFilter['page'] = orderFilter['page'] + 1;
    final response =
    await apiProvider.get("orders" + getQueryString(orderFilter));
    List<Order> moreOrders = orderFromJson(response);
    orders.addAll(moreOrders);
    _ordersFetcher.sink.add(orders);
    if (moreOrders.length < 10) {
      return false;
    }
    return true;
  }

  Future<Order> addOrder(Order order) async {
    final response = await apiProvider.post("orders", order.toJson());
    return Order.fromJson(json.decode(response));
  }

  Future<Order> editOrder(Order order) async {
    final response =
    await apiProvider.put("orders/" + order.id.toString(), order.toJson());
    return Order.fromJson(json.decode(response));
  }

  Future<dynamic> updateOrderStatus(Order order) async {
    final response =
    await apiProvider.put("orders/" + order.id.toString(), order.toJson());
  }

  Future<Order> deleteOrder(Order order) async {
    final response = await apiProvider.delete("orders/" + order.id.toString());
    return Order.fromJson(json.decode(response));
  }


  resetOrderFilter() {
    orderFilter.clear();
    orderFilter['page'] = 1;
    orderFilter['per_page'] = 20;
  }




//wallet

  getWallet() async {
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=mstoreapp-wallet', Map());
  }

  //Variation Products

  Future<void> getVariationProducts(int id) async {
    variationFilter['per_page'] = 100;
    final response = await apiProvider.get("products/" +
        id.toString() +
        "/variations" +
        getQueryString(variationFilter));
    variationProducts = productVariationFromJson(response);
    _vendorVariationProductsFetcher.sink.add(variationProducts);
  }

  Future<ProductVariation> addVariationProduct(
      int id, ProductVariation variationProduct) async {
    final response = await apiProvider.post(
        "products/" + id.toString() + "/variations", variationProduct.toJson());
    ProductVariation productVariation = ProductVariation.fromJson(json.decode(response));
    variationProducts.add(productVariation);
    _vendorVariationProductsFetcher.sink.add(variationProducts);
    return ProductVariation.fromJson(json.decode(response));
  }

  Future<ProductVariation> editVariationProduct(
      int productId, ProductVariation variationProduct) async {
    final response = await apiProvider.put(
        "products/" +
            productId.toString() +
            "/variations/" +
            variationProduct.id.toString(),
        variationProduct.toJson());
    return ProductVariation.fromJson(json.decode(response));
  }

  Future<ProductVariation> deleteVariationProduct(int id, int variationId) async {
    variationProducts.removeWhere((element) => element.id == variationId);
    _vendorVariationProductsFetcher.sink.add(variationProducts);
    final response = await apiProvider.delete("products/" + id.toString() + "/variations/" + variationId.toString() + '?force=true');
    return ProductVariation.fromJson(json.decode(response));
  }

  dispose() {
    _vendorProductsFetcher.close();
    _ordersFetcher.close();
    _vendorVariationProductsFetcher.close();
  }

  resetProductFilter() {
    productFilter.clear();
    productFilter['page'] = 1;
    productFilter['per_page'] = 20;
  }
}

String getQueryString(Map params,
    {String prefix = '&', bool inRecursion = false}) {
  String query = '?';

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
