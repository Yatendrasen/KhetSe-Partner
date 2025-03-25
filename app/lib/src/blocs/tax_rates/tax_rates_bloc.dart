import 'package:admin/src/models/tax_rates/tax_rates.dart';
import 'package:admin/src/resources/api_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class TaxRatesBloc with ChangeNotifier {
  var filter = new Map<String, dynamic>();
  int page = 1;
  bool moreItems = true;
  final apiProvider = ApiProvider();
  List<TaxRatesModel> items = [];

  final _hasMoreResultsFetcher = BehaviorSubject<bool>();
  final _resultLoadingFetcher = BehaviorSubject<bool>();
  final _resultFetcher = BehaviorSubject<List<TaxRatesModel>>();

  ValueStream<List<TaxRatesModel>> get results => _resultFetcher.stream;
  ValueStream<bool> get hasMoreItems => _hasMoreResultsFetcher.stream;
  ValueStream<bool> get searchLoading => _resultLoadingFetcher.stream;

  fetchItems() async {
    page = 1;
    filter['per_page'] = 100;
    _resultLoadingFetcher.sink.add(true);
    final response = await apiProvider.get("taxes" + getQueryString(filter));
    _resultLoadingFetcher.sink.add(false);
    items = taxRatesModelFromJson(response);
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
    final response = await apiProvider.get("taxes" + getQueryString(filter));
    List<TaxRatesModel> moreItems = taxRatesModelFromJson(response);
    items.addAll(moreItems);
    _resultFetcher.sink.add(items);
    if (moreItems.length == 0) {
      _hasMoreResultsFetcher.sink.add(false);
    }
  }

  addItem(TaxRatesModel item) async {
    final response = await apiProvider.post("taxes", item.toJson());
    fetchItems();
    //_customersFetcher.sink.add(newItem);
  }

  deleteItem(TaxRatesModel item) async {
    items.remove(item);
    _resultFetcher.sink.add(items);
    final response = await apiProvider.delete("taxes/" + item.id.toString() + '?force=true');
    fetchItems();
    //_customersFetcher.sink.add(newItem);
  }

  editItem(TaxRatesModel item) async {
    final response = await apiProvider.put("taxes/" + item.id.toString(), item.toJson());
    fetchItems();
    //_customersFetcher.sink.add(newItem);
  }

  dispose() {
    _hasMoreResultsFetcher.close();
    _resultFetcher.close();
    _resultLoadingFetcher.close();
  }
}
