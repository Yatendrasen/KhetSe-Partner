import 'package:flutter/material.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'edit_payment.dart';
import 'package:admin/src/models/payment/payment_gateways_model.dart';
import 'package:html/parser.dart';

class PaymentGatewayDetail extends StatefulWidget {
  final PaymentGateway paymentGateway;

  const PaymentGatewayDetail({Key? key, required this.paymentGateway});

  @override
  _PaymentGatewayDetailState createState() => _PaymentGatewayDetailState(
      paymentGateway
  );
}

class _PaymentGatewayDetailState extends State<PaymentGatewayDetail> {
  final PaymentGateway paymentGateway;


  _PaymentGatewayDetailState(this.paymentGateway);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).translate("payment_detail")), actions: <Widget>[
       /* IconButton(
          icon: Icon(
            Icons.edit,
            semanticLabel: 'edit',
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditPaymentGateway(paymentGateway: paymentGateway)),
            );
          },
        ),*/
       /* IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              bloc.deleteCustomer(customer);
            }),*/

      ]),
      body:Stack(
        children: <Widget>[
          ListView(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        children: ListTile.divideTiles(
          //          <-- ListTile.divideTiles
          context: context,
          tiles: [
            ListTile(
              title: Text(AppLocalizations.of(context).translate("id")),
              subtitle: Text(paymentGateway.id.toString()),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context).translate("title")),
              subtitle: Text(paymentGateway.title),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context).translate("description")),
              subtitle: paymentGateway.description != null ? Text(_parseHtmlString(paymentGateway.description!)) : null,
            ),
            ListTile(
              title: Text(AppLocalizations.of(context).translate("order")),
              subtitle: Text(paymentGateway.order.toString()),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context).translate("enabled")),
              trailing:Checkbox(value:paymentGateway.enabled, onChanged: null),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context).translate("method_title")),
              subtitle:Text(paymentGateway.methodTitle),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context).translate("method_description")),
              subtitle:Text(paymentGateway.methodDescription),
            ),
          ],
        ).toList(),
      ),
   ] ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    EditPaymentGateway(paymentGateway: paymentGateway)),
          );
        },
        child: Icon(Icons.edit),
      ),

    );
  }
}

String _parseHtmlString(String htmlString) {
  var document = parse(htmlString);

  String parsedString = parse(document.body!.text).documentElement!.text;

  return parsedString;
}

