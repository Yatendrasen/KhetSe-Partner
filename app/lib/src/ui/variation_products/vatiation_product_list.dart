import 'package:admin/src/ui/custom_card.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:admin/src/blocs/products/variation_product_bloc_new.dart';
import 'package:admin/src/ui/variation_products/edit_variation_product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:admin/src/models/product/product_model.dart';
import '../../models/app_state_model.dart';
import '../../blocs/products/vendor_bloc.dart';
import 'package:html/parser.dart';
import '../../models/product/product_variation_model.dart' hide VariationImage;
import '../../models/product/vendor_product_model.dart';
import 'add_variation_product.dart';
import 'package:intl/intl.dart';


class VariationProductList extends StatefulWidget {
  final VariationProductBloc variationProductBloc = VariationProductBloc();
  final VendorProduct product;

  VariationProductList({Key? key, required this.product,}) : super(key: key);

  @override
  _VariationProductListState createState() => _VariationProductListState();
}


class _VariationProductListState extends State<VariationProductList> {
  ScrollController _scrollController = new ScrollController();
  AppStateModel _appStateModel = AppStateModel();
  @override
  void initState() {
    widget.variationProductBloc.getVariationProducts(widget.product.id);
  }

    @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("variations")),

          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add,
                semanticLabel: 'add',
              ),
            onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddVariations(
                            variationProductBloc: widget.variationProductBloc,
                            product: widget.product,
                            )),
                );
              },
            ),
          ]),


      body: StreamBuilder(
          stream: widget.variationProductBloc.allVariationProducts,
          builder: (context, AsyncSnapshot<List<ProductVariation>> snapshot) {

            if (snapshot.hasData && snapshot.data != null) {
              return CustomScrollView(
                  controller: _scrollController, slivers: buildList(snapshot));
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  Widget buildListTile(BuildContext context, ProductVariation variationProduct) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        decimalDigits: 3, name: _appStateModel.selectedCurrency);
    var name = '';

    variationProduct.attributes.forEach((value) {
      name = name + ' '+ value.option;
    });

    return MergeSemantics(
      child: CustomCard(
        child: ListTile(
          isThreeLine: true,
          leading: Image.network(
            variationProduct.image.src,
            fit: BoxFit.fill,
          ),
          title: Text(name),
          subtitle: Text(formatter.format((double.parse('${variationProduct.price}')))),
            onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditVariationProduct(
                      variationProduct: variationProduct,
                      variationProductBloc: widget.variationProductBloc,
                      product: widget.product,
                    )),
              );
            }
        ),
      ),
    );
  }

  Widget buildItemList(AsyncSnapshot<List<ProductVariation>> snapshot) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            return Column(
              children: <Widget>[
                buildListTile(context, snapshot.data![index]),
                Divider(height: 0.0),
              ],
            );
          },
          childCount: snapshot.data!.length,
        ));
  }

  buildList(AsyncSnapshot<List<ProductVariation>> snapshot) {
    List<Widget> list = [];
    list.add(buildItemList(snapshot));
    if (snapshot.data != null) {
      list.add(SliverPadding(
          padding: EdgeInsets.all(0.0),
          sliver: SliverList(
              delegate: SliverChildListDelegate([
                Container(
                    height: 60,
                    child: Builder(
                      builder: (context) {
                        return snapshot.hasData && snapshot.data == false
                            ? Center(child: Text(AppLocalizations.of(context)
                            .translate("no_more_products"+'!'),))
                            : Center(child: Container());
                      }
                    ))
              ]))));
    }
    return list;
  }
}

