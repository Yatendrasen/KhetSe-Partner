import 'package:admin/src/blocs/payments/payment_bloc.dart';
import 'package:admin/src/functions.dart';
import 'package:flutter/material.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:admin/src/ui/payment_gateways/payment_detail.dart';
import 'package:admin/src/models/payment/payment_gateways_model.dart';


class PaymentGatewayList extends StatefulWidget {
  final PaymentGatewaysBloc paymentGatewaysBloc = PaymentGatewaysBloc();
  @override
  _PaymentGatewayListState createState() => _PaymentGatewayListState();
}

class _PaymentGatewayListState extends State<PaymentGatewayList> {

  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    widget.paymentGatewaysBloc.fetchItems();
    _scrollController.addListener((){
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        widget.paymentGatewaysBloc.loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("payments")),
      ),
      body: StreamBuilder(
          stream: widget.paymentGatewaysBloc.results,
          builder: (context, AsyncSnapshot<List<PaymentGateway>> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return buildList(snapshot);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  Widget buildListTile(BuildContext context, PaymentGateway item) {
    return MergeSemantics(
      child: ListTile(
        onTap: () => openDetail(item),
          isThreeLine: item.description != null,
           title: Text(parseHtmlString(item.title)),
          subtitle: item.description == null ? null : Text(parseHtmlString(item.description!)),
      ),
    );
  }

  Widget buildList(AsyncSnapshot<List<PaymentGateway>> snapshot) {

    Iterable<Widget> listTiles = snapshot.data!.map<Widget>((PaymentGateway item) => buildListTile(context, item));
    listTiles = ListTile.divideTiles(context: context, tiles: listTiles);

    return Scrollbar(
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        children: listTiles.toList(),
      ),
    );
  }

  openDetail(PaymentGateway PaymentGateway) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>PaymentGatewayDetail(paymentGateway :PaymentGateway )),
    );
  }
}
