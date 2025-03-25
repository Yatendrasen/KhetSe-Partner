
import 'package:admin/src/models/order_note/order_notes_model.dart';
import '../../resources/repository.dart';
import 'package:rxdart/rxdart.dart';


class OrderNotesBloc {

  String search = '';
  String id = '';
  int page = 0;
  String perPage = '100';
  String filter = '';
  String context = 'view';
  String type = 'any';


  OrderNotesModel? ordernotes;
  bool hasMoreItem = true;

  final _repository = Repository();
  final _orderNotesFetcher = BehaviorSubject<OrderNotesModel>();

  ValueStream<OrderNotesModel> get allOrderNotes => _orderNotesFetcher.stream;

  fetchAllOrderNotes() async {
    page = 1;
    this.setFilter();
    // if(query != null){ filter = filter + query; }
    ordernotes = await _repository.fetchAllOrderNotes(filter, id);
    _orderNotesFetcher.sink.add(ordernotes!);
  }


  addOrderNotes(OrderNote ordernotes) async {
    OrderNote newOrderNotes = await _repository.addOrderNotes(ordernotes, id);
   // _orderNotesFetcher.sink.add(newOrderNotes);
  }


  deleteOrderNotes(OrderNote ordernotes, String id) async {
    OrderNote newOrderNotes = await _repository.deleteOrderNotes(ordernotes,id);
   // _orderNotesFetcher.sink.add(newOrderNotes);
  }


  loadMore() async {
    page = page + 1;
    var filter = '?page=' + page.toString();
    OrderNotesModel moreOrderNotes = await _repository.fetchAllOrderNotes(filter, id);
    ordernotes!.ordernotes.addAll(moreOrderNotes.ordernotes);
    _orderNotesFetcher.sink.add(ordernotes!);

  }

  dispose() {
    _orderNotesFetcher.close();
  }



  void setFilter() {
    filter = '?page=' + page.toString();
    filter = filter + '&per_page=' + perPage;
    if(!(context == 'view' && type == 'any')) filter = filter + '&context=$context&type=$type';
    if(search.isNotEmpty) filter = filter + '&search=$search';
  }

  void reset() {
    search = '';
    page = 0;
    filter = '?per_page=100';
    context = 'view';
    type = 'any';
  }

}

final bloc = OrderNotesBloc();