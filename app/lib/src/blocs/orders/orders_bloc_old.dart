/*
import 'package:flutter/material.dart';
import '../../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:admin/src/models/orders/orders_model.dart';

class OrdersBloc {
  String search = '';
  String perPage = '100';
  String filter = '';
  String order = 'desc';
  String orderBy = 'date';
  String status = 'any';
  bool hideEmpty = false;
  String parent = '';
  String product = '';
  String customer = '';
  OrdersModel? orders;
  bool hasMoreItems = true;
  int page = 0;
  DateTime? dateCreated;
  DateTime? dateModified;
  String initialSelectedCountry = 'CA';
  var formData = new Map<String, String>();

  final _repository = Repository();
  final _ordersFetcher = BehaviorSubject<OrdersModel>();

  ValueStream<OrdersModel> get allOrders => _ordersFetcher.stream;

  fetchAllOrders([String? query]) async {
    page = 1;
    this.setFilter();
    if(query != null){ filter = filter + query; }
    //var filter = '?page=' + page.toString();

    orders = await _repository.fetchAllOrders(filter);
    _ordersFetcher.sink.add(orders!);
  }


  addOrder(Order order) async {
    Order newOrder = await _repository.addOrders(order);
    // _ordersFetcher.sink.add(ordersModel);
  }


  editOrder(Order order) async {
    Order newOrder = await _repository.editOrder(order);
    //_ordersFetcher.sink.add(newOrder);
  }

  deleteOrder(Order order) async {
    Order newOrder = await _repository.deleteOrder(order);
    //_customersFetcher.sink.add(newCusomer);
  }

  loadMore() async {
    page = page + 1;
    this.setFilter();
    OrdersModel moreOrders = await _repository.fetchAllOrders(filter);
    orders!.orders.addAll(moreOrders.orders);
    _ordersFetcher.sink.add(orders!);
    if(moreOrders.orders.length == 0)
      hasMoreItems = false;
  }


  dispose() {
    _ordersFetcher.close();
  }

  void setFilter() {
    filter = '?page=' + page.toString();
    filter = filter + '&per_page=' + perPage;
    filter = filter + '&order=$order&orderby=$orderBy';
    if (search.isNotEmpty) filter = filter + '&search=$search';
    if (hideEmpty) filter = filter + '&hide_empty=$hideEmpty';
    if (parent.isNotEmpty) filter = filter + '&parent=$parent';
    if (product.isNotEmpty) filter = filter + '&product=$product';
    if (customer.isNotEmpty) filter = filter + '&customer=$customer';
    if (status != 'any') filter = filter + '&status=$status';
  }

  void reset() {
    search = '';
    page = 0;
    filter = '?per_page=100';
    order = 'desc';
    orderBy = 'date';
    status = 'any';
    hideEmpty = false;
    parent = '';
    product = '';
    customer = '';
  }
}

final bloc = OrdersBloc();
*/
