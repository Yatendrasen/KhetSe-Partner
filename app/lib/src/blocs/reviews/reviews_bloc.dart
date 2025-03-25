import 'package:admin/src/models/product/reviews.dart';
import 'package:admin/src/resources/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class ReviewsBloc {

  Map<String, dynamic> filter = {'page': 1};
  bool hasMoreItems = true;
  List<Reviews> reviews = [];
  final _dataFetcher = BehaviorSubject<List<Reviews>>();
  final apiProvider = ApiProvider();

  ValueStream<List<Reviews>> get allData => _dataFetcher.stream;

  Future<void> fetchData() async {
    dynamic response = await apiProvider.get('products/reviews');
    reviews = reviewsFromJson(response);
    _dataFetcher.sink.add(reviews);
  }

  dispose() {
    _dataFetcher.close();
  }

  Future<void> loadMore() async {
    filter['page'] = filter['page'] + 1;
    dynamic response = await apiProvider.get('products/reviews/?page=' + filter['page'].toString());
    List<Reviews> newReviews = reviewsFromJson(response);
    reviews.addAll(newReviews);
    _dataFetcher.sink.add(reviews);
  }
}
