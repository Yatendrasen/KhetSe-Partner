import 'package:admin/src/models/app_state_model.dart';
import 'package:admin/src/models/orders/orders_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:scoped_model/scoped_model.dart';

class PrintOrder {

  DateFormat formatter1 = new DateFormat('dd-MM-yy');

  print(Order order, NumberFormat currencyFormatter, BuildContext context) async {

    AppStateModel model = AppStateModel();
    final doc = pw.Document();


    _getName(LineItem element) {

      List<pw.Widget> txt = [];

      txt.add(pw.Text(element.name +
          ' x ' +
          element.quantity
              .toString()
              .replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "")));

      element.metaData?.forEach((element) {
        if (element.value is String && !element.key.contains('_'))
          txt.add(pw.Container(
              child: pw.Text(
                element.key + ': ' + element.value!,
              )));
      });

      return txt;
    }

    fetchProduct(Order order, NumberFormat currencyFormatter,
        BuildContext context) {
      List<pw.Widget> listItems = [];

      order.lineItems!.forEach((element) {
        listItems.add(pw.Column(
          children: [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: <pw.Widget>[
                pw.Container(
                  width: 200,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: _getName(element),
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
          //if(double.parse(order.discountTotal!) != 0)
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
          //if(double.parse(order.shippingTotal!) != 0)
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: <pw.Widget>[
              pw.Text('Shipping :'),
              pw.Spacer(),
              pw.Align(
                  alignment: pw.Alignment.topRight,
                  child: pw.Text(
                      currencyFormatter.format(double.parse(order.shippingTotal!)))),
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

    //await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save());

    //await Printing.sharePdf(bytes: await doc.save(), filename: 'my-document.pdf');

  }
}


