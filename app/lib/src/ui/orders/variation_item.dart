import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:admin/src/models/app_state_model.dart';
import 'package:admin/src/models/orders/orders_model.dart';
import 'package:admin/src/blocs/products/vendor_bloc.dart';
import 'package:admin/src/models/product/product_variation_model.dart';
import 'package:admin/src/models/product/vendor_product_model.dart';


class VariationItem extends StatefulWidget {
  final VendorBloc vendorBloc;
  final VendorProduct product;
  final Order order;
  final ProductVariation variation;

  VariationItem(
      {Key? key, required this.product, required this.vendorBloc, required this.order, required this.variation})
      : super(key: key);

  @override
  _VariationItemState createState() => _VariationItemState();
}

class _VariationItemState extends State<VariationItem> {
  AppStateModel _appStateModel = AppStateModel();
  late NumberFormat formatter;

  var qty = 0;

  @override
  void initState() {
    super.initState();

    formatter = NumberFormat.simpleCurrency(
        decimalDigits: 3, name: _appStateModel.selectedCurrency);



  }

  @override
  Widget build(BuildContext context) {
    var name = '';

    widget.variation.attributes.forEach((value) {
      name = name + ' ' + value.option;
    });

    if (_appStateModel.order.lineItems.isNotEmpty && _appStateModel.order.lineItems.any((lineItems) => lineItems.productId == widget.product.id && lineItems.variationId == widget.variation.id)) {
      qty = _appStateModel.order.lineItems.singleWhere((lineItems) => lineItems.productId == widget.product.id && lineItems.variationId == widget.variation.id).quantity.toInt();
    }

    return Card(
      child: Row(
        children: <Widget>[
          Container(
            width: 120,
            height: 120,
            child: CachedNetworkImage(
              imageUrl: widget.variation.image.src,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, url) => Container(
                width: 120,
                height: 120,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.black12,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(name),
              Text(formatter.format((double.parse(widget.variation.price)))),
              qty != 0
                  ? Container(
                      // width: 200,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                //TODO for decrease qty and if qty is 0 remove line item
                                _decreaseQty();
                              }),
                          Text(qty.toString()),
                          IconButton(
                              icon: Icon(Icons.add_circle_outline),
                              onPressed: () {
                                //TODO Containe? increase qty : Add line item
                                _increaseQty();
                              }),
                        ],
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.add_circle_outline),
                            onPressed: () {
                              _addProduct();
                            }),
                      ],
                    ),
            ],
          )
        ],
      ),
    );
  }

  void _addProduct() {
    final lineItem = LineItem(
      images: widget.product.images,
      productId: widget.product.id,
      variationId: widget.variation.id,
      quantity: 1,
      name: widget.product.name,
      price: double.parse(widget.variation.price),
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
