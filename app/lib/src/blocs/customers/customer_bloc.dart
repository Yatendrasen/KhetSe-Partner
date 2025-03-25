import 'package:admin/src/models/customer/customer_model.dart';
import 'package:admin/src/resources/api_provider.dart';
import 'package:admin/src/models/product/vendor_product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';


class CustomerBloc with ChangeNotifier {
  var filter = new Map<String, dynamic>();
  int page = 1;
  bool moreItems = true;
  final apiProvider = ApiProvider();
  List<Customer> items = [];
  String initialSelectedCountry = 'CA';

  final _hasMoreResultsFetcher = BehaviorSubject<bool>();
  final _resultLoadingFetcher = BehaviorSubject<bool>();
  final _resultFetcher = BehaviorSubject<List<Customer>>();

  ValueStream<List<Customer>> get results => _resultFetcher.stream;
  ValueStream<bool> get hasMoreItems => _hasMoreResultsFetcher.stream;
  ValueStream<bool> get searchLoading => _resultLoadingFetcher.stream;

  fetchItems() async {
    page = 1;
    filter['page'] = page.toString();
    filter['per_page'] = 20;
    _resultLoadingFetcher.sink.add(true);
    final response = await apiProvider.get("customers" + getQueryString(filter));
    _resultLoadingFetcher.sink.add(false);
    items = customerFromJson(response);
    _resultFetcher.sink.add(items);
    if (items.length == 0) {
      moreItems = false;
      _hasMoreResultsFetcher.sink.add(moreItems);
    } else {
      _hasMoreResultsFetcher.sink.add(true);
    }
  }

  loadMore() async {
    page = page + 1;
    filter['page'] = page.toString();
    _hasMoreResultsFetcher.sink.add(true);
    final response = await apiProvider.get("customers" + getQueryString(filter));
    List<Customer> moreProducts = customerFromJson(response);
    items.addAll(moreProducts);
    _resultFetcher.sink.add(items);
    if (moreProducts.length == 0) {
      _hasMoreResultsFetcher.sink.add(false);
    }
  }

  Future<bool> addItem(Customer customer) async {
    Customer newCusomer = await apiProvider.addCustomer(customer);
    return true;
    //_customersFetcher.sink.add(newCusomer);
  }

  deleteItem(Customer customer) async {
    Customer newCusomer = await apiProvider.deleteCustomer(customer);
    //_customersFetcher.sink.add(newCusomer);
  }

  editItem(Customer customer) async {
    Customer newCusomer = await apiProvider.editCustomer(customer);
    //_customersFetcher.sink.add(newCusomer);
  }

  dispose() {
    _hasMoreResultsFetcher.close();
    _resultFetcher.close();
    _resultLoadingFetcher.close();
  }
}
