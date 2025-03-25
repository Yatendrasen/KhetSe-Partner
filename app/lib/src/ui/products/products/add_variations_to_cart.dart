import 'package:admin/src/blocs/products/variation_product_bloc_new.dart';
import 'package:admin/src/models/app_state_model.dart';
import 'package:admin/src/models/orders/orders_model.dart';
import 'package:admin/src/models/product/product_variation_model.dart';
import 'package:admin/src/models/product/vendor_product_model.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

class AddVariationsToCart extends StatefulWidget {
  final VendorProduct product;
  final VariationProductBloc variationProductBloc = VariationProductBloc();
  AddVariationsToCart({Key? key, required this.product}) : super(key: key);
  @override
  _AddVariationsToCartState createState() => _AddVariationsToCartState();
}

class _AddVariationsToCartState extends State<AddVariationsToCart> {

  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    widget.variationProductBloc.getVariationProducts(widget.product.id);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.variationProductBloc.loadMore(widget.product.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)
            .translate("add_variations"),),
      ),
      body: StreamBuilder<List<ProductVariation>>(
        stream: widget.variationProductBloc.allVariationProducts,
        builder: (context, snapshot) {
          return snapshot.hasData && snapshot.data != null ? ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return VariationProduct(variation: snapshot.data![index], product: widget.product);
            },
          ) : Center(child: CircularProgressIndicator());
        }
      ),
    );
  }
}


class VariationProduct extends StatefulWidget {
  final ProductVariation variation;
  final VendorProduct product;
  const VariationProduct({Key? key, required this.variation, required this.product}) : super(key: key);
  @override
  _VariationProductState createState() => _VariationProductState();
}

class _VariationProductState extends State<VariationProduct> {

  AppStateModel _appStateModel = AppStateModel();
  late NumberFormat formatter;
  String name = '';
  var qty = 0;

  @override
  void initState() {
    super.initState();
    widget.variation.attributes.forEach((value) {
      name = name + ' ' + value.option;
    });
    formatter = NumberFormat.simpleCurrency(
        decimalDigits: 2, name: _appStateModel.selectedCurrency);
  }

  @override
  Widget build(BuildContext context) {

    if (_appStateModel.order.lineItems.isNotEmpty && _appStateModel.order.lineItems.any((lineItems) => lineItems.productId == widget.product.id && lineItems.variationId == widget.variation.id)) {
      qty = _appStateModel.order.lineItems.singleWhere((lineItems) => lineItems.productId == widget.product.id && lineItems.variationId == widget.variation.id).quantity.toInt();
    }

    return Column(
      children: [
        Card(
          elevation: 0,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          child: ListTile(
            onTap: () async {

            },
            contentPadding: EdgeInsets.fromLTRB(8, 16, 8, 16),
            leading: Container(
              width: 60,
              height: 80,
              child: CachedNetworkImage(
                imageUrl: widget.variation.image.src.isNotEmpty ? widget.variation.image.src : '',
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image:
                    DecorationImage(image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => Container(
                  width: 60,
                  height: 80,
                  color: Theme.of(context).canvasColor,
                ),
                errorWidget: (context, url, error) => Container(
                  width: 60,
                  height: 80,
                  color: Theme.of(context).canvasColor,
                ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, maxLines: 2),
                Text(formatter.format((double.parse(widget.variation.price)))),
              ],
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                ScopedModelDescendant<AppStateModel>(
                    builder: (context, child, model) {
                      if (qty != 0) {
                        return Row(
                          children: [
                            IconButton(onPressed: () {
                              _decreaseQty();
                            }, icon: Icon(CupertinoIcons.minus_circle, color: Theme.of(context).primaryColor)),
                            SizedBox(
                                width: 20,
                                child: Center(child: Text(qty.toString()))),
                            IconButton(onPressed: () {
                              _increaseQty();
                            }, icon: Icon(CupertinoIcons.add_circled_solid, color: Theme.of(context).primaryColor))
                          ],
                        );
                      } else {
                        return TextButton(
                            onPressed: () {
                              _addProduct();
                            },
                            child: Text(AppLocalizations.of(context)
                                .translate("add"),)
                        );
                      }
                    }
                )
              ],
            ),
          ),
        ),
        Divider(height: 0)
      ],
    );
  }

  void _addProduct() {

    List<LineItemMetaDatum> metaDatum = [];

    widget.variation.attributes.forEach((element) {
      metaDatum.add(LineItemMetaDatum(id: element.id, key: 'pa_' + element.name.toLowerCase(), value: element.option));
    });

    final lineItem = LineItem(
      images: widget.product.images,
      productId: widget.product.id,
      variationId: widget.variation.id,
      quantity: 1,
      name: widget.product.name,
      price: double.parse(widget.variation.price),
      metaData: metaDatum,
      total:
      (1 * double.parse(widget.variation.price)),
    );
    setState(() {
      _appStateModel.order.lineItems.add(lineItem);
    });
  }

  void _increaseQty() {
    if (_appStateModel.order.lineItems
        .any((lineItems) => lineItems.variationId == widget.variation.id)) {
      _appStateModel.order.lineItems
          .singleWhere(
              (lineItems) => lineItems.variationId == widget.variation.id)
          .quantity++;

      _appStateModel.order.lineItems
          .singleWhere(
              (lineItems) => lineItems.variationId == widget.variation.id)
          .total = (_appStateModel.order.lineItems
          .singleWhere((lineItems) =>
      lineItems.variationId == widget.variation.id)
          .price *
          (qty + 1));
      setState(() {
        qty = qty + 1;
      });
    } else
      _addProduct();
  }

  void _decreaseQty() {
    if (_appStateModel.order.lineItems
        .any((lineItems) => lineItems.variationId == widget.variation.id)) {
      if (_appStateModel.order.lineItems
          .singleWhere(
              (lineItems) => lineItems.variationId == widget.variation.id)
          .quantity ==
          0) {
        _appStateModel.order.lineItems.removeWhere(
                (lineItems) => lineItems.variationId == widget.variation.id);
        setState(() {
          qty = 0;
        });
      } else {
        _appStateModel.order.lineItems
            .singleWhere(
                (lineItems) => lineItems.variationId == widget.variation.id)
            .quantity--;
        _appStateModel.order.lineItems
            .singleWhere(
                (lineItems) => lineItems.variationId == widget.variation.id)
            .total = (_appStateModel.order.lineItems
            .singleWhere((lineItems) =>
        lineItems.variationId == widget.variation.id)
            .price *
            (qty - 1));
        setState(() {
          qty = qty - 1;
        });
      }
    }
  }
}
