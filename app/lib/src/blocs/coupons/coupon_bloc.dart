import 'package:admin/src/models/coupons/coupons_model.dart';
import 'package:admin/src/resources/api_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class CouponsBloc with ChangeNotifier {
  var filter = new Map<String, dynamic>();
  int page = 1;
  bool moreItems = true;
  final apiProvider = ApiProvider();
  List<Coupon> items = [];

  final _hasMoreResultsFetcher = BehaviorSubject<bool>();
  final _resultLoadingFetcher = BehaviorSubject<bool>();
  final _resultFetcher = BehaviorSubject<List<Coupon>>();

  ValueStream<List<Coupon>> get results => _resultFetcher.stream;
  ValueStream<bool> get hasMoreItems => _hasMoreResultsFetcher.stream;
  ValueStream<bool> get searchLoading => _resultLoadingFetcher.stream;

  fetchItems() async {
    page = 1;
    filter['per_page'] = 100;
    _resultLoadingFetcher.sink.add(true);
    final response = await apiProvider.get("coupons" + getQueryString(filter));
    _resultLoadingFetcher.sink.add(false);
    items = couponFromJson(response);
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
    final response = await apiProvider.get("coupons" + getQueryString(filter));
    List<Coupon> moreProducts = couponFromJson(response);
    items.addAll(moreProducts);
    _resultFetcher.sink.add(items);
    if (moreProducts.length == 0) {
      _hasMoreResultsFetcher.sink.add(false);
    }
  }

  addItem(Coupon item) async {
    Coupon newItem = await apiProvider.addCoupon(item);
    //_customersFetcher.sink.add(newItem);
  }

  deleteItem(Coupon item) async {
    Coupon newItem = await apiProvider.deleteCoupon(item);
    //_customersFetcher.sink.add(newItem);
  }

  editItem(Coupon item) async {
    Coupon newItem = await apiProvider.editCoupon(item);
    //_customersFetcher.sink.add(newItem);
  }

  dispose() {
    _hasMoreResultsFetcher.close();
    _resultFetcher.close();
    _resultLoadingFetcher.close();
  }
}
