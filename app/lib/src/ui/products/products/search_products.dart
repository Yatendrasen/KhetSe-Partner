import 'dart:async';
import 'package:admin/src/blocs/orders/orders_bloc.dart';
import 'package:admin/src/models/app_state_model.dart';
import 'package:admin/src/blocs/products/products_bloc_new.dart';
import 'package:admin/src/models/product/vendor_product_model.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:admin/src/ui/products/products/filter_product.dart';
import 'package:admin/src/ui/products/products/product.dart';
import 'package:admin/src/ui/products/products/search_field.dart';
import 'package:admin/src/ui/cart/cart_icon.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class SearchProducts extends StatefulWidget {
  final ProductBloc searchBloc = ProductBloc();
  final OrdersBloc ordersBloc;

  SearchProducts({Key? key, required this.ordersBloc}) : super(key: key);
  @override
  _SearchProductsState createState() => _SearchProductsState();
}

class _SearchProductsState extends State<SearchProducts> {
  ScrollController _scrollController = new ScrollController();
  TextEditingController inputController = new TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    if (_debounce != null) _debounce!.cancel();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          widget.searchBloc.moreItems) {
        widget.searchBloc.loadMoreSearchResults();
      }
    });
  }

  @override
  void dispose() {
    if (_debounce != null) _debounce!.cancel();
    super.dispose();
  }

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (inputController.text.isNotEmpty) {
        widget.searchBloc.filter['search'] = inputController.text;
        widget.searchBloc.fetchProducts();
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: false,
        elevation: 0,
        title: SearchBarField(
          searchTextController: inputController,
          hintText:AppLocalizations.of(context)
              .translate("search_products"),
          onChanged: (value) {
            _onSearchChanged();
          },
          autofocus: true,
        ),
        actions: [
          IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return FilterProducts(productBloc: widget.searchBloc);
            }));
          }, icon: Icon(Icons.tune)),
          CartIcon(ordersBloc: widget.ordersBloc)
        ],
      ),
      body: StreamBuilder(
          stream: widget.searchBloc.searchResults,
          builder: (context, AsyncSnapshot<List<VendorProduct>> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return RefreshIndicator(
                onRefresh: () async {
                  widget.searchBloc.fetchProducts();
                  await new Future.delayed(const Duration(seconds: 2));
                },
                child: ListView(
                  controller: _scrollController,
                  children: [
                    for(var product in snapshot.data!)
                      Product(product: product)
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return inputController.text.isNotEmpty ? Center(child: CircularProgressIndicator()) : Container();
            }
          }),
    );
  }
}
