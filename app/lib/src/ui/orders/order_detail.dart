import 'package:admin/src/blocs/orders/orders_bloc.dart';
import 'package:admin/src/functions.dart';
import 'package:admin/src/models/app_state_model.dart';
import 'package:admin/src/models/customer/customer_model.dart';
import 'package:admin/src/resources/api_provider.dart';
import 'package:admin/src/ui/custom_card.dart';
import 'package:admin/src/ui/ordernotes/ordernotes_list.dart';
import 'package:admin/src/ui/orders/bluetooth_printer.dart';
import 'package:admin/src/ui/orders/delivery_boys.dart';
import 'package:admin/src/ui/orders/print_order.dart';
import 'package:admin/src/ui/refunds/refund_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:admin/src/models/orders/orders_model.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:admin/src/blocs/products/vendor_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'edit_order.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetail extends StatefulWidget {
  final Order order;
  final OrdersBloc ordersBloc;

  const OrderDetail({Key? key, required this.order, required this.ordersBloc}) : super(key: key);

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  DateFormat formatter1 = new DateFormat('dd-MM-yyyy  hh:mm a');
  final TextStyle _biggerFont = const TextStyle(fontSize: 18);
  bool _sendingEmail = false;
  bool isPrinterConnected = false;

  @override
  void initState() {
    super.initState();
    initBluetooth();
  }

  Future<void> initBluetooth() async {
    isPrinterConnected = await AppStateModel().bluetoothPrint.isConnected ?? false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: Text(AppLocalizations.of(context).translate("order_detail")),
        actions: <Widget>[
          /*IconButton(
            icon: Icon(Icons.delete, semanticLabel: 'Delete',),
            onPressed: () => widget.ordersBloc.deleteItem(widget.order),
          ),*/
          if(isPrinterConnected)
          IconButton(
              onPressed: () {
                _printBluetooth(context);
              },
              icon: Icon(CupertinoIcons.bluetooth)),
          IconButton(
              onPressed: () {
                _print(context);
              },
              icon: Icon(CupertinoIcons.printer)),
          IconButton(
            icon: Icon(
              CupertinoIcons.doc_plaintext,
              semanticLabel: 'Note',
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        OrderNotesList(id: widget.order.id.toString())),
              );
            },
          ),
          IconButton(
            icon: Icon(
              CupertinoIcons.money_pound_circle,
              semanticLabel: 'Refund',
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        RefundList(id: widget.order.id.toString())),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: _buildListView(),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          //TODO Create Edit Order Page and Navigate
        },
        tooltip: 'Edit',
        child: Icon(Icons.edit),
      ),*/
    );
  }

  _buildListView() {
    final NumberFormat currencyFormatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString(),
        name: widget.order.currency);
    List<Widget> list = [];

    list.add(CustomCard(
      child: ListTile(
          contentPadding: EdgeInsets.all(16),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.order.number.toString(), style: Theme.of(context).textTheme.headlineSmall),
              Text(currencyFormatter.format(widget.order.total), style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  TextButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: getColor(widget.order.status!, context),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2.0)),
                      ),
                    ),
                    onPressed: () => _showMyDialog(widget.order, (value) {
                      setState(() {
                        widget.order.status = value;
                      });
                      widget.ordersBloc.updateItem(widget.order);
                    }),
                    child: Text(widget.order.status!.toUpperCase()),
                  ),
                  Spacer(),
                 /* Container(
                    child: Builder(
                      builder: (context) {

                        bool driver = false;

                        driver = widget.order.metaData.any((element) => element.key == 'delivery_boy');

                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            backgroundColor: driver ? Theme.of(context).colorScheme.secondary : Theme.of(context).focusColor,
                            child: InkWell(
                                onTap: () {},
                                child: IconButton(
                                    onPressed: () async {
                                      await Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                            return DeliveryBoys(order: widget.order);
                                          }));
                                      setState(() {

                                      });
                                    },
                                    icon: Icon(
                                        Icons.directions_bike,
                                        color: driver ? Theme.of(context).colorScheme.onSecondary : null
                                    ))),
                          ),
                        );
                      }
                    ),
                  ),*/
                ],
              )
            ],
          )),
    ));

    list.add(CustomCard(
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          subtitle:Text(formatter1.format(widget.order.dateCreated)),
          title: Text(AppLocalizations.of(context).translate("date")),
        )));

    if(widget.order.transactionId != null)
    list.add(CustomCard(
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          subtitle:Text(widget.order.transactionId!),
          title: Text(AppLocalizations.of(context).translate("transaction_id")),
        )));

    if(widget.order.metaData.any((element) => element.key == 'dokan_delivery_time_date')) {
      list.add(CustomCard(
          child: ListTile(
              contentPadding: EdgeInsets.all(16),
              subtitle: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                children: [
                  if(widget.order.metaData.any((element) => element.key == 'dokan_delivery_time_date'))
                    Text(widget.order.metaData.firstWhere((element) => element.key == 'dokan_delivery_time_date').value),
                  if(widget.order.metaData.any((element) => element.key == 'dokan_delivery_time_slot'))
                    Text(widget.order.metaData.firstWhere((element) => element.key == 'dokan_delivery_time_slot').value),
                ],
              ),
              title: Text(AppLocalizations.of(context).translate("delivery_date"))
            //Text(AppLocalizations.of(context).translate("date")),
          )));
      } else if(widget.order.metaData.any((element) => element.key == 'jckwds_date')) {
        list.add(CustomCard(
            child: ListTile(
                contentPadding: EdgeInsets.all(16),
                subtitle: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  children: [
                    if(widget.order.metaData.any((element) => element.key == 'jckwds_date'))
                      Text(widget.order.metaData.firstWhere((element) => element.key == 'jckwds_date').value),
                    if(widget.order.metaData.any((element) => element.key == 'jckwds_timeslot'))
                      Text(widget.order.metaData.firstWhere((element) => element.key == 'jckwds_timeslot').value),
                  ],
                ),
                title:  Text(AppLocalizations.of(context).translate("delivery_date"))
              //Text(AppLocalizations.of(context).translate("date")),
            )));
     }

    list.add(CustomCard(
        child: ListTile(
            contentPadding: EdgeInsets.all(16),
            subtitle: Wrap(
                runSpacing: 10,
                spacing: 10,
                children: widget.order.shippingLines.map((e) => Container(child: Text(widget.order.shippingLines[0].methodTitle))).toList()),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context).translate("shipping")),
                TextButton(
                  onPressed: _sendingEmail ? null : () async {
                    setState(() {
                      _sendingEmail = true;
                    });
                    await widget.ordersBloc.orderAction('send_order_details', widget.order.id);
                    setState(() {
                      _sendingEmail = false;
                    });
                  },
                  child: _sendingEmail ? Text(AppLocalizations.of(context).translate("sending_email")) : Text(AppLocalizations.of(context).translate("email_invoice_to_customer")),
                ),
              ],
            ),
          /*trailing: TextButton(
            onPressed: () {
              widget.ordersBloc.sendInvoice();
            },
            child: Text('Email order invoice'),
          ),*/
          //Text(AppLocalizations.of(context).translate("date")),
        )));

    list.add(CustomCard(
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          subtitle:Text(widget.order.paymentMethodTitle),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context).translate("payment")),
              TextButton(
                onPressed: () async {
                  await Share.share(ApiProvider().wc_api.url + '/check-out/order-pay/'+ widget.order.id.toString() +'/?pay_for_order=true&key=' + widget.order.orderKey,
                      subject: 'Payment Link');
                },
                child: Text(AppLocalizations.of(context).translate("share_payment_link")),
              ),
            ],
          ),
        )));

    list.add(CustomCard(
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  '''${widget.order.billing.firstName} ${widget.order.billing.lastName} ${widget.order.billing.address1} ${widget.order.billing.address2} ${widget.order.billing.city} ${widget.order.billing.country} ${widget.order.billing.postcode}'''),
              Row(
                children: [
                  TextButton.icon(onPressed: () {
                    final Uri emailLaunchUri = Uri(
                      scheme: 'tel',
                      path: widget.order.billing.phone,
                    );
                    launchUrl(emailLaunchUri);
                  }, icon: Icon(CupertinoIcons.phone_fill), label: Text(AppLocalizations.of(context).translate("call"))),
                  SizedBox(width: 8),
                  TextButton.icon(onPressed: () {
                    final Uri emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: widget.order.billing.email,
                    );
                    launchUrl(emailLaunchUri);
                  }, icon: Icon(CupertinoIcons.mail_solid), label: Text(AppLocalizations.of(context).translate("email")),),
                  SizedBox(width: 8),
                  TextButton.icon(onPressed: () {
                    final Uri launchUri = Uri(
                      scheme: 'sms',
                      path: widget.order.billing.phone,
                    );
                    launchUrl(launchUri);
                  }, icon: Icon(CupertinoIcons.chat_bubble_fill), label: Text(AppLocalizations.of(context).translate("sms"))),
                ],
              )
            ],
          ),
          title: Text(AppLocalizations.of(context).translate("billing") + ' ' + AppLocalizations.of(context).translate("address")),
        )));

    list.add(CustomCard(
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          subtitle: Text(
              '''${widget.order.shipping.firstName} ${widget.order.shipping.lastName} ${widget.order.shipping.address1} ${widget.order.shipping.address2} ${widget.order.shipping.city} ${widget.order.shipping.country} ${widget.order.shipping.postcode}'''),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context).translate("shipping") + ' ' + AppLocalizations.of(context).translate("address")),
              TextButton.icon(
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
                  icon: Icon(CupertinoIcons.map),
                label: Text(AppLocalizations.of(context).translate("google_map")),
              )
            ],
          ),
        )));

    List<Widget> listItems = [];
    widget.order.lineItems.forEach((element) {


      listItems.add(
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  if(element.image != null && element.image!.src.isNotEmpty)
                  Container(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 4),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0, 8, 0),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: CachedNetworkImage(
                            imageUrl: element.image!.src.isNotEmpty ? element.image!.src
                                : '',
                            placeholder: (context, url) => Container(
                              width: 40,
                              height: 40,
                              color: Theme.of(context).canvasColor,
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 40,
                              height: 40,
                              color: Theme.of(context).canvasColor,
                            ),
                          ),
                        ),
                      )
                  ),
                  Expanded(
                    child: Text(element.name +
                        ' x ' +
                        element.quantity.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "")),
                  ),
                  SizedBox(width: 8),
                  Text(currencyFormatter.format(
                      (double.parse('${element.total}')))),
                ],
              ),
              //SizedBox(height: 4)
            ],
          )
      );

      element.metaData!.forEach((metas) {
        if(metas.value is String && !metas.key.startsWith('_') && metas.displayKey != null && metas.displayValue != null)
          listItems.add(Container(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Text(metas.displayKey! + ': ' + parseHtmlString(metas.displayValue!), style: Theme.of(context).textTheme.titleSmall))
          );
      });

      listItems.add(SizedBox(height: 16));

    });

    list.add(CustomCard(
        child: ListTile(
            contentPadding: EdgeInsets.all(16),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: listItems,
            ),
            title: Text(AppLocalizations.of(context).translate("products"))
        )));

    list.add(CustomCard(
        child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context).translate("shipping"), style: Theme.of(context).textTheme.bodySmall,),
                    Text(currencyFormatter.format(
                        (double.parse('${widget.order.shippingTotal}'))), style: Theme.of(context).textTheme.bodySmall,),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context).translate("discount"), style: Theme.of(context).textTheme.bodySmall,),
                    Text(currencyFormatter.format(
                        (double.parse('${widget.order.discountTotal}'))), style: Theme.of(context).textTheme.bodySmall,),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context).translate("tax"), style: Theme.of(context).textTheme.bodySmall,),
                    Text(currencyFormatter.format(
                        (double.parse('${widget.order.totalTax}'))), style: Theme.of(context).textTheme.bodySmall,),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context).translate("total"), style: Theme.of(context).textTheme.headlineSmall,),
                    Text(currencyFormatter.format(
                        (double.parse('${widget.order.total}'))), style: Theme.of(context).textTheme.headlineSmall,),
                  ],
                ),
              ],
            )
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

  Future<void> _showMyDialog(Order order, Function onChange) async {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return SafeArea(
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  CustomCard(
                    child: RadioListTile<String>(
                        value: AppLocalizations.of(context)
                  .translate("pending"),
                        groupValue: order.status,
                        title: Text(AppLocalizations.of(context)
                            .translate("pending"),),
                        onChanged: (value) {
                          if(value != null) {
                            setState(() {
                              order.status = value;
                            });
                          }
                          Navigator.of(context).pop();
                          onChange(order.status);
                        }),
                  ),
                  CustomCard(
                    child: RadioListTile<String>(
                        value: AppLocalizations.of(context)
                            .translate("processing"),
                        groupValue: order.status,
                        title: Text(AppLocalizations.of(context)
                            .translate("processing"),),
                        onChanged: (value) {
                          if(value != null) {
                            setState(() {
                              order.status = value;
                            });
                          }
                          Navigator.of(context).pop();
                          onChange(order.status);
                        }),
                  ),
                  CustomCard(
                    child: RadioListTile<String>(
                        value: 'on-hold',
                        groupValue: order.status,
                        title: Text(AppLocalizations.of(context)
                            .translate("on_hold"),),
                        onChanged: (value) {
                          if(value != null) {
                            setState(() {
                              order.status = value;
                            });
                          }
                          Navigator.of(context).pop();
                          onChange(order.status);
                        }),
                  ),
                  CustomCard(
                    child: RadioListTile<String>(
                        value: 'completed',
                        groupValue: order.status,
                        title: Text(AppLocalizations.of(context)
                            .translate("completed"),),
                        onChanged: (value) {
                          if(value != null) {
                            setState(() {
                              order.status = value;
                            });
                          }
                          Navigator.of(context).pop();
                          onChange(order.status);
                        }),
                  ),
                  CustomCard(
                    child: RadioListTile<String>(
                        value: 'cancelled',
                        groupValue: order.status,
                        title: Text(AppLocalizations.of(context)
                            .translate("cancelled"),),
                        onChanged: (value) {
                          if(value != null) {
                            setState(() {
                              order.status = value;
                            });
                          }
                          Navigator.of(context).pop();
                          onChange(order.status);
                        }),
                  ),
                  CustomCard(
                    child: RadioListTile<String>(
                        value: 'refunded',
                        groupValue: order.status,
                        title: Text(AppLocalizations.of(context)
                            .translate("refunded"),),
                        onChanged: (value) {
                          if(value != null) {
                            setState(() {
                              order.status = value;
                            });
                          }
                          Navigator.of(context).pop();
                          onChange(order.status);
                        }),
                  ),
                  CustomCard(
                    child: RadioListTile<String>(
                        value: 'failed',
                        groupValue: order.status,
                        title: Text(AppLocalizations.of(context)
                            .translate("failed"),),
                        onChanged: (value) {
                          if(value != null) {
                            setState(() {
                              order.status = value;
                            });
                          }
                          Navigator.of(context).pop();
                          onChange(order.status);
                        }),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
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

  Future<void> _print(BuildContext context) async {
    final NumberFormat currencyFormatter = NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toString(), name: widget.order.currency);
    final doc = await PrintOrder().printItem(widget.order, currencyFormatter, context);
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save());
  }

  Future<void> _printBluetooth(BuildContext context) async {
    Map<String, dynamic> config = Map();

    final NumberFormat currencyFormatter = NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toString(), name: widget.order.currency);
    final list = await PrintOrder().printBluetooth(widget.order, currencyFormatter);

    AppStateModel().bluetoothPrint.printReceipt(config, list);
  }

}
