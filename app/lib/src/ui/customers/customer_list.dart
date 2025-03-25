import 'package:admin/src/blocs/customers/customer_bloc.dart';
import 'package:admin/src/ui/customers/search_customer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:admin/src/ui/coupons/coupon_list.dart';
import 'package:admin/src/models/customer/customer_model.dart';

import 'package:admin/src/ui/language/app_localizations.dart';
import '../drawer.dart';
import 'add_customer.dart';
import 'customer_detail.dart';
import 'filter_customer.dart';

class CustomerList extends StatefulWidget {
  final ValueChanged<int> onChangePageIndex;
  final CustomerBloc customersBloc;
  CustomerList(
      {Key? key,
      required this.customersBloc,
        required this.onChangePageIndex});
  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  ScrollController _scrollController = new ScrollController();
  bool hasMoreItems = true;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.customersBloc.loadMore();
      }
    });
  }

  final TextStyle _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    Color primaryIconThemeColor = Theme.of(context).primaryIconTheme.color!;
    return Scaffold(
        drawer: MyDrawer(
            onChangePageIndex: widget.onChangePageIndex),
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate("customers")),
          actions: <Widget>[
                  IconButton(
                    icon: new Icon(CupertinoIcons.search),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => SearchCustomer()
                          ));
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.tune,
                      semanticLabel: 'filter',
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute<DismissDialogAction>(
                            builder: (BuildContext context) => FilterCustomer(
                                customersBloc: widget.customersBloc),
                            fullscreenDialog: true,
                          ));
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      semanticLabel: 'add',
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddCustomer(
                                customersBloc: widget.customersBloc)),
                      );
                    },
                  ),

                  /*  IconButton(
            icon: Icon(
              Icons.local_offer,
              semanticLabel: 'filter',
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute<DismissDialogAction>(
                    builder: (BuildContext context) => CouponList(),
                    fullscreenDialog: true,
                  ));
            },
          ),*/
                ]
        ),
        //drawer: MyDrawer(),
        body: StreamBuilder(
            stream: widget.customersBloc.results,
            builder: (context, AsyncSnapshot<List<Customer>> snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return RefreshIndicator(
                  onRefresh: () async {
                    widget.customersBloc.fetchItems();
                    await new Future.delayed(const Duration(seconds: 2));
                  },
                  child: CustomScrollView(
                      controller: _scrollController,
                      slivers: buildList(snapshot)),
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return Center(child: CircularProgressIndicator());
            }));
  }



  List<Widget> buildList(AsyncSnapshot<List<Customer>> snapshot) {

    List<Widget> list = [];
    if (snapshot.data != null) {
      list.add(SliverPadding(
        padding: EdgeInsets.all(0.0),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    onTap: () => openDetail(snapshot.data![index]),
                    leading: snapshot.data![index].firstName.isNotEmpty
                        ? ExcludeSemantics(
                            child: CircleAvatar(
                                child: Text(
                                    snapshot.data![index].firstName[0].toUpperCase())))
                        : ExcludeSemantics(child: CircleAvatar(child: Text('C'))),
                    title: snapshot.data![index].firstName.isNotEmpty ? Text(snapshot.data![index].firstName + ' ' +snapshot.data![index].lastName) : Text(snapshot.data![index].billing.firstName + ' ' +snapshot.data![index].billing.lastName),
                    subtitle: snapshot.data![index].billing.phone.isNotEmpty ? Text(snapshot.data![index].billing.phone) : snapshot.data![index].email == null || snapshot.data![index].email.isEmpty ? null : Text(snapshot.data![index].email),
                  ),
                  Divider()
                ],
              );
            },
            childCount: snapshot.data!.length,
          ),
        ),
      ));

      /*list.add(SliverPadding(
          padding: EdgeInsets.all(0.0),
          sliver: SliverList(
              delegate: SliverChildListDelegate([
            Container(
                height: 60,
                child: hasMoreItems
                    ? Center(child: CircularProgressIndicator())
                    : Container())
          ]))));*/
    }

    return list;
  }

  openDetail(Customer customer) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CustomerDetail(
              customer: customer, customersBloc: widget.customersBloc)),
    );
  }

  static Widget demo() {
    return Builder(builder: (context) {
      return new Text(AppLocalizations.of(context).translate("customers"));
    });
  }

  buildLoadMore() {
    return SliverPadding(
        padding: EdgeInsets.all(0.0),
        sliver: SliverList(
            delegate: SliverChildListDelegate([
          Container(
              height: 60,
              child: hasMoreItems
                  ? Center(child: CircularProgressIndicator())
                  : Container()),
        ])));
  }
}
