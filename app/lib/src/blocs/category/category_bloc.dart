import 'package:admin/src/models/category/category_model.dart';
import 'package:admin/src/models/customer/customer_model.dart';
import 'package:admin/src/resources/api_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';


class CategoryBloc with ChangeNotifier {
  var filter = new Map<String, dynamic>();
  int page = 1;
  bool moreItems = true;
  final apiProvider = ApiProvider();
  List<Category> items = [];

  final _hasMoreResultsFetcher = BehaviorSubject<bool>();
  final _resultLoadingFetcher = BehaviorSubject<bool>();
  final _resultFetcher = BehaviorSubject<List<Category>>();

  ValueStream<List<Category>> get results => _resultFetcher.stream;
  ValueStream<bool> get hasMoreItems => _hasMoreResultsFetcher.stream;
  ValueStream<bool> get searchLoading => _resultLoadingFetcher.stream;

  fetchItems() async {
    page = 1;
    filter['per_page'] = 100;
    _resultLoadingFetcher.sink.add(true);
    final response = await apiProvider.get("products/categories" + getQueryString(filter));
    _resultLoadingFetcher.sink.add(false);
    items = categoryFromJson(response);
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
    final response = await apiProvider.get("products/categories" + getQueryString(filter));
    List<Category> moreProducts = categoryFromJson(response);
    items.addAll(moreProducts);
    _resultFetcher.sink.add(items);
    if (moreProducts.length == 0) {
      _hasMoreResultsFetcher.sink.add(false);
    }
  }

  addItem(Category item) async {
    Category newItem = await apiProvider.addCategory(item);
    //_customersFetcher.sink.add(newItem);
  }

  deleteItem(Category item) async {
    Category newItem = await apiProvider.deleteCategory(item);
    //_customersFetcher.sink.add(newItem);
  }

  editItem(Category item) async {
    Category newItem = await apiProvider.editCategory(item);
    //_customersFetcher.sink.add(newItem);
  }

  dispose() {
    _hasMoreResultsFetcher.close();
    _resultFetcher.close();
    _resultLoadingFetcher.close();
  }
}
