import 'dart:async';

import 'package:admin/src/resources/api_provider.dart';

import '../../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:admin/src/models/sales/sales_model.dart';
import 'package:admin/src/models/sales/top_sellers_model.dart';

class ReportBloc {

  final _repository = Repository();
  final _salesFetcher = BehaviorSubject<SalesModel>();
  final _topSellersFetcher = BehaviorSubject<TopSellersModel>();

  final _periodTypeController = StreamController<String>();
  var apiProvider = ApiProvider();

  ValueStream<SalesModel> get sales => _salesFetcher.stream;
 ValueStream<TopSellersModel> get topSellers => _topSellersFetcher.stream;

  Sink<String> get periodType => _periodTypeController.sink;

  ReportBloc() {
    //fetchSalesReport('month');
    _periodTypeController.stream.listen((period) async {
      fetchSalesReport(period);
    });
  }

  fetchSalesReport(period) async {
    SalesModel sales = await _repository.fetchSalesReport('period='+period);
    TopSellersModel topSellers = await _repository.fetchTopSellersReport('period='+period);
    _salesFetcher.sink.add(sales);
    _topSellersFetcher.sink.add(topSellers);
    return;
  }

  fetchSalesReportByDate(period) async {
    fetchTopSellerReportByDate(period);
    SalesModel sales = await _repository.fetchSalesReport(period);
    _salesFetcher.sink.add(sales);
  }

  fetchTopSellerReportByDate(period) async {
    TopSellersModel topSellers = await _repository.fetchTopSellersReport(period);
    _topSellersFetcher.sink.add(topSellers);
  }


  dispose() {
    _salesFetcher.close();
    _topSellersFetcher.close();
  }
}
