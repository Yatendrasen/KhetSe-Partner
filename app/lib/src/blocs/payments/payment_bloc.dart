import 'package:admin/src/models/payment/payment_gateways_model.dart';
import 'package:admin/src/resources/api_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class PaymentGatewaysBloc with ChangeNotifier {
  var filter = new Map<String, dynamic>();
  int page = 1;
  bool moreItems = true;
  final apiProvider = ApiProvider();
  List<PaymentGateway> items = [];

  final _hasMoreResultsFetcher = BehaviorSubject<bool>();
  final _resultLoadingFetcher = BehaviorSubject<bool>();
  final _resultFetcher = BehaviorSubject<List<PaymentGateway>>();

  ValueStream<List<PaymentGateway>> get results => _resultFetcher.stream;
  ValueStream<bool> get hasMoreItems => _hasMoreResultsFetcher.stream;
  ValueStream<bool> get searchLoading => _resultLoadingFetcher.stream;

  fetchItems() async {
    page = 1;
    filter['per_page'] = 100;
    _resultLoadingFetcher.sink.add(true);
    final response = await apiProvider.get("payment_gateways" + getQueryString(filter));
    _resultLoadingFetcher.sink.add(false);
    items = paymentGatewayFromJson(response);
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
    final response = await apiProvider.get("payment_gateways" + getQueryString(filter));
    List<PaymentGateway> moreProducts = paymentGatewayFromJson(response);
    items.addAll(moreProducts);
    _resultFetcher.sink.add(items);
    if (moreProducts.length == 0) {
      _hasMoreResultsFetcher.sink.add(false);
    }
  }

  editItem(PaymentGateway item) async {
    PaymentGateway newItem = await apiProvider.editPaymentGateway(item);
    //_customersFetcher.sink.add(newItem);
  }

  dispose() {
    _hasMoreResultsFetcher.close();
    _resultFetcher.close();
    _resultLoadingFetcher.close();
  }
}
