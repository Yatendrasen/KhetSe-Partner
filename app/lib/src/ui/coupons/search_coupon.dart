import 'dart:async';
import 'package:admin/src/blocs/category/category_bloc.dart';
import 'package:admin/src/blocs/coupons/coupon_bloc.dart';
import 'package:admin/src/blocs/customers/customer_bloc.dart';
import 'package:admin/src/functions.dart';
import 'package:admin/src/models/category/category_model.dart';
import 'package:admin/src/models/coupons/coupons_model.dart';
import 'package:admin/src/models/customer/customer_model.dart';
import 'package:admin/src/ui/coupons/coupon_detail.dart';
import 'package:admin/src/ui/customers/customer_detail.dart';
import 'package:admin/src/ui/products/products/search_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SearchCoupon extends StatefulWidget {
  final CouponsBloc couponsBloc = CouponsBloc();

  @override
  _SearchCouponState createState() => _SearchCouponState();
}

class _SearchCouponState extends State<SearchCoupon> {

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
          widget.couponsBloc.moreItems) {
        widget.couponsBloc.loadMore();
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
        widget.couponsBloc.filter['search'] = inputController.text;
        widget.couponsBloc.fetchItems();
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SearchBarField(
          searchTextController: inputController,
          hintText: 'Search Coupon',
          onChanged: (value) {
            _onSearchChanged();
          },
          autofocus: true,
        ),
      ),
      body: StreamBuilder(
          stream: widget.couponsBloc.results,
          builder: (context, AsyncSnapshot<List<Coupon>> snapshot) {
          return snapshot.hasData && snapshot.data != null ? RefreshIndicator(
            onRefresh: () async {
              widget.couponsBloc.fetchItems();
              await new Future.delayed(const Duration(seconds: 2));
            },
            child: ListView(
                controller: _scrollController,
                children: buildList(snapshot)),
          ) : Container();
        }
      ),
    );
  }

  Widget buildListTile(BuildContext context, Coupon coupon) {
    return MergeSemantics(
      child: ListTile(
        onTap: () => openDetail(coupon),
        isThreeLine: coupon.description != '',
        title: Text(coupon.code),
        subtitle: coupon.discountType == '' ? null : Text(coupon.discountType),
      ),
    );
  }

   buildList(AsyncSnapshot<List<Coupon>> snapshot) {

    Iterable<Widget> listTiles = snapshot.data!.map<Widget>((Coupon item) => buildListTile(context, item));
    listTiles = ListTile.divideTiles(context: context, tiles: listTiles);

    /*List<Widget> list = [];
    if (snapshot.data != null) {
      list.add(SliverPadding(
        padding: EdgeInsets.all(0.0),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return Card(
                margin: EdgeInsets.all(0.2),
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  onTap: () => openDetail(snapshot.data![index]),
                  leading: snapshot.data![index].firstName.isNotEmpty
                      ? ExcludeSemantics(
                      child: CircleAvatar(
                          child: Text(
                              snapshot.data![index].firstName[0].toUpperCase())))
                      : ExcludeSemantics(child: CircleAvatar(child: Text('C'))),
                  title: Text(snapshot.data![index].firstName + ' ' +snapshot.data![index].lastName),
                  subtitle: snapshot.data![index].email == null || snapshot.data![index].email.isEmpty ? null : Text(snapshot.data![index].email),
                ),
              );
            },
            childCount: snapshot.data!.length,
          ),
        ),
      ));
    }*/

    return listTiles;
  }

  openDetail(Coupon coupon) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CouponDetail(coupon:coupon)),
    );
  }

}
