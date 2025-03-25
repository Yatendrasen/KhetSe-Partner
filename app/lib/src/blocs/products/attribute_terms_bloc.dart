import 'package:admin/src/resources/api_provider.dart';

import '../../models/product/product_attribute_model.dart';
import '../../resources/wc_api.dart';
import 'package:rxdart/rxdart.dart';

class AttributeTermBloc {
  late List<AttributeTerms> terms;

  final apiProvider = ApiProvider();

  final _termsFetcher = BehaviorSubject<List<AttributeTerms>>();

  ValueStream<List<AttributeTerms>> get allTerms => _termsFetcher.stream;
  
  fetchAllTerms(String id) async {
    final response = await apiProvider.get("products/attributes/" + id + "/terms?per_page=100");
    terms = attributeTermsFromJson(response);
    _termsFetcher.sink.add(terms);
  }

  dispose() {
    _termsFetcher.close();
  }
}
