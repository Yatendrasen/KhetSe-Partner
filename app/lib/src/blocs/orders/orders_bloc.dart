import 'dart:convert';
import 'package:admin/src/models/app_state_model.dart';
import 'package:admin/src/models/orders/orders_model.dart';
import 'package:admin/src/models/product/vendor_product_model.dart';
import 'package:admin/src/models/snackbar_activity.dart';
import 'package:admin/src/models/status.dart';
import 'package:admin/src/resources/api_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';


class OrdersBloc with ChangeNotifier {
  var filter = new Map<String, dynamic>();
  int page = 1;
  bool moreItems = true;
  final apiProvider = ApiProvider();
  final appStateModel = AppStateModel();
  List<Order> items = [];

  final _hasMoreResultsFetcher = BehaviorSubject<bool>();
  final _resultLoadingFetcher = BehaviorSubject<bool>();
  final _resultFetcher = BehaviorSubject<List<Order>>();

  ValueStream<List<Order>> get results => _resultFetcher.stream;
  ValueStream<bool> get hasMoreItems => _hasMoreResultsFetcher.stream;
  ValueStream<bool> get searchLoading => _resultLoadingFetcher.stream;

  fetchItems() async {
    page = 1;
    filter['per_page'] = 10;
    filter['page'] = page.toString();
    _resultLoadingFetcher.sink.add(true);
    final response = await apiProvider.get("orders" + getQueryString(filter));
    _resultLoadingFetcher.sink.add(false);
    items = orderFromJson(response);
    _resultFetcher.sink.add(items);
    if (items.length < 10) {
      moreItems = false;
      _hasMoreResultsFetcher.sink.add(moreItems);
    } else {
      _hasMoreResultsFetcher.sink.add(true);
    }
  }

  Future<Order?> fetchNewOrderOnNotification() async {
    page = 1;
    filter['per_page'] = 10;
    filter['page'] = page.toString();
    _resultLoadingFetcher.sink.add(true);
    final response = await apiProvider.get("orders" + getQueryString(filter));
    _resultLoadingFetcher.sink.add(false);
    items = orderFromJson(response);
    _resultFetcher.sink.add(items);
    if (items.length < 10) {
      moreItems = false;
      _hasMoreResultsFetcher.sink.add(moreItems);
    } else {
      _hasMoreResultsFetcher.sink.add(true);
    }
    if(items.length > 0) {
      return items.first;
    } else {
      return null;
    }
  }

  loadMore() async {
    page = page + 1;
    filter['page'] = page.toString();
    _hasMoreResultsFetcher.sink.add(true);
    final response = await apiProvider.get("orders" + getQueryString(filter));
    List<Order> moreProducts = orderFromJson(response);
    items.addAll(moreProducts);
    _resultFetcher.sink.add(items);
    if (moreProducts.length == 0) {
      _hasMoreResultsFetcher.sink.add(false);
    }
  }

  addItem(Order item) async {
    Order newItem = await apiProvider.addOrder(item, 'Posting new order...');
    return newItem;
    //_customersFetcher.sink.add(newItem);
  }

  deleteItem(Order item) async {
    Order newItem = await apiProvider.deleteOrder(item);
    //_customersFetcher.sink.add(newItem);
  }

  editItem(Order item) async {
    Order newItem = await apiProvider.editOrder(item);
    //_customersFetcher.sink.add(newItem);
  }

  Future<dynamic> updateItem(Order order) async {
    final response = await apiProvider.put("orders/" + order.id.toString(), order.toJson());
  }

  Future<VendorProduct> getProduct(String id) async {
    final response = await apiProvider.get("products/" + id.toString());
    return VendorProduct.fromJson(json.decode(response));
  }

  dispose() {
    _hasMoreResultsFetcher.close();
    _resultFetcher.close();
    _resultLoadingFetcher.close();
  }

  Future<void> sendInvoice() async {
    //final response = await apiProvider.postAjax(''endPoint'', {});
  }

  Future<bool> orderAction(String action, int id) async {
    final response = await apiProvider.postAjax('build-app-online-admin_order_action', {'order_id': id.toString(), 'order_action': action});
    return true;
  }

  Future<void> acceptOrder(Order order, String driverId) async {
    appStateModel.messageFetcher.add(SnackBarActivity(loading: true, success: true, message: 'Accepting Order - ' + order.id.toString()));
    final response = await apiProvider.postAjax("build-app-online-admin_assign_delivery_boy", { "order_id": order.id.toString(), "user_id": driverId.toString() });
    if (response.statusCode == 200) {
      appStateModel.messageFetcher.add(SnackBarActivity(show: false, loading: true, success: true, message: 'Accepting Order - ' + order.id.toString()));
      Status status = statusFromJson(response.body);
      if(status.status == true) {
        appStateModel.messageFetcher.add(SnackBarActivity(success: true, message: status.message!));
        items.remove(order);
        _resultFetcher.sink.add(items);

        var orderItemId = [];
        var productId = [];
        for(var item in order.lineItems) {
          orderItemId.add(item.id);
          productId.add(item.productId);
        }

        Map<String, dynamic> data = { 'tracking_url': '', 'tracking_code': '', 'tracking_data': '', 'orderitemid': '', 'productid': '', 'action': 'wcfm_wcfmmarketplace_order_mark_shipped', 'orderid': order.id.toString(), 'wcfm_delivery_boy': driverId };

        data['orderitemid'] = orderItemId.join(',');
        data['productid'] = productId.join(',');

        var trackingData = new Map<String, dynamic>();

        trackingData['wcfm_tracking_code'] = '';
        trackingData['wcfm_tracking_url'] = '';
        trackingData['wcfm_tracking_order_id'] = order.id.toString();
        trackingData['wcfm_tracking_product_id'] = productId.join('%2C');
        trackingData['wcfm_tracking_order_item_id'] = orderItemId.join('%2C');
        trackingData['wcfm_delivery_boy'] = driverId;

        data['tracking_data'] = getQueryStrings(trackingData, prefix: '&');//"wcfm_tracking_code=&wcfm_tracking_url=&wcfm_tracking_order_id=" + order.id.toString() + "&wcfm_tracking_product_id=" + data['productid'].toString() + "&wcfm_tracking_order_item_id=" + data['productid'].toString() + "&wcfm_delivery_boy=" + appStateModel.user.id.toString();

        apiProvider.adminAjax(data);

      } else {
        appStateModel.messageFetcher.add(SnackBarActivity(message: status.message!));
      }
    }
  }

  Future<void> delivered(Order order) async {

    items.singleWhere((element) => element == order).status = "delivered";
    _resultFetcher.sink.add(items);

    final response = await apiProvider.postAjax('build-app-online-admin_get_delivery_info', {'order_id': order.id.toString()});
    if (response.statusCode == 200) {
      List<DeliveryIds> ids = deliveryIdsFromJson(response.body);
      ids.forEach((element) async {
        Map<String, dynamic> data = {'action': 'mark_wcfm_order_delivered', 'delivery_id': element.id.toString()};
        await apiProvider.adminAjax(data);
      });
    }

    apiProvider.put("orders/" + order.id.toString(), {"status": "delivered"});

  }

  String getQueryStrings(Map params,
      {String prefix = '&', bool inRecursion = false}) {
    String query = '';

    //params['driver_app'] = '1';
    //params['distance'] = '10';

    filter.forEach((key, value) {
      params[key] = value;
    });

    //params.remove('address');

    params.forEach((key, value) {
      if (inRecursion) {
        key = '[$key]';
      }

      if (value is String || value is int || value is double || value is bool) {
        query += '$prefix$key=$value';
      } else if (value is List || value is Map) {
        if (value is List) value = value.asMap();
        value.forEach((k, v) {
          query += getQueryString({k: v}, prefix: '$prefix$key', inRecursion: false);
        });
      }
    });

    return query;
  }

  void completeOrder(Order order) {
    apiProvider.put("orders/" + order.id.toString(), {"status": "completed"});
    items.remove(order);
    _resultFetcher.sink.add(items);
  }

  Future<void> driverAcceptOrder(Order order) async {
    appStateModel.messageFetcher.add(SnackBarActivity(loading: true, success: true, message: 'Accepting Order - ' + order.id.toString()));
    final response = await apiProvider.postAjax("build-app-online-admin_assign_delivery_boy", { "order_id": order.id.toString() });
    if (response.statusCode == 200) {
      appStateModel.messageFetcher.add(SnackBarActivity(show: false, loading: true, success: true, message: 'Accepting Order - ' + order.id.toString()));
      Status status = statusFromJson(response.body);
      if(status.status == true) {
        appStateModel.messageFetcher.add(SnackBarActivity(success: true, message: status.message!));
        items.remove(order);
        _resultFetcher.sink.add(items);

        var orderItemId = [];
        var productId = [];
        for(var item in order.lineItems) {
          orderItemId.add(item.id);
          productId.add(item.productId);
        }

        Map<String, dynamic> data = { 'tracking_url': '', 'tracking_code': '', 'tracking_data': '', 'orderitemid': '', 'productid': '', 'action': 'wcfm_wcfmmarketplace_order_mark_shipped', 'orderid': order.id.toString(), 'wcfm_delivery_boy': appStateModel.user!.id.toString() };

        data['orderitemid'] = orderItemId.join(',');
        data['productid'] = productId.join(',');

        var trackingData = new Map<String, dynamic>();

        trackingData['wcfm_tracking_code'] = '';
        trackingData['wcfm_tracking_url'] = '';
        trackingData['wcfm_tracking_order_id'] = order.id.toString();
        trackingData['wcfm_tracking_product_id'] = productId.join('%2C');
        trackingData['wcfm_tracking_order_item_id'] = orderItemId.join('%2C');
        trackingData['wcfm_delivery_boy'] = appStateModel.user!.id.toString();

        data['tracking_data'] = getQueryString(trackingData, prefix: '&');//"wcfm_tracking_code=&wcfm_tracking_url=&wcfm_tracking_order_id=" + order.id.toString() + "&wcfm_tracking_product_id=" + data['productid'].toString() + "&wcfm_tracking_order_item_id=" + data['productid'].toString() + "&wcfm_delivery_boy=" + appStateModel.user.id.toString();

        apiProvider.adminAjax(data);

      } else {
        appStateModel.messageFetcher.add(SnackBarActivity(message: status.message!));
      }
    }
  }

}
