import 'package:admin/src/resources/api_provider.dart';

import '../../models/product/product_attribute_model.dart';
import '../../resources/wc_api.dart';
import 'package:rxdart/rxdart.dart';

class AttributeBloc {
  late List<ProductAttribute> attributes;
  late List<AttributeTerms> terms;

  //static WooCommerceAPI wc_api = new WooCommerceAPI();

  final apiProvider = ApiProvider();

  final _attributeFetcher = BehaviorSubject<List<ProductAttribute>>();
  final _termsFetcher = BehaviorSubject<List<AttributeTerms>>();

  ValueStream<List<ProductAttribute>> get allAttribute => _attributeFetcher.stream;
  ValueStream<List<AttributeTerms>> get allTerms =>
      _termsFetcher.stream;

  fetchAllAttributes() async {
    final response = await apiProvider.get("products/attributes?per_page=100");
    attributes = productAttributeFromJson(response);
    _attributeFetcher.sink.add(attributes);
  }

  fetchAllTerms(String id) async {
    final response =
    await apiProvider.get("products/attributes/" + id + "/terms?per_page=100");
    terms = attributeTermsFromJson(response);
    _termsFetcher.sink.add(terms);
  }

  dispose() {
    _attributeFetcher.close();
    _termsFetcher.close();
  }
}

String getQueryString(Map params,
    {String prefix = '?', bool inRecursion = false}) {
  String query = '';

  params.forEach((key, value) {
    if (inRecursion) {
      key = '[$key]';
    }

    if (value is String || value is int || value is double || value is bool) {
      query += '$prefix$key=$value';
    } else if (value is List || value is Map) {
      if (value is List) value = value.asMap();
      value.forEach((k, v) {
        query +=
            getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
      });
    }
  });

  return query;
}
