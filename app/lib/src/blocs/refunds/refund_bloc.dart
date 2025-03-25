import 'package:admin/src/models/refund/refund_model.dart';
import '../../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class RefundsBloc {

  String id = '';
  int page = 1;
  int dp = 2;
  String perPage = '10';
  String filter = '';
  String search = '';
  String order = 'desc';
  String orderBy = 'date';
  RefundsModel? refunds;
  bool refundedPayment = true;
  bool apiRefund = true;

  final _repository = Repository();
  final _refundsFetcher = BehaviorSubject<RefundsModel>();
  ValueStream<RefundsModel> get allRefunds => _refundsFetcher.stream;

  fetchRefunds() async {
    page = 1;
    this.setFilter();
    //if(query != null){ filter = filter + query; }
    refunds = await _repository.fetchRefunds(filter, id);
    _refundsFetcher.sink.add(refunds!);
  }


  addRefund(Refund refund) async {
    Refund newRefund = await _repository.addRefund(refund,id);
    //_refundsFetcher.sink.add(newRefund);
  }

  deleteRefund(Refund refund, String id) async {
    Refund newRefund = await _repository.deleteRefund(refund,id);
    //_customersFetcher.sink.add(newCusomer);
  }




  void reset() {
    search = '';
    dp = 2;
    page = 1;
    perPage = '10';
    order = 'desc';
    orderBy = 'date';
    filter = '';
  }


  void setFilter() {
    filter = '?page=' + page.toString();
    filter = filter + '&per_page=' + perPage;
    if(!(order == 'desc' && orderBy == 'date')) filter = filter + '&order=$order&orderby=$orderBy';
    if(search.isNotEmpty) filter = filter + '&search=$search';
  }

  dispose() {
    _refundsFetcher.close();
  }

}

final bloc = RefundsBloc();