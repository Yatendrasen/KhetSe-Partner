import 'package:admin/src/functions.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../models/app_state_model.dart';
import '../../variation_products/vatiation_product_list.dart';
import '../../../blocs/products/vendor_bloc.dart';
import '../../../models/product/vendor_product_model.dart';
import 'package:intl/intl.dart';

import 'edit_product.dart';

double expandedAppBarHeight = 350;

class VendorProductDetail extends StatefulWidget {
  final VendorBloc vendorBloc = VendorBloc();
  final VendorProduct product;

  VendorProductDetail({
    Key? key,
    required this.product,
  }) : super(key: key);
  @override
  _VendorProductDetailState createState() =>
      _VendorProductDetailState(product);
}

class _VendorProductDetailState extends State<VendorProductDetail> {
  AppStateModel _appStateModel = AppStateModel();

  final VendorProduct products;

  _VendorProductDetailState(this.products);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                widget.vendorBloc.deleteProduct(products);
                Navigator.pop(context);
              }),
        ],
        //  title: Text(widget.products.name),
      ),
      body: buildList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditVendorProduct(
                  vendorBloc: widget.vendorBloc,
                  product: widget.product,
                )),
          );
          setState(() {});
        },
        tooltip: 'Edit',
        child: Icon(Icons.edit),
      ),
    );

  }

  Widget buildList() {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        decimalDigits: 3, name: _appStateModel.selectedCurrency);
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      children: ListTile.divideTiles(
        context: context,
        tiles: [
          ListTile(
              title: Text(AppLocalizations.of(context).translate("images"),),
              subtitle: GridView.builder(
                  shrinkWrap: true,
                  itemCount: products.images.length + 1,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4),
                  itemBuilder: (BuildContext context, int index) {
                    if (products.images.length != index) {
                      return Card(
                          clipBehavior: Clip.antiAlias,
                          elevation: 1.0,
                          margin: EdgeInsets.all(4.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Image.network(products.images[index].src,
                              fit: BoxFit.cover));
                    } else {
                      return Container();
                    }
                  })),
          ListTile(
            title: Text(AppLocalizations.of(context).translate("id"),),
            subtitle: Text(products.id.toString()),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).translate("product_name"),),
            subtitle: Text(products.name),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).translate("regular_price"),),
            subtitle: products.regularPrice != null ? Text(products.regularPrice!) : null,
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).translate("sale_price"),),
            subtitle: products.salePrice != null ? Text(products.salePrice.toString()) : null,
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).translate("status"),),
            subtitle: Text(products.status),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).translate("sku"),),
            subtitle: Text(products.sku),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).translate("type"),),
            subtitle: Text(products.type),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).translate("short_description")),
            subtitle: Text(products.shortDescription, maxLines: 4,),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).translate("description")),
            subtitle: Text(parseHtmlString(products.description), maxLines: 4),
          ),
          widget.product.type == "variable"
              ? ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Text(AppLocalizations.of(context).translate("variations"),),
              trailing: Icon(CupertinoIcons.forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VariationProductList(
                      product: widget.product,
                    ),
                  ),
                );
              })
              : Container(),
          Container(
            padding: EdgeInsets.only(bottom: 40),
          )
        ],
      ).toList(),
    );
  }
}
