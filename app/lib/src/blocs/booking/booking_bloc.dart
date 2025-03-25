import 'package:admin/src/models/account/booking_model.dart';
import 'package:admin/src/resources/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class BookingsBloc {
  final apiProvider = ApiProvider();
  List<BookingModel> items = [];
  bool moreItems = true;
  int page = 1;
  var filter = new Map<String, dynamic>();

  final _isLoginLoadingFetcher = BehaviorSubject<String>();
  var _hasMoreOrdersFetcher = BehaviorSubject<bool>();

  ValueStream<bool> get hasMoreOrderItems => _hasMoreOrdersFetcher.stream;

  final _ordersFetcher = BehaviorSubject<List<BookingModel>>();
  ValueStream<List<BookingModel>> get allOrders => _ordersFetcher.stream;

  fetchItems() async {
    print(filter);
    final response = await apiProvider.postAjax('build-app-online-admin_bookings', filter);
    if(response.statusCode == 200) {
      items = bookingModelFromJson(response.body);
    } else {
      items = [];
    }
    _ordersFetcher.sink.add(items);
  }

  void loadMoreOrders() async {
    page = page + 1;
    filter['page'] = page.toString();
    final response = await apiProvider.postAjax('build-app-online-admin_bookings', filter);
    List<BookingModel> moreOrders = bookingModelFromJson(response.body);
    items.addAll(moreOrders);
    _ordersFetcher.sink.add(items);
    if (moreOrders.length == 0) {
      moreItems = false;
      _hasMoreOrdersFetcher.sink.add(false);
    }
  }

  dispose() {
    _isLoginLoadingFetcher.close();
    _ordersFetcher.close();
    _hasMoreOrdersFetcher.close();
  }

  Future<void> updateItem(BookingModel data) async {
    String status = bookingStatus.singleWhere((element) => element.value == data.status).key;
    final response = await apiProvider.postAjax("build-app-online-update_booking&booking_id=" + data.id.toString() + "&status=" + status, {});
    print(response.body);
  }
}

List<BookingStatus> bookingStatus = [
  BookingStatus(key: 'unpaid', value: 'Unpaid'),
  BookingStatus(key: 'paid', value: 'Paid'),
  BookingStatus(key: 'pending-confirmation', value: 'Pending'),
  BookingStatus(key: 'confirmed', value: 'Confirmed'),
  BookingStatus(key: 'cancelled', value: 'Cancelled'),
  BookingStatus(key: 'complete', value: 'Complete'),
  BookingStatus(key: 'in-cart', value: 'In Cart')
];

class BookingStatus {
  BookingStatus({
    required this.key,
    required this.value,
  });

  String key;
  String value;
}

/*
'unpaid'               => __( 'Unpaid', 'woocommerce-bookings' ),
'pending-confirmation' => __( 'Pending Confirmation', 'woocommerce-bookings' ),
'confirmed'            => __( 'Confirmed', 'woocommerce-bookings' ),
'paid'                 => __( 'Paid', 'woocommerce-bookings' ),
'cancelled'            => __( 'Cancelled', 'woocommerce-bookings' ),
'complete'             => __( 'Complete', 'woocommerce-bookings' ),
'in-cart'              => __( 'In Cart', 'woocommerce-bookings' ),*/
