import 'package:admin/src/models/product/reviews.dart';
import 'package:admin/src/models/shipping/shipping_zone_model.dart';
import 'package:admin/src/resources/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class ShippingZoneBloc {

  final _dataFetcher = BehaviorSubject<List<ShippingZones>>();
  final apiProvider = ApiProvider();

  ValueStream<List<ShippingZones>> get allData => _dataFetcher.stream;

  Future<void> fetchData() async {
    dynamic response = await apiProvider.get('shipping/zones/?per_page=100');
    _dataFetcher.sink.add(shippingZonesFromJson(response));
  }

  dispose() {
    _dataFetcher.close();
  }

}
