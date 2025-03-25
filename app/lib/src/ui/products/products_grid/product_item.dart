import 'package:admin/src/blocs/products/vendor_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:admin/src/models/app_state_model.dart';
import 'package:admin/src/models/product/vendor_product_model.dart';
import 'package:html/parser.dart';
import '../products/product_detail.dart';
import 'package:intl/intl.dart';

const double _scaffoldPadding = 10.0;
const double _minWidthPerColumn = 350.0 + _scaffoldPadding * 2;

class ProductGrid extends StatefulWidget {
  final List<VendorProduct> products;
  final VendorBloc vendorBloc;
  const ProductGrid({Key? key, required this.products, required this.vendorBloc}) : super(key: key);
  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < _minWidthPerColumn
        ? 1
        : screenWidth ~/ _minWidthPerColumn;

    double detailsWidth = MediaQuery.of(context).size.width / crossAxisCount - 160;

    return SliverPadding(
      padding: const EdgeInsets.all(10.0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 2.5,
          crossAxisCount: crossAxisCount,
        ),
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            return ProductItem(
                product: widget.products[index],
                onProductClick: onProductClick,
                detailsWidth: detailsWidth,
                vendorBloc: widget.vendorBloc);
          },
          childCount: widget.products.length,
        ),
      ),
    );
  }

  onProductClick(VendorProduct product) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return VendorProductDetail(
          product: product
      );
    }));
  }
}

class ProductItem extends StatefulWidget {
  final VendorProduct product;
  final VendorBloc vendorBloc;
  final void Function(VendorProduct product) onProductClick;
  final detailsWidth;

  ProductItem({
    Key? key,
    required this.product,
    required this.onProductClick,
    required this.detailsWidth,
    required this.vendorBloc,
  }) : super(key: key);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  AppStateModel _appStateModel = AppStateModel();

  int percentOff = 0;


  NumberFormat formatter = NumberFormat.simpleCurrency(
      decimalDigits: 2, name: AppStateModel().selectedCurrency);

  @override
  Widget build(BuildContext context) {



    bool onSale = false;
    if (widget.product.regularPrice == null ||
        widget.product.regularPrice!.isNotEmpty &&
            widget.product.price != null &&
            widget.product.price.isNotEmpty) {
      widget.product.regularPrice = widget.product.price;
    }

    if ((widget.product.salePrice != null &&
        widget.product.salePrice != 0 &&
        widget.product.regularPrice != null &&
        widget.product.regularPrice!.isNotEmpty)) {
      onSale = true;
      try {
        percentOff = ((((double.parse(widget.product.regularPrice!) -
            double.parse(widget.product.salePrice!)) /
            double.parse(widget.product.regularPrice!) *
            100))
            .round());
      } catch (e) {

      }
    }

    return Card(
      elevation: 0,
      margin: EdgeInsets.all(0.0),
      child: InkWell(
        splashColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
        onTap: () {
          widget.onProductClick(widget.product);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 120,
              height: 120,
              padding: EdgeInsets.all(0.0),
              child: Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: widget.product.images.length > 0 ? widget.product.images[0].src : '',
                    imageBuilder: (context, imageProvider) => Card(
                      elevation: 0.0,
                      margin: EdgeInsets.all(0.0),
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
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
                  percentOff != 0
                      ? Positioned(
                    top: 10.0,
                    left: 0.0,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      elevation: 0.0,
                      margin: EdgeInsets.all(0.0),
                      color: Theme.of(context).colorScheme.secondary,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
                        child: Text(
                          percentOff.toString() + '% OFF',
                          style: Theme.of(context)
                              .textTheme.titleSmall!
                              .copyWith(fontSize: 12.0),
                        ),
                      ),
                    ),
                  )
                      : Container()
                ],
              ),
            ),
            Container(
              width: widget.detailsWidth,
              height: 160,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 10.0, 0, 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.product.name,
                            maxLines: 1,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                letterSpacing: 0.0)),
                        SizedBox(height: 4.0),
                        Text(_parseHtmlString(widget.product.shortDescription),
                            maxLines: 2,
                            style: TextStyle(
                              color:
                              Theme.of(context).hintColor,
                              letterSpacing: 0.0,
                              fontSize: 14,
                            )),
                        //SizedBox(height: 6.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
                            Text(
                                onSale
                                    ? formatter
                                    .format(widget.product.salePrice)
                                    : '',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .hintColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                )),
                            onSale
                                ? SizedBox(width: 6.0)
                                : SizedBox(width: 0.0),
                            Row(
                              children: <Widget>[
                                Text(
                                    (widget.product.price != null &&
                                        widget.product.price.isNotEmpty)
                                        ? formatter
                                        .format(double.parse(widget.product.price))
                                        : '',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .hintColor,
                                      decoration: onSale
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                      fontWeight: onSale
                                          ? FontWeight.w300
                                          : FontWeight.w600,
                                      fontSize: onSale ? 11 : 16,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    //SizedBox(height: 6.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.product.ratingCount != 0 ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.star, size: 16, color: Colors.amber,),
                            SizedBox(width: 4.0),
                            Text(widget.product.averageRating),
                            Text('('+widget.product.ratingCount.toString()+')')
                          ],
                        ) : Container(),
                      ],
                    ),
                    SizedBox(height: 6.0),
                    /*Row(
                      children: <Widget>[
                        RatingBar(
                          initialRating: double.parse(product.averageRating),
                          itemSize: 15,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          ignoreGestures: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {

                          },
                        ),
                        product.averageRating != '0.00'
                            ? Row(
                                children: <Widget>[
                                  SizedBox(width: 4.0),
                                  Text(
                                      '(' +
                                          product.ratingCount.toString() +
                                          ')',
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .hintColor
                                            .withOpacity(0.4),
                                        fontSize: 12,
                                      )),
                                ],
                              )
                            : Container(),
                      ],
                    )*/
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _parseHtmlString(String htmlString) {
  var document = parse(htmlString);

  String parsedString = parse(document.body!.text).documentElement!.text;

  return parsedString;
}
