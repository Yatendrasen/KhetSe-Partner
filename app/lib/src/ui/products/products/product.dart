import 'package:admin/src/functions.dart';
import 'package:admin/src/models/app_state_model.dart';
import 'package:admin/src/models/orders/orders_model.dart';
import 'package:admin/src/models/product/vendor_product_model.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:admin/src/ui/products/products/add_variations_to_cart.dart';
import 'package:admin/src/ui/products/products/product_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

class Product extends StatefulWidget {
  const Product({
    Key? key,
    required this.product,
  }) : super(key: key);

  final VendorProduct product;

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {

  AppStateModel _appStateModel = AppStateModel();

  @override
  Widget build(BuildContext context) {
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
              await Navigator.push(context, MaterialPageRoute(builder: (context) {
                return VendorProductDetail(
                    product: widget.product);
              }));
              setState(() {});
            },
            contentPadding: EdgeInsets.fromLTRB(8, 16, 8, 16),
            leading: Container(
              width: 60,
              height: 80,
              child: CachedNetworkImage(
                imageUrl: widget.product.images.length > 0 ? widget.product.images[0].src : '',
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
                Text(widget.product.name, maxLines: 2),
                if(widget.product.description.isNotEmpty)
                  Text(parseHtmlString(widget.product.description), style: Theme.of(context).textTheme.bodySmall, maxLines: 2),

              ],
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Price(product: widget.product),
                    Row(
                      children: [
                        Text(widget.product.totalSales.toString() + AppLocalizations.of(context)
                            .translate("orders"),),
                      ],
                    ),
                  ],
                ),
                ScopedModelDescendant<AppStateModel>(
                    builder: (context, child, model) {
                      if (model.order.lineItems.any((element) => element.productId == widget.product.id)) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(onPressed: () {
                              _decreaseQty();
                            }, icon: Icon(CupertinoIcons.minus_circle, color: Theme.of(context).primaryColor)),
                            Center(child: Text(getQty().toString())),
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
    if (widget.product.type == 'variable') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddVariationsToCart(product: widget.product)),
      );
    } else {
      final lineItem = LineItem(
          images: widget.product.images,
          productId: widget.product.id,
          quantity: 1,
          name: widget.product.name,
          price: double.parse(widget.product.price),
          total:
          (1 * double.parse(widget.product.price))
      );
      _appStateModel.addOrderLineItem(lineItem);
    }
  }

  void _increaseQty() {
    if (_appStateModel.order.lineItems
        .any((lineItems) => lineItems.productId == widget.product.id)) {
      _appStateModel.order.lineItems
          .firstWhere((lineItems) => lineItems.productId == widget.product.id)
          .quantity++;

      _appStateModel.order.lineItems
          .firstWhere((lineItems) => lineItems.productId == widget.product.id)
          .total = (_appStateModel.order.lineItems
          .firstWhere(
              (lineItems) => lineItems.productId == widget.product.id)
          .price *
          (_appStateModel.order.lineItems
              .firstWhere((lineItems) => lineItems.productId == widget.product.id)
              .quantity + 1));
    } else _addProduct();
    _appStateModel.notifyModelListeners();

  }

  void _decreaseQty() {
    if (_appStateModel.order.lineItems
        .any((lineItems) => lineItems.productId == widget.product.id)) {
      if (_appStateModel.order.lineItems
          .firstWhere(
              (lineItems) => lineItems.productId == widget.product.id)
          .quantity ==
          1) {
        _appStateModel.order.lineItems.removeWhere(
                (lineItems) => lineItems.productId == widget.product.id);
      } else {
        _appStateModel.order.lineItems
            .firstWhere(
                (lineItems) => lineItems.productId == widget.product.id)
            .quantity--;
        _appStateModel.order.lineItems
            .firstWhere(
                (lineItems) => lineItems.productId == widget.product.id)
            .total = (_appStateModel.order.lineItems
            .firstWhere(
                (lineItems) => lineItems.productId == widget.product.id)
            .price *
            (_appStateModel.order.lineItems
                .firstWhere((lineItems) => lineItems.productId == widget.product.id)
                .quantity - 1));

      }
      _appStateModel.notifyModelListeners();
    }
  }

  getQty() {
    if (_appStateModel.order.lineItems
        .any((lineItems) => lineItems.productId == widget.product.id)) {
      return _appStateModel.order.lineItems
          .firstWhere((lineItems) => lineItems.productId == widget.product.id)
          .quantity;
    } else return 0;
  }
}


class Price extends StatelessWidget {
  Price({
    Key? key,
    required this.product,
  }) : super(key: key);

  final NumberFormat formatter = NumberFormat.simpleCurrency(
      decimalDigits: AppStateModel().numberOfDecimals, name: AppStateModel().currency);
  final VendorProduct product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          product.salePrice != null && product.salePrice!.isNotEmpty
              ? Text(formatter.format(double.parse(product.salePrice!)),
              style: Theme.of(context).textTheme.titleMedium)
              : double.parse(product.price) != 0
              ? Text(formatter.format(double.parse(product.price)),
              style: Theme.of(context).textTheme.titleMedium)
              : Container(),
          SizedBox(width: 4),
          product.salePrice != null && product.salePrice!.isNotEmpty &&
              double.parse(product.regularPrice!) != 0
              ? Text(
            formatter.format(double.parse(product.regularPrice!)),
            style: TextStyle(
              decoration: TextDecoration.lineThrough,
              fontSize: 12,
            ),
          )
              : Container(),
        ],
      ),
    );
  }
}