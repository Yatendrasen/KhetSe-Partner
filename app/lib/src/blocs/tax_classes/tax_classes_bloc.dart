import 'package:admin/src/models/tax_class/tax_class.dart';
import 'package:admin/src/resources/api_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class TaxClassesBloc with ChangeNotifier {
  var filter = new Map<String, dynamic>();
  int page = 1;
  bool moreItems = true;
  final apiProvider = ApiProvider();
  List<TaxClassModel> items = [];

  final _hasMoreResultsFetcher = BehaviorSubject<bool>();
  final _resultLoadingFetcher = BehaviorSubject<bool>();
  final _resultFetcher = BehaviorSubject<List<TaxClassModel>>();

  ValueStream<List<TaxClassModel>> get results => _resultFetcher.stream;
  ValueStream<bool> get hasMoreItems => _hasMoreResultsFetcher.stream;
  ValueStream<bool> get searchLoading => _resultLoadingFetcher.stream;

  fetchItems() async {
    page = 1;
    filter['per_page'] = 100;
    _resultLoadingFetcher.sink.add(true);
    final response = await apiProvider.get("taxes/classes" + getQueryString(filter));
    _resultLoadingFetcher.sink.add(false);
    items = taxClassModelFromJson(response);
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
    final response = await apiProvider.get("taxes/classes" + getQueryString(filter));
    List<TaxClassModel> moreItems = taxClassModelFromJson(response);
    items.addAll(moreItems);
    _resultFetcher.sink.add(items);
    if (moreItems.length == 0) {
      _hasMoreResultsFetcher.sink.add(false);
    }
  }

  addItem(TaxClassModel item) async {
    final response = await apiProvider.post("taxes/classes", item.toJson());
    fetchItems();
    //_customersFetcher.sink.add(newItem);
  }

  deleteItem(TaxClassModel item) async {
    items.remove(item);
    _resultFetcher.sink.add(items);
    final response = await apiProvider.delete("taxes/classes/" + item.slug.toString() + '?force=true');
    fetchItems();
    //_customersFetcher.sink.add(newItem);
  }

  editItem(TaxClassModel item) async {
    final response = await apiProvider.put("taxes/classes/" + item.slug.toString(), item.toJson());
    fetchItems();
    //_customersFetcher.sink.add(newItem);
  }

  dispose() {
    _hasMoreResultsFetcher.close();
    _resultFetcher.close();
    _resultLoadingFetcher.close();
  }
}
