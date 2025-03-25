import 'dart:convert';

import 'package:admin/src/models/app_state_model.dart';
import 'package:admin/src/models/orders/orders_model.dart';
import 'package:admin/src/models/snackbar_activity.dart';
import 'package:admin/src/resources/api_provider.dart';

import '../../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:admin/src/models/customer/customer_model.dart';

class DeliveryBoyBloc {

  int page = 1;
  String perPage = '10';
  var filter = new Map<String, String>();
  final apiProvider = ApiProvider();
  final appStateModel = AppStateModel();
  final _customersFetcher = BehaviorSubject<List<Customer>>();
  List<Customer> customers = [];
  
  ValueStream<List<Customer>> get allCustomers => _customersFetcher.stream;
  
  fetchAllCustomers([String? query]) async {
    page =  1;
    filter['page'] = page.toString();
    final response = await apiProvider.get("customers" + getQueryString(filter));
    customers = customerFromJson(response);
    _customersFetcher.sink.add(customers);
  }

  loadMore() async {
    page = page + 1;
    filter['page'] = page.toString();
    final response = await apiProvider.get("customers" + getQueryString(filter));
    List<Customer> moreCustomers = customerFromJson(response);
    customers.addAll(moreCustomers);
    _customersFetcher.sink.add(customers);
  }

  dispose() {
    _customersFetcher.close();
  }

  Future<void> assignDeliveryBoy(Customer customer, Order order) async{
    final apiProvider = ApiProvider();
    appStateModel.messageFetcher.add(SnackBarActivity(message: 'Assigning order - ' + order.number, loading: true));
    final response = await apiProvider.postAjax('build-app-online-admin_assign_delivery_boy&user_id='+customer.id.toString()+'&order_id='+order.id.toString(),{});
    if (response.statusCode == 200) {
      //driverdata implementation
      order.metaData.add(LineItemMetaDatum(key: 'delivery_boy', value: customer.id));
      var result = json.decode(response.body);
      if(result['status']){
        List orderitemid =[];
        List productid=[] ;
        for(var i=0;i<order.lineItems.length;i++){
          orderitemid.add(order.lineItems[i].id.toString());
          productid.add(order.lineItems[i].id.toString());
        }
        var data = {'tracking_url':'','tracking_code': '', 'tracking_data': '', 'orderitemid': '', 'productid': '', 'action': 'wcfm_wcfmmarketplace_order_mark_shipped', 'orderid': order.id, 'wcfm_delivery_boy': customer.id};
        data['orderitemid'] = orderitemid.toString();
        data['productid'] = productid.toString();
        data['tracking_data'] = "wcfm_tracking_code=&wcfm_tracking_url=&wcfm_tracking_order_id=" + order.id.toString() + "&wcfm_tracking_product_id=" + data['productid'].toString() + "&wcfm_tracking_order_item_id=" + data['orderitemid'].toString() + "&wcfm_delivery_boy=" + customer.id.toString();
        apiProvider.posWPAjax(data);
      } else{
        appStateModel.messageFetcher.add(SnackBarActivity(message: result['message']));
      }
    }else{
      print('error');
    }
    appStateModel.messageFetcher.add(SnackBarActivity(message: 'Assigning order - ' + order.number, show: false));
  }
}