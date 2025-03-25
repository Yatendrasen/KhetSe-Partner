import 'package:admin/src/models/product/product_variation_model.dart';
import 'package:admin/src/resources/api_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';


class VariationProductBloc with ChangeNotifier {
  var filter = new Map<String, dynamic>();
  int page = 1;
  bool moreItems = true;
  final apiProvider = ApiProvider();
  List<ProductVariation> items = [];

  final _hasMoreResultsFetcher = BehaviorSubject<bool>();
  final _resultLoadingFetcher = BehaviorSubject<bool>();
  final _resultFetcher = BehaviorSubject<List<ProductVariation>>();

  ValueStream<List<ProductVariation>> get results => _resultFetcher.stream;
  ValueStream<bool> get hasMoreItems => _hasMoreResultsFetcher.stream;
  ValueStream<bool> get searchLoading => _resultLoadingFetcher.stream;

  fetchItems(int id) async {
    page = 1;
    filter['per_page'] = 100;
    _resultLoadingFetcher.sink.add(true);
    final response = await apiProvider.get("products/" + id.toString() + "/variations" + getQueryString(filter));
    _resultLoadingFetcher.sink.add(false);
    items = productVariationFromJson(response);
    _resultFetcher.sink.add(items);
    if (items.length == 0) {
      moreItems = false;
      _hasMoreResultsFetcher.sink.add(moreItems);
    } else {
      _hasMoreResultsFetcher.sink.add(true);
    }
  }

  loadMore(int id) async {
    page = page + 1;
    filter['page'] = page.toString();
    _hasMoreResultsFetcher.sink.add(true);
    final response = await apiProvider.get("products/" + id.toString() + "/variations" + getQueryString(filter));
    List<ProductVariation> moreProducts = productVariationFromJson(response);
    items.addAll(moreProducts);
    _resultFetcher.sink.add(items);
    if (moreProducts.length == 0) {
      _hasMoreResultsFetcher.sink.add(false);
    }
  }

  addItem(ProductVariation item) async {
    //ProductVariation newItem = await apiProvider.add(item);
    //_customersFetcher.sink.add(newItem);
  }

  deleteItem(ProductVariation item) async {
    //ProductVariation newItem = await apiProvider.deleteProductVariation(item);
    //_customersFetcher.sink.add(newItem);
  }

  editItem(ProductVariation item) async {
    //ProductVariation newItem = await apiProvider.editProductVariation(item);
    //_customersFetcher.sink.add(newItem);
  }

  dispose() {
    _hasMoreResultsFetcher.close();
    _resultFetcher.close();
    _resultLoadingFetcher.close();
  }
}
