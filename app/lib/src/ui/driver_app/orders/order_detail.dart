import 'package:admin/src/blocs/orders/orders_bloc.dart';
import 'package:admin/src/models/customer/customer_model.dart';
import 'package:admin/src/models/orders/orders_model.dart';
import 'package:admin/src/ui/orders/custom_card.dart';
import 'package:admin/src/ui/orders/print_order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdf/pdf.dart';

class OrderDetail extends StatefulWidget {
  final Order order;
  final OrdersBloc ordersBloc;
  final bool? accepted;
  OrderDetail({required this.order, required this.ordersBloc, this.accepted});

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  DateFormat formatter1 = new DateFormat('dd-MM-yyyy  hh:mm a');
  final TextStyle _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString(),
        name: widget.order.currency);
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
        actions: <Widget>[
          /*IconButton(
              onPressed: (() => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return PrintPage(widget.order);
                    }))
                  }),
              icon: Icon(Icons.print)),*/
          IconButton(
              onPressed: () {
                _print(currencyFormatter, context);
              },
              icon: Icon(Icons.print))
        ],
      ),
      body: ListView(
        children: _buildListView(currencyFormatter),
      ),
    );
  }

  _buildListView(NumberFormat currencyFormatter) {

    List<Widget> list = [];

    final ThemeData theme = Theme.of(context);
    //final ListTileStyle? tileTheme = ListTileThemeData().style;

    list.add(CustomCard(
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: getColor(widget.order.status!, context),
                      foregroundColor: Colors.black,
                      elevation: 0,
                      /*shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2.0)),
                      ),*/
                    ),
                    onPressed: () {},
                    child: Text(
                      '${widget.order.number.toString()}  ${widget.order.status!.toUpperCase()}', style: TextStyle(color: Colors.white),),
                  ),
                  Text(widget.order.billing.firstName +
                      ' ' +
                      widget.order.billing.lastName),
                ],
              ),
              TextButton(
                  onPressed: () {},
                  child: Text(
                    currencyFormatter.format(widget.order.total),
                    style: Theme.of(context).textTheme.titleMedium,
                  )),
            ],
          ),
          subtitle: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.accepted != true)
                ElevatedButton(
                  onPressed: () {
                    widget.ordersBloc.driverAcceptOrder(widget.order);
                  },
                  child: Text('ACCEPT'),
                ),
              if (widget.order.billing.phone.isNotEmpty)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Theme.of(context).colorScheme.onSecondary,
                  ),
                  onPressed: () {
                    _launch('tel:' + widget.order.billing.phone);
                  },
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.phone),
                      SizedBox(width: 4),
                      Text('CALL'),
                    ],
                  ),
                ),
            ],
          ),
        )));

    list.add(CustomCard(
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          subtitle: Text(formatter1.format(widget.order.dateCreated)),
          title: Text('Date'),
        )));

    list.add(CustomCard(
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          subtitle: Text(widget.order.paymentMethodTitle),
          title: Text('Payment'),
        )));

    list.add(CustomCard(
        child: ListTile(
            contentPadding: EdgeInsets.all(16),
            subtitle: Wrap(
                runSpacing: 10,
                spacing: 10,
                children: widget.order.shippingLines.map((e) => Container(child: Text(widget.order.shippingLines[0].methodTitle))).toList()),
            title: Text('Shipping')
          //Text(AppLocalizations.of(context).translate("date")),
        )));

    list.add(CustomCard(
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  '''${widget.order.shipping.firstName} ${widget.order.shipping.lastName} ${widget.order.shipping.address1} ${widget.order.shipping.address2} ${widget.order.shipping.city} ${widget.order.shipping.country} ${widget.order.shipping.postcode}'''),
              IconButton(
                  onPressed: () async {
                    if (widget.order.customerData?.latitude != null &&
                        widget.order.customerData?.longitude != null) {
                      var url =
                          "https://www.google.com/maps?saddr=My+Location&daddr=" +
                              widget.order.customerData!.latitude! +
                              "," +
                              widget.order.customerData!.longitude!;
                      await launch(url);
                    } else {
                      var url =
                          "https://www.google.com/maps?saddr=My+Location&daddr=" + _getAddress(widget.order.shipping);
                      await launchUrl(Uri.parse(url));
                    }
                  },
                  icon: Icon(CupertinoIcons.map))
            ],
          ),
          title: Text('Delivery Address'),
        )));

    widget.order.vendors?.forEach((element) {
      list.add(CustomCard(
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('''${element.address}'''),
                if (element.latitude != null && element.longitude != null)
                  IconButton(
                      onPressed: () async {
                        if (element.latitude != null && element.longitude != null) {
                          var url =
                              "https://www.google.com/maps?saddr=My+Location&daddr=" +
                                  element.latitude! +
                                  "," +
                                  element.longitude!;
                          await launch(url);
                        } else {
                          var url =
                              "https://www.google.com/maps?saddr=My+Location&daddr=" +
                                  element.address!;
                          await launch(url);
                        }
                      },
                      icon: Icon(CupertinoIcons.map))
              ],
            ),
            title: Text(element.name!),
          )));
    });

    List<Widget> listItems = [];
    widget.order.lineItems.forEach((element) {
      listItems.add(Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(element.name +
                    ' x ' +
                    element.quantity
                        .toString()
                        .replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "")),
              ),
              SizedBox(width: 8),
              Text(
                  currencyFormatter.format((double.parse('${element.total}')))),
            ],
          ),
          SizedBox(height: 4)
        ],
      ));

      element.metaData?.forEach((element) {
        if (element.value is String && !element.key.contains('_'))
          listItems.add(Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(element.key + ': ' + element.value!,
                  style: _subtitleTextStyle(theme))));
      });
    });

    list.add(CustomCard(
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: listItems,
          ),
          title: Text('Products'),
        )));

    return list;
  }

  getColor(String status, BuildContext context) {
    switch (status) {
      case 'processing':
        return Colors.lightGreen;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'failed':
        return Colors.redAccent.withOpacity(0.8);
      case 'on-hold':
        return Colors.deepOrangeAccent;
      case 'pending':
        return Colors.orange;
      case 'refunded':
        return Colors.red;
      default:
        return Colors.green;
    }
  }

  TextStyle _subtitleTextStyle(ThemeData theme) {
    final TextStyle style = theme.textTheme.bodySmall!;
    final Color color = theme.textTheme.titleSmall!.color!;
    return style.copyWith(color: color);
  }

  _launch(url) async {
    launch(url);
  }

  Future<void> _print(NumberFormat currencyFormatter, BuildContext context) async {
    final doc = await PrintOrder().printItem(widget.order, currencyFormatter, context);
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save());
  }

  String _getAddress(Address shipping) {
    String address = '';
    if(shipping.address1.isNotEmpty) {
      address = shipping.address1 + ', ';
    } if(shipping.address2.isNotEmpty) {
      address = address + shipping.address2 + ', ';
    } if(shipping.city.isNotEmpty) {
      address = address + shipping.city + ', ';
    } if(shipping.state != null && shipping.state!.isNotEmpty) {
      address = address + shipping.state! + ', ';
    } if(shipping.postcode.isNotEmpty) {
      address = address + shipping.postcode + ', ';
    } if(shipping.country != null && shipping.country!.isNotEmpty) {
      address = address + shipping.country!;
    }
    return address;
  }
}