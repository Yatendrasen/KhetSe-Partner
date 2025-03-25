import 'package:admin/src/resources/api_provider.dart';
import 'package:admin/src/models/product/vendor_product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';


class ProductBloc with ChangeNotifier {
  var filter = new Map<String, dynamic>();
  int page = 1;
  bool moreItems = true;
  final apiProvider = ApiProvider();
  List<VendorProduct> products = [];

  final _hasMoreSearchItemsFetcher = BehaviorSubject<bool>();
  final _searchLoadingFetcher = BehaviorSubject<bool>();
  final _searchFetcher = BehaviorSubject<List<VendorProduct>>();

  ValueStream<List<VendorProduct>> get searchResults => _searchFetcher.stream;
  ValueStream<bool> get hasMoreItems => _hasMoreSearchItemsFetcher.stream;
  ValueStream<bool> get searchLoading => _searchLoadingFetcher.stream;

  fetchProducts() async {
    page = 1;
    filter['page'] = page.toString();
    _searchLoadingFetcher.sink.add(true);
    final response = await apiProvider.get("products" + getQueryString(filter));
    _searchLoadingFetcher.sink.add(false);
    products = productFromJson(response);
    _searchFetcher.sink.add(products);
    if (products.length == 0) {
      moreItems = false;
      _hasMoreSearchItemsFetcher.sink.add(moreItems);
    } else {
      _hasMoreSearchItemsFetcher.sink.add(true);
    }
  }

  loadMoreSearchResults() async {
    page = page + 1;
    filter['page'] = page.toString();
    _hasMoreSearchItemsFetcher.sink.add(true);
    final response = await apiProvider.get("products" + getQueryString(filter));
    List<VendorProduct> moreProducts = productFromJson(response);
    products.addAll(moreProducts);
    _searchFetcher.sink.add(products);
    if (moreProducts.length == 0) {
      _hasMoreSearchItemsFetcher.sink.add(false);
    }
  }

  dispose() {
    _hasMoreSearchItemsFetcher.close();
    _searchFetcher.close();
    _searchLoadingFetcher.close();
  }

  getProductBySKU(String sku) async {
    var filter = new Map<String, dynamic>();
    filter['sku'] = sku;
    final response = await apiProvider.get("products" + getQueryString(filter));
    List<VendorProduct> products = productFromJson(response);
    return products;
  }
}
