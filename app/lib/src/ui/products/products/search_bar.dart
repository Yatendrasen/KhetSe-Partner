import 'package:admin/src/blocs/orders/orders_bloc.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:admin/src/ui/products/products/barcode_product.dart';
import 'package:admin/src/ui/products/products/search_products.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class SearchBarProduct extends StatefulWidget {
  final OrdersBloc ordersBloc;

  const SearchBarProduct({Key? key, required this.ordersBloc}) : super(key: key);
  @override
  _SearchBarProductState createState() => _SearchBarProductState();
}

class _SearchBarProductState extends State<SearchBarProduct> {

  String barcode = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        enableFeedback: false,
        splashColor: Colors.transparent,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SearchProducts(ordersBloc: widget.ordersBloc);
          }));
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(4.0),
              enableFeedback: false,
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SearchProducts(ordersBloc: widget.ordersBloc);
                }));
              },
              child: CupertinoTextField(
                keyboardType: TextInputType.text,
                placeholder: AppLocalizations.of(context)
                    .translate("search_products"),
                placeholderStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).textTheme.titleSmall!.color
                ),
                enabled: false,
                prefix: Padding(
                  padding: const EdgeInsets.fromLTRB(9.0, 6.0, 9.0, 6.0),
                  child: Icon(
                    Icons.search,
                    color: Theme.of(context).textTheme.titleSmall!.color!.withOpacity(0.6),
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
            Positioned.directional(
              textDirection: Directionality.of(context),
              end: 0,
              child: IgnorePointer(
                ignoring: false,
                child: IconButton(
                    onPressed: () {
                      _barCodeScan();
                    },icon: Icon(CupertinoIcons.barcode_viewfinder, color: Theme.of(context).textTheme.titleSmall!.color!.withOpacity(0.6))
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  _barCodeScan() async {
    /*String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.BARCODE);
    if(barcodeScanRes != '-1'){
      showDialog(builder: (context) => FindBarCodeProduct(result: barcodeScanRes, context: context), context: context);
    }*/
    try {
      ScanResult result = await BarcodeScanner.scan();
      if(result.type == ResultType.Barcode) {
        showDialog(builder: (context) => FindBarCodeProduct(result: result.rawContent, context: context), context: context);
      } else {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      }

    } on PlatformException catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}