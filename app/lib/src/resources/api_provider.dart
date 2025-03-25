import 'dart:async';
import 'dart:io';
import 'package:admin/src/config.dart';
import 'package:admin/src/models/app_state_model.dart';
import 'package:http/http.dart' show Client;
import 'package:admin/src/models/coupons/coupons_model.dart';
import 'package:admin/src/models/error/error_model.dart';
import 'package:admin/src/models/order_note/order_notes_model.dart';
import 'package:admin/src/models/payment/payment_gateways_model.dart';
import 'package:admin/src/models/refund/refund_model.dart';
import 'package:admin/src/models/sales/sales_model.dart';
import 'package:admin/src/models/sales/top_sellers_model.dart';
import 'dart:convert';
import 'package:admin/src/models/product/product_model.dart';
import 'package:admin/src/models/category/category_model.dart';
import 'package:admin/src/models/orders/orders_model.dart';
import 'package:admin/src/models/customer/customer_model.dart';
//import 'package:woocommerce_api/woocommerce_api.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;


import '../functions.dart';
import 'wc_api.dart';

class ApiProvider {
  Client client = Client();

  static final ApiProvider _apiProvider = new ApiProvider._internal();

  String lan = 'en';

  var filter = new Map<String, dynamic>();
  Config config = Config();

  factory ApiProvider() {
    return _apiProvider;
  }

  late WooCommerceAPI wc_api;

  ApiProvider._internal();

  Map<String, String> headers = {
    "content-type": "application/x-www-form-urlencoded; charset=utf-8"
  };
  Map<String, dynamic> cookies = {};
  List<Cookie> cookieList = [];

  Future initializationDone() async {

    wc_api = new WooCommerceAPI(config.url, config.consumerKey, config.consumerSecret);
    return true;

  }

  Future<ProductsModel> fetchProductList(filter) async {
    final response = await wc_api.getAsync("products" + filter);
    if (response.statusCode == 200) {
      return ProductsModel.fromJson(json.decode(response.body));
    } else {
      Errors errors = Errors.fromJson(json.decode(response.body));
      throw Exception('Failed to load product');
    }
  }

  Future<Product> editProduct(Product product) async {
    final response = await wc_api.putAsync(
        "products/" + product.id.toString(), product.toJson());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Product.fromJson(json.decode(response.body));
    } else {
      Errors errors = Errors.fromJson(json.decode(response.body));
      throw Exception('Failed to edit product');
    }
  }

  Future<Product> addProduct(Product product) async {
    final response = await wc_api.postAsync("products", product.toJson());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Product.fromJson(json.decode(response.body));
    } else {
      Errors errors = Errors.fromJson(json.decode(response.body));
      throw Exception('Failed to add product');
    }
  }

  Future<Product> deleteProduct(Product product) async {
    final response =
        await wc_api.deleteAsync("products/" + product.id.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Product.fromJson(json.decode(response.body));
    } else {
      Errors errors = Errors.fromJson(json.decode(response.body));
      throw Exception(errors.toString());
    }
  }

  // Categories

  Future<CategoriesModel> fetchCategoryList(filter) async {
    final response = await wc_api.getAsync("products/categories" + filter);
    if (response.statusCode == 200) {
      return CategoriesModel.fromJson(json.decode(response.body));
    } else {
      Errors errors = Errors.fromJson(json.decode(response.body));
      throw Exception(errors.toString());
    }
  }

  Future<Category> addCategory(Category category) async {
    final response =
        await wc_api.postAsync("products/categories", category.toJson());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Category.fromJson(json.decode(response.body));
    } else {
      Errors errors = Errors.fromJson(json.decode(response.body));
      throw Exception('Failed to add category');
    }
  }

  Future<Category> deleteCategory(Category category) async {
    final response = await wc_api.deleteAsync(
        "products/categories/" + category.id.toString() + '?force=true');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Category.fromJson(json.decode(response.body));
    } else {
      Errors errors = Errors.fromJson(json.decode(response.body));
      throw Exception(errors.message);
    }
  }

  Future<Category> editCategory(Category category) async {
    final response = await wc_api.putAsync(
        "products/categories/" + category.id.toString(), category.toJson());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Category.fromJson(json.decode(response.body));
    } else {
      Errors errors = Errors.fromJson(json.decode(response.body));
      throw Exception('Failed to edit category');
    }
  }

  //Customer

  Future<List<Customer>> fetchCustomerList(filter) async {
    final response = await wc_api.getAsync("customers" + filter);
    if (response.statusCode == 200) {
      return customerFromJson(response.body);
    } else {
      Errors errors = Errors.fromJson(json.decode(response.body));
      throw Exception(errors.message);
    }
  }

  Future<Customer> addCustomer(Customer customer) async {
    final response = await wc_api.postAsync("customers", customer.toJson(), 'Adding new customer...');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Customer.fromJson(json.decode(response.body));
    } else {
      Errors errors = Errors.fromJson(json.decode(response.body));
      throw Exception('Failed to add customer');
    }
  }

  Future<Customer> editCustomer(Customer customer) async {
    final response = await wc_api.putAsync(
        "customers/" + customer.id.toString(), customer.toJson());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Customer.fromJson(json.decode(response.body));
    } else {
      Errors errors = Errors.fromJson(json.decode(response.body));
      throw Exception('Failed to edit customer');
    }
  }

  Future<Customer> deleteCustomer(Customer customer) async {
    final response = await wc_api.deleteAsync("customers/" + customer.id.toString() + '?force=true');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Customer.fromJson(json.decode(response.body));
    } else {
      Errors errors = Errors.fromJson(json.decode(response.body));
      throw Exception('Failed to delete customer');
    }
  }

  Future<CategoriesModel> fetchProductDetail(int id) async {
    final response = await wc_api.getAsync("products/categories?per_page=100");
    return CategoriesModel.fromJson(json.decode(response.body));
    /*final response = await client
        .get("http://130.211.141.170/flutter/wp-admin/admin-ajax.php?action=mstoreapp-categories");
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return CategoriesModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load products');
    }*/
  }

  //Order

  Future<OrdersModel> fetchOrderList(filter) async {
    final response = await wc_api.getAsync("orders" + filter);
    if (response.statusCode == 200) {
      return OrdersModel.fromJson(json.decode(response.body));
    } else {
      Errors errors = Errors.fromJson(json.decode(response.body));
      throw Exception(errors.message);
    }
  }

  Future<OrdersModel> fetchOrderDetail(int id) async {
    final response = await wc_api.getAsync("orders?per_page=100");
    return OrdersModel.fromJson(json.decode(response.body));
    /*final response = await client
        .get("http://130.211.141.170/flutter/wp-admin/admin-ajax.php?action=mstoreapp-categories");
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return CategoriesModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load products');
    }*/
  }

  Future<Order> editOrder(Order order) async {
    final response =
        await wc_api.putAsync("orders/" + order.id.toString(), order.toJson());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Order.fromJson(json.decode(response.body));
    } else {
      Errors errors = Errors.fromJson(json.decode(response.body));
      throw Exception('Failed to edit order');
    }
  }

  Future<Order> addOrder(Order order, [String? s]) async {
    final response = await wc_api.postAsync("orders", order.toJson(), s);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Order.fromJson(json.decode(response.body));
    } else {
      Errors errors = Errors.fromJson(json.decode(response.body));
      throw Exception('Failed to add order');
    }
  }

  Future<Order> deleteOrder(Order order) async {
    final response = await wc_api.deleteAsync("orders/" + order.id.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Order.fromJson(json.decode(response.body));
    } else {
      Errors errors = Errors.fromJson(json.decode(response.body));
      throw Exception(errors.message);
    }
  }

  // Report

  Future<SalesModel> fetchSalesReport(String period) async {
    final response = await wc_api.getAsync("reports/sales?" + period);
    if (response.statusCode == 200) {
      return SalesModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Sales');
    }
  }

  Future<TopSellersModel> fetchTopSellersReport(String period) async {
    final response = await wc_api.getAsync("reports/top_sellers?" + period);
    if (response.statusCode == 200) {
      return TopSellersModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load TopSellers');
    }
  }

  //Coupon

  Future<CouponsModel> fetchCouponList(filter) async {
    final response = await wc_api.getAsync("coupons" + filter);
    if (response.statusCode == 200) {
      return CouponsModel.fromJson(json.decode(response.body));
    } else {
      Errors errors = Errors.fromJson(json.decode(response.body));
      throw Exception(errors.toString());
    }
  }

  Future<Coupon> addCoupon(Coupon coupon) async {
    final response = await wc_api.postAsync("coupons", coupon.toJson());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Coupon.fromJson(json.decode(response.body));
    } else {
      Errors errors = Errors.fromJson(json.decode(response.body));
      throw Exception('Failed to add Coupon');
    }
  }

  Future<Coupon> editCoupon(Coupon coupon) async {
    final response = await wc_api.putAsync(
        "coupons/" + coupon.id.toString(), coupon.toJson());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Coupon.fromJson(json.decode(response.body));
    } else {
      Errors errors = Errors.fromJson(json.decode(response.body));
      throw Exception('Failed to edit Coupon');
    }
  }

  Future<Coupon> deleteCoupon(Coupon coupon) async {
    final response = await wc_api
        .deleteAsync("coupons/" + coupon.id.toString() + '?force=true');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Coupon.fromJson(json.decode(response.body));
    } else {
      Errors errors = Errors.fromJson(json.decode(response.body));
      throw Exception(errors.message);
    }
  }

  //Order Notes

  Future<OrderNotesModel> fetchAllOrderNotes(String filter, String id) async {
    final response = await wc_api.getAsync("orders/" + id + "/notes/" + filter);
    if (response.statusCode == 200) {
      return OrderNotesModel.fromJson(json.decode(response.body));
    } else {
      Errors errors = Errors.fromJson(json.decode(response.body));
      throw Exception(errors.message);
    }
  }

  Future<OrderNote> addOrderNotes(OrderNote ordernotes, String id) async {
    final response =
        await wc_api.postAsync("orders/" + id + "/notes", ordernotes.toJson());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return OrderNote.fromJson(json.decode(response.body));
    } else {
      Errors errors = Errors.fromJson(json.decode(response.body));
      throw Exception('Failed to add order note');
    }
  }

  Future<OrderNote> deleteOrderNotes(OrderNote ordernotes, String id) async {
    final response = await wc_api.deleteAsync(
        "orders/" + id + "/notes/" + ordernotes.id.toString() + '?force=true');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return OrderNote.fromJson(json.decode(response.body));
    } else {
      Errors errors = Errors.fromJson(json.decode(response.body));
      throw Exception(errors.message);
    }
  }

  //Payments

  Future<PaymentGatewaysModel> fetchPaymentGatewayList(filter) async {
    final response = await wc_api.getAsync("payment_gateways" + filter);
    if (response.statusCode == 200) {
      return PaymentGatewaysModel.fromJson(json.decode(response.body));
    } else {
      Errors errors = Errors.fromJson(json.decode(response.body));
      throw Exception('Failed to load payment_gateways');
    }
  }

  Future<PaymentGateway> editPaymentGateway(
      PaymentGateway paymentGateway) async {
    final response = await wc_api.putAsync(
        "payment_gateways/" + paymentGateway.id.toString(),
        paymentGateway.toJson());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return PaymentGateway.fromJson(json.decode(response.body));
    } else {
      Errors errors = Errors.fromJson(json.decode(response.body));
      throw Exception('Failed to edit payment gateway');
    }
  }

  //Refund

  Future<RefundsModel> fetchRefundList(String filter, String id) async {
    final response =
        await wc_api.getAsync("orders/" + id + "/refunds" + filter);
    if (response.statusCode == 200) {
      return RefundsModel.fromJson(json.decode(response.body));
    } else {
      Errors errors = Errors.fromJson(json.decode(response.body));
      throw Exception(errors.message);
    }
  }

  Future<Refund> addRefund(Refund refund, String id) async {
    final response =
        await wc_api.postAsync("orders/" + id + "/refunds", refund.toJson());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Refund.fromJson(json.decode(response.body));
    } else {
      Errors errors = Errors.fromJson(json.decode(response.body));
      throw Exception('Failed to add refund');
    }
  }

  Future<Refund> deleteRefund(Refund refund, id) async {
    final response = await wc_api
        .deleteAsync("orders/" + id + "/refunds/" + refund.id.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Refund.fromJson(json.decode(response.body));
    } else {
      Errors errors = Errors.fromJson(json.decode(response.body));
      throw Exception('Failed to delete refund');
    }
  }

  Future<dynamic> get(String endPoint) async {
    final response = await wc_api.getAsync(endPoint);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      Errors errors = Errors.fromJson(json.decode(response.body));
      throw Exception(errors.message);
    }
  }

  Future<dynamic> post(String endPoint, Map data) async {
    final response = await wc_api.postAsync(endPoint, data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      Errors errors = Errors.fromJson(json.decode(response.body));
      throw Exception(errors.message);
    }
  }

  Future<dynamic> put(String endPoint, Map data) async {
    final response = await wc_api.putAsync(endPoint, data);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      Errors errors = Errors.fromJson(json.decode(response.body));
      throw Exception(errors.message);
    }
  }

  Future<dynamic> delete(String endPoint) async {
    final response = await wc_api.deleteAsync(endPoint);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      Errors errors = Errors.fromJson(json.decode(response.body));
      throw Exception(errors.message);
    }
  }

  Future<dynamic> postAjax(String endPoint, Map data) async {
    print(wc_api.url + '/wp-admin/admin-ajax.php?action=' + endPoint);
    String url = wc_api.url + '/wp-admin/admin-ajax.php?action=' + endPoint;
    headers['cookie'] = generateCookieHeader();
    headers['content-type'] = 'application/x-www-form-urlencoded; charset=utf-8';
    final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: data
    );
    _updateCookie(response);
    return response;
  }

  Future<dynamic> getWPJSON(String url) async {
    headers['cookie'] = generateCookieHeader();
    headers['content-type'] =
    'application/x-www-form-urlencoded; charset=utf-8';
    final response = await http.get(
        Uri.parse(url),
        headers: headers,
    );
    return response;
  }

  void _updateCookie(http.Response response) async {
    String? allSetCookie = response.headers['set-cookie'];
    if (allSetCookie != null) {
      var setCookies = allSetCookie.split(',');
      for (var setCookie in setCookies) {
        var cookies = setCookie.split(';');
        for (var cookie in cookies) {
          _setCookie(cookie);
        }
      }
      headers['cookie'] = generateCookieHeader();
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cookies', json.encode(cookies));
  }

  void _setCookie(String rawCookie) {
    if (rawCookie.length > 0) {
      var keyValue = rawCookie.split('=');
      if (keyValue.length == 2) {
        var key = keyValue[0].trim();
        var value = keyValue[1];
        if (key == 'path') return;
        cookies[key] = value;
      }
    }
  }

  String generateCookieHeader() {
    String cookie = "";
    for (var key in cookies.keys) {
      if (cookie.length > 0) cookie += "; ";
      cookie += key + "=" + cookies[key];
    }
    return cookie;
  }

  String generateWebViewCookieHeader() {
    String cookie = "";
    for (var key in cookies.keys) {
      if( key.contains('woocommerce') ||
          key.contains('wordpress')
      ) {
        if (cookie.length > 0) cookie += "; ";
        cookie += key + "=" + cookies[key];
      }
    }
    return cookie;
  }

  List<Cookie> generateCookies() {
    for (var key in cookies.keys) {
      Cookie ck = new Cookie(key, cookies[key]);
      cookieList.add(ck);
    }
    return cookieList;
  }

  Future<dynamic> postWithCookiesEncoded(String endPoint, Map data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cookies = prefs.getString('cookies') != null ? json.decode(prefs.getString('cookies')!) : {};
    headers['cookie'] = generateCookieHeader();
    final response = await http.post(
      Uri.parse(wc_api.url + endPoint),
      headers: headers,
      body: json.encode(data),
    );
    _updateCookie(response);
    return response;
  }

  Future<dynamic> getFromUrl(String url) async {
    final response = await http.get(
      Uri.parse(url),
    );
    return response;
  }

  Future<dynamic> posWPAjax(Map data) async {
    String url = wc_api.url + '/wp-admin/admin-ajax.php';
    headers['cookie'] = generateCookieHeader();
    final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body:data.toString()
    );
    _updateCookie(response);
    return response;
  }

  Future<dynamic> postWithCookies(String endPoint, Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cookies = prefs.getString('cookies') != null ? json.decode(prefs.getString('cookies')!) : {};
    headers['cookie'] = generateCookieHeader();
    filter.addAll(data);
    final response = await http.post(
      Uri.parse(wc_api.url + endPoint),
      headers: headers,
      body: data,
    );
    _updateCookie(response);
    return response;
  }

  Future<dynamic> adminAjax(Map data) async {
    final response = await http.post(
      Uri.parse(wc_api.url + '/wp-admin/admin-ajax.php'),
      headers: headers,
      body: data,
    );
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future init() async {

  }

}

String getQueryString(Map params,
    {String prefix = '&', bool inRecursion = false}) {
  String query = '?';

  params['flutter_app'] = '1';

  /*params.forEach((key, value) {
    ApiProvider().filter[key] = value;
  });*/

  ApiProvider().filter.forEach((key, value) {
    params[key] = value;
  });

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
