import 'package:admin/src/functions.dart';
import 'package:admin/src/models/app_state_model.dart';
import 'package:admin/src/models/orders/orders_model.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;

class PrintOrder {

  DateFormat formatter1 = new DateFormat('dd-MM-yy');

  printItem(Order order, NumberFormat currencyFormatter, BuildContext context) async {

    AppStateModel model = AppStateModel();
    final doc = pw.Document();


    getName(LineItem element) {
      //print(element.name);
      List<pw.Widget> txt = [];

      txt.add(pw.Text(parseHtmlString(element.name) +
          ' x ' +
          element.quantity
              .toString()
              .replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "")));

      element.metaData?.forEach((element) {
        if (element.value is String && !element.key.startsWith('_'))
          txt.add(pw.Container(
              child: pw.Text(
                element.key + ': ' + element.value,
              )));
      });

      return txt;
    }

    fetchProduct(Order order, NumberFormat currencyFormatter,
        BuildContext context) {
      List<pw.Widget> listItems = [];

      order.lineItems.forEach((element) {
        listItems.add(pw.Column(
          children: [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: <pw.Widget>[
                pw.Container(
                  width: 200,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: getName(element),
                  ),
                ),
                pw.Spacer(),
                pw.Align(
                    alignment: pw.Alignment.topRight,
                    child: pw.Text(currencyFormatter.format((double.parse('${element.total}'))))),
              ],
            ),
            pw.SizedBox(height: 4)
          ],
        ));
      });

      listItems.add(pw.Column(
        children: [
          pw.SizedBox(height: 10),
          if(order.discountTotal != 0)
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: <pw.Widget>[
                pw.Text('Discount :'),
                pw.Spacer(),
                pw.Align(
                    alignment: pw.Alignment.topRight,
                    child: pw.Text(
                        currencyFormatter.format(double.parse(order.discountTotal!)))),
              ],
            ),
          if(double.parse(order.shippingTotal!) != 0)
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: <pw.Widget>[
                pw.Text('Shipping :'),
                pw.Spacer(),
                pw.Align(
                    alignment: pw.Alignment.topRight,
                    child: pw.Text(
                        currencyFormatter.format(order.shippingTotal))),
              ],
            ),

          for (var fee in order.feeLines)
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: <pw.Widget>[
                pw.Text(fee.name+' :'),
                pw.Spacer(),
                pw.Align(
                    alignment: pw.Alignment.topRight,
                    child: pw.Text(
                        currencyFormatter.format(fee.total))),
              ],
            ),

          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: <pw.Widget>[
              pw.Text('Total :', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Spacer(),
              pw.Align(
                  alignment: pw.Alignment.topRight,
                  child: pw.Text(
                      currencyFormatter.format(order.total), style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
            ],
          ),
        ],
      ));

      if(order.metaData.any((element) => element.key == 'dokan_delivery_time_date')) {
        if(order.metaData.any((element) => element.key == 'dokan_delivery_time_slot')) {
          listItems.add(pw.Padding(
            padding: const pw.EdgeInsets.only(top: 10.0),
            child: pw.Center(child: pw.Text('DELIVERY SLOT: ' + order.metaData.firstWhere((element) => element.key == 'dokan_delivery_time_slot').value)),
          ));
        }
        if(order.metaData.any((element) => element.key == 'dokan_delivery_time_date')) {
          listItems.add(pw.Padding(
            padding: const pw.EdgeInsets.only(top: 10.0),
            child: pw.Center(child: pw.Text('DELIVERY DATE: ' + order.metaData.firstWhere((element) => element.key == 'dokan_delivery_time_date').value)),
          ));
        }
      } else if(order.metaData.any((element) => element.key == 'jckwds_date')) {
        if(order.metaData.any((element) => element.key == 'jckwds_date')) {
          listItems.add(pw.Padding(
            padding: const pw.EdgeInsets.only(top: 10.0),
            child: pw.Center(child: pw.Text('DELIVERY DATE: ' + order.metaData.firstWhere((element) => element.key == 'jckwds_date').value)),
          ));
        }
        if(order.metaData.any((element) => element.key == 'jckwds_timeslot')) {
          listItems.add(pw.Padding(
            padding: const pw.EdgeInsets.only(top: 10.0),
            child: pw.Center(child: pw.Text('DELIVERY TIME: ' + order.metaData.firstWhere((element) => element.key == 'jckwds_timeslot').value)),
          ));
        }
      }
      if(order.metaData.any((element) => element.key == 'pickup_date')) {
        if(order.metaData.any((element) => element.key == 'pickup_date')) {
          listItems.add(pw.Padding(
            padding: const pw.EdgeInsets.only(top: 10.0),
            child: pw.Center(child: pw.Text('PICKUP DATE: ' + order.metaData.firstWhere((element) => element.key == 'pickup_date').value)),
          ));
        }
        if(order.metaData.any((element) => element.key == 'pickup_time')) {
          listItems.add(pw.Padding(
            padding: const pw.EdgeInsets.only(top: 10.0),
            child: pw.Center(child: pw.Text('PICKUP TIME: ' + order.metaData.firstWhere((element) => element.key == 'pickup_time').value)),
          ));
        }
      }

      if(order.metaData.any((element) => element.key == '_wcfmd_delvery_times')) {
        if(order.metaData.any((element) => element.key == '_wcfmd_delvery_times')) {
          for( var i = 0 ; i < order.metaData.firstWhere((element) => element.key == '_wcfmd_delvery_times').value.length; i++ ) {
            listItems.add(pw.Padding(
              padding: const pw.EdgeInsets.only(top: 10.0),
              child: pw.Center(child: pw.Text('DELIVERY TIME: ' + formatter1.format(DateTime.fromMillisecondsSinceEpoch(int.parse(order.metaData.firstWhere((element) => element.key == '_wcfmd_delvery_times').value[i]) * 1000)))),
            ));
          }
        }
      }

      if(order.customerNote != null && order.customerNote!.isNotEmpty) {
        listItems.add(pw.Padding(
          padding: const pw.EdgeInsets.only(top: 40.0),
          child: pw.Center(child: pw.Text(order.customerNote!)),
        ));
      }

      listItems.add(pw.Padding(
        padding: const pw.EdgeInsets.only(top: 40.0),
        child: pw.Center(child: pw.Text('Thank You')),
      ));

      return listItems;
    }

    doc.addPage(pw.Page(
        build: (pw.Context cntx) {
          return pw.ListView(
            padding: pw.EdgeInsets.all(16),
            children: [
              pw.SizedBox(height: 40),
              pw.Center(child: pw.Container(child: pw.Text(model.options.info!.name))),
              pw.Center(child: pw.Container(child: pw.Text(model.options.info!.description))),
              pw.Center(child: pw.Container(child: pw.Text(model.options.info!.email))),
              pw.Center(child: pw.Container(child: pw.Text(model.options.info!.phone))),
              pw.Center(child: pw.Container(child: pw.Text(model.options.info!.url))),
              pw.SizedBox(height: 40),
              pw.Row(children: [pw.Container(child: pw.Text("Name: " + order.billing.lastName))]),
              pw.Row(
                children: [
                  pw.Container(child: pw.Text("Order No: " + order.number.toString())),
                  pw.Spacer(),
                  pw.Text('Date: ${formatter1.format(order.dateCreated)}'),
                ],
              ),
              pw.SizedBox(height: 40),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: fetchProduct(order, currencyFormatter, context),
              )
            ],
          );// Center
        }));

    return doc;
  }


  printBluetooth(Order order, NumberFormat currencyFormatter) async {

    AppStateModel model = AppStateModel();

    getName(LineItem element) {
      //print(element.name);
      String txt = '';

      txt = parseHtmlString(element.name) +
          ' x ' +
          element.quantity
              .toString()
              .replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");

      return txt;
    }

    List<LineText> list = [];

    list.add(LineText(linefeed: 1));

    list.add(LineText(type: LineText.TYPE_TEXT, content: model.options.info!.name, weight: 2, align: LineText.ALIGN_CENTER,linefeed: 1));
    //list.add(LineText(type: LineText.TYPE_TEXT, content: model.options.info!.description, weight: 1, align: LineText.ALIGN_CENTER,linefeed: 1));
    //list.add(LineText(type: LineText.TYPE_TEXT, content: model.options.info!.email, weight: 1, align: LineText.ALIGN_CENTER,linefeed: 1));
    //list.add(LineText(type: LineText.TYPE_TEXT, content: model.options.info!.phone, weight: 1, align: LineText.ALIGN_CENTER,linefeed: 1));
    list.add(LineText(type: LineText.TYPE_TEXT, content: model.options.info!.url, weight: 1, align: LineText.ALIGN_CENTER,linefeed: 1));

    list.add(LineText(linefeed: 1));

    list.add(LineText(type: LineText.TYPE_TEXT, content: "Name: " + order.billing.lastName, weight: 0, align: LineText.ALIGN_LEFT,linefeed: 1));

    list.add(LineText(type: LineText.TYPE_TEXT, content: "Order No: " + order.number.toString(), weight: 0, align: LineText.ALIGN_LEFT,linefeed: 1));

    list.add(LineText(type: LineText.TYPE_TEXT, content: 'Date: ' + formatter1.format(order.dateCreated), weight: 0, align: LineText.ALIGN_LEFT,linefeed: 1));

    list.add(LineText(linefeed: 1));

    order.lineItems.forEach((element) {
      list.add(LineText(type: LineText.TYPE_TEXT, content: getName(element), weight: 0, align: LineText.ALIGN_LEFT,linefeed: 1));

      element.metaData?.forEach((element) {
        if (element.value is String && !element.key.startsWith('_')) {
          String displayKey = element.displayKey != null ? element.displayKey! : element.key;
          String displayValue = element.displayValue != null ? element.displayValue! : element.value;
          list.add(LineText(type: LineText.TYPE_TEXT, content: displayKey + ': ' + displayValue, weight: 0, align: LineText.ALIGN_LEFT,linefeed: 1));
        }
      });

      list.add(LineText(type: LineText.TYPE_TEXT, content: currencyFormatter.format((double.parse('${element.total}'))), align: LineText.ALIGN_RIGHT,linefeed: 1));
    });

    list.add(LineText(linefeed: 1));

    if(double.parse(order.shippingTotal!) != 0) {
      list.add(LineText(type: LineText.TYPE_TEXT, content: 'Shipping: ' + currencyFormatter.format(order.shippingTotal), weight: 1, align: LineText.ALIGN_RIGHT,linefeed: 1));
      //list.add(LineText(type: LineText.TYPE_TEXT, content: currencyFormatter.format(order.shippingTotal), weight: 0, align: LineText.ALIGN_RIGHT,linefeed: 1));
    }
    if(order.discountTotal != 0) {
      list.add(LineText(type: LineText.TYPE_TEXT, content: 'Discount: ' + currencyFormatter.format(double.parse(order.discountTotal!)), weight: 1, align: LineText.ALIGN_RIGHT,linefeed: 1));
      //list.add(LineText(type: LineText.TYPE_TEXT, content: currencyFormatter.format(double.parse(order.discountTotal!)), weight: 0, align: LineText.ALIGN_RIGHT,linefeed: 1));
    }

    list.add(LineText(type: LineText.TYPE_TEXT, content: 'Total: ' + currencyFormatter.format(order.total), weight: 1, align: LineText.ALIGN_RIGHT,linefeed: 1));
    //list.add(LineText(type: LineText.TYPE_TEXT, content: currencyFormatter.format(order.total), weight: 0, align: LineText.ALIGN_RIGHT,linefeed: 1));

    if(order.metaData.any((element) => element.key == 'dokan_delivery_time_date')) {
      if(order.metaData.any((element) => element.key == 'dokan_delivery_time_slot')) {
        list.add(LineText(type: LineText.TYPE_TEXT, content: 'DELIVERY SLOT: ' + order.metaData.firstWhere((element) => element.key == 'dokan_delivery_time_slot').value, weight: 0, align: LineText.ALIGN_CENTER,linefeed: 1));
      }
      if(order.metaData.any((element) => element.key == 'dokan_delivery_time_date')) {
        list.add(LineText(type: LineText.TYPE_TEXT, content: 'DELIVERY DATE: ' + order.metaData.firstWhere((element) => element.key == 'dokan_delivery_time_date').value, weight: 0, align: LineText.ALIGN_CENTER,linefeed: 1));
      }
    } else if(order.metaData.any((element) => element.key == 'jckwds_date')) {
      if(order.metaData.any((element) => element.key == 'jckwds_date')) {
        list.add(LineText(type: LineText.TYPE_TEXT, content: 'DELIVERY DATE: ' + order.metaData.firstWhere((element) => element.key == 'jckwds_date').value, weight: 0, align: LineText.ALIGN_CENTER,linefeed: 1));
      }
      if(order.metaData.any((element) => element.key == 'jckwds_timeslot')) {
        list.add(LineText(type: LineText.TYPE_TEXT, content: 'DELIVERY TIME: ' + order.metaData.firstWhere((element) => element.key == 'jckwds_timeslot').value, weight: 0, align: LineText.ALIGN_CENTER,linefeed: 1));
      }
    }
    if(order.metaData.any((element) => element.key == 'pickup_date')) {
      if(order.metaData.any((element) => element.key == 'pickup_date')) {
        list.add(LineText(type: LineText.TYPE_TEXT, content: 'PICKUP DATE: ' + order.metaData.firstWhere((element) => element.key == 'pickup_date').value, weight: 0, align: LineText.ALIGN_CENTER,linefeed: 1));
      }
      if(order.metaData.any((element) => element.key == 'pickup_time')) {
        list.add(LineText(type: LineText.TYPE_TEXT, content: 'PICKUP TIME: ' + order.metaData.firstWhere((element) => element.key == 'pickup_time').value, weight: 0, align: LineText.ALIGN_CENTER,linefeed: 1));
      }
    }

    if(order.metaData.any((element) => element.key == '_wcfmd_delvery_times')) {
      if(order.metaData.any((element) => element.key == '_wcfmd_delvery_times')) {
        for( var i = 0 ; i < order.metaData.firstWhere((element) => element.key == '_wcfmd_delvery_times').value.length; i++ ) {
          list.add(LineText(type: LineText.TYPE_TEXT, content: 'DELIVERY TIME: ' + formatter1.format(DateTime.fromMillisecondsSinceEpoch(int.parse(order.metaData.firstWhere((element) => element.key == '_wcfmd_delvery_times').value[i]) * 1000)), weight: 0, align: LineText.ALIGN_CENTER,linefeed: 1));
        }
      }
    }

    if(order.customerNote != null && order.customerNote!.isNotEmpty) {
      list.add(LineText(linefeed: 1));
      list.add(LineText(type: LineText.TYPE_TEXT, content: 'CUSTOMER NOTE: ' + order.customerNote!, weight: 0, align: LineText.ALIGN_CENTER,linefeed: 1));
    }

    //list.add(LineText(linefeed: 1));

    /*ByteData data = await rootBundle.load("assets/images/logo.png");
    List<int> imageBytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    String base64Image = base64Encode(imageBytes);
    list.add(LineText(type: LineText.TYPE_IMAGE, content: base64Image, align: LineText.ALIGN_CENTER, linefeed: 1));
*/
    list.add(LineText(linefeed: 1));

    list.add(LineText(type: LineText.TYPE_TEXT, content: 'THANK YOU', weight: 0, align: LineText.ALIGN_CENTER,linefeed: 1));

    list.add(LineText(linefeed: 1));
    list.add(LineText(linefeed: 1));

    return list;
  }

}