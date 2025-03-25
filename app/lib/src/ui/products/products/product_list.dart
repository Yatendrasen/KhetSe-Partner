import 'package:admin/src/blocs/orders/orders_bloc.dart';
import 'package:admin/src/blocs/products/vendor_bloc.dart';
import 'package:admin/src/ui/cart/cart_icon.dart';
import 'package:admin/src/ui/drawer.dart';
import 'package:admin/src/blocs/products/products_bloc_new.dart';
import 'package:admin/src/models/product/vendor_product_model.dart';
import 'package:admin/src/ui/products/products/add_product.dart';
import 'package:admin/src/ui/products/products/filter_product.dart';
import 'package:admin/src/ui/products/products/product.dart';
import 'package:admin/src/ui/products/products/search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductsList extends StatefulWidget {
  final ProductBloc productBloc;
  final OrdersBloc ordersBloc;
  final ValueChanged<int> onChangePageIndex;
  const ProductsList({Key? key, required this.productBloc, required this.onChangePageIndex, required this.ordersBloc}) : super(key: key);
  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {

  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {

    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent &&
          widget.productBloc.moreItems) {
        widget.productBloc.loadMoreSearchResults();
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navigator.of(context).canPop() ? null : MyDrawer(onChangePageIndex: widget.onChangePageIndex),
      appBar: AppBar(
        //titleSpacing: 0,
        title: SearchBarProduct(ordersBloc: widget.ordersBloc),
        actions: [
          IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return FilterProducts(productBloc: widget.productBloc);
            }));
          }, icon: Icon(Icons.tune)),
          CartIcon(ordersBloc: widget.ordersBloc)
        ],
      ),
      body: StreamBuilder(
          stream: widget.productBloc.searchResults,
          builder: (context, AsyncSnapshot<List<VendorProduct>> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return RefreshIndicator(
                onRefresh: () async {
                  widget.productBloc.fetchProducts();
                  await new Future.delayed(const Duration(seconds: 2));
                },
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context,int index) {
                    return Product(product: snapshot.data![index]);
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddVendorProduct(productBloc: widget.productBloc)),
          );
        },
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }
}
