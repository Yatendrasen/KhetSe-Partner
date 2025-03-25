// ignore_for_file: public_member_api_docs
import 'dart:ffi';
import 'dart:typed_data';
import 'package:admin/src/models/orders/orders_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintPage extends StatelessWidget {
  final Order order;

  const PrintPage(this.order, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order :${order.id.toString()}")),
      body: PdfPreview(
        build: (format) => _generatePdf(format, context),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, context) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: false);
    final font = await PdfGoogleFonts.nunitoExtraLight();

    final NumberFormat currencyFormatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString(),
        name: order.currency);
    DateFormat formatter1 = new DateFormat('dd-MM-yyyy  hh:mm a');

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.ListView(padding: pw.EdgeInsets.all(10.0), children: [
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
              pw.Column(children: [
                pw.Container(
                    padding: pw.EdgeInsets.all(20.0),
                    child: pw.Text(
                        '${order.billing.firstName + ' ' + order.billing.lastName}',
                        style: pw.Theme.of(context).header0))
              ]),
            ]),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(children: [
                    pw.Container(
                        padding: pw.EdgeInsets.all(20.0),
                        child: pw.Text(
                            '#${order.number.toString()}  ${order.status!.toUpperCase()}',
                            style: pw.TextStyle(font: font, fontSize: 20.0)))
                  ]),
                  pw.Column(children: [
                    pw.Container(
                        padding: pw.EdgeInsets.all(20.0),
                        child: pw.Text(
                          currencyFormatter.format(order.total),
                          style: pw.Theme.of(context).header1,
                        ))
                  ]),
                ]),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(children: [
                    pw.Container(
                        padding: pw.EdgeInsets.all(20.0),
                        child: pw.Text(
                            'DATE: ${formatter1.format(order.dateCreated!)}',
                            style: pw.TextStyle(font: font, fontSize: 20.0))),
                  ]),
                ]),
            pw.Row(children: [
              pw.Column(children: [
                pw.Container(
                    padding: pw.EdgeInsets.all(20.0),
                    child: pw.Text('Payment: ${order.paymentMethodTitle!}',
                        style: pw.TextStyle(font: font, fontSize: 20.0))),
              ]),
            ]),
            pw.Row(children: [
              pw.Column(children: [
                pw.Container(
                    padding: pw.EdgeInsets.only(
                        left: 20.0, top: 20.0, right: 0.0, bottom: 5.0),
                    child: pw.Text('Delivery Address:',
                        style: pw.Theme.of(context).header1)),
              ]),
            ]),
            pw.Row(children: [
              pw.Flexible(
                child: pw.Column(children: [
                  pw.Container(
                      width: 350.0,
                      padding: pw.EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 0.0, bottom: 2.0),
                      child: pw.Text(
                          '''${order.shipping.firstName} ${order.shipping.lastName} ${order.shipping.address1} ${order.shipping.address2} ${order.shipping.city} ${order.shipping.country} ${order.shipping.postcode}''',
                          style: pw.TextStyle(font: font))),
                ]),
              )
            ]),
            pw.Row(children: [
              pw.Column(children: [
                pw.Container(
                    padding: pw.EdgeInsets.only(
                        left: 20.0, top: 20.0, right: 0.0, bottom: 5.0),
                    child: pw.Text('Store Address:',
                        style: pw.Theme.of(context).header1)),
              ]),
            ]),
            pw.Row(children: [
              pw.Column(children: [
                pw.Container(
                    padding: pw.EdgeInsets.only(
                        left: 22.0, top: 0.0, right: 0.0, bottom: 5.0),
                    child: fetchVendor(order, font)),
              ]),
            ]),
            pw.Row(children: [
              pw.Column(children: [
                pw.Container(
                    padding: pw.EdgeInsets.only(
                        left: 20.0, top: 20.0, right: 0.0, bottom: 5.0),
                    child: pw.Text('Products:',
                        style: pw.Theme.of(context).header1)),
              ]),
            ]),
            fetchProduct(order, font, currencyFormatter, context)
          ]);
        },
      ),
    );

    return pdf.save();
  }

  fetchProduct(Order order, pw.Font font, NumberFormat currencyFormatter,
      pw.Context context) {
    List<pw.Widget> listItems = [];

    order.lineItems!.forEach((element) {
      listItems.add(pw.Column(
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: <pw.Widget>[
              pw.Expanded(
                child: pw.Text(element.name! +
                    ' x ' +
                    element.quantity
                        .toString()
                        .replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "")),
              ),
              pw.SizedBox(width: 8),
              pw.Text(
                  currencyFormatter.format((double.parse('${element.total}')))),
            ],
          ),
          pw.SizedBox(height: 4)
        ],
      ));

      element.metaData?.forEach((element) {
        if (element.value is String && !element.key!.contains('_'))
          listItems.add(pw.Container(
              padding: pw.EdgeInsets.only(left: 16),
              child: pw.Text(
                element.key! + ': ' + element.value!,
              )));
      });
    });

    return pw.ListView(
        padding: pw.EdgeInsets.only(left: 20.0), children: listItems);
  }
}

fetchVendor(Order order, font) {
  var name;
  var address;

  order.vendors?.forEach((element) {
    name = element.name;
    address = element.address;
  });
  return pw.Wrap(children: [
    pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(children: [pw.Container(child: pw.Text(name))]),
        pw.Row(children: [pw.Text(address, style: pw.TextStyle(font: font))]),
      ],
    )
  ]);
}
