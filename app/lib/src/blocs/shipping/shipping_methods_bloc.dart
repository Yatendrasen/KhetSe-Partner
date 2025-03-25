import 'package:admin/src/models/shipping/shipping_methods_model.dart';
import 'package:admin/src/models/shipping/shipping_zone_model.dart';
import 'package:admin/src/resources/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class ShippingMethodsBloc {

  final _dataFetcher = BehaviorSubject<List<ShippingMethods>>();
  final apiProvider = ApiProvider();

  ValueStream<List<ShippingMethods>> get allData => _dataFetcher.stream;

  Future<void> fetchData(ShippingZones zone) async {
    dynamic response = await apiProvider.get('shipping/zones/'+ zone.id.toString() +'/methods/?per_page=100');
    _dataFetcher.sink.add(shippingMethodsFromJson(response));
  }

  dispose() {
    _dataFetcher.close();
  }

}
