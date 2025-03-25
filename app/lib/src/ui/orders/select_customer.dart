import 'package:admin/src/blocs/customers/customer_bloc.dart';
import 'package:admin/src/ui/customers/customer_detail.dart';
import 'package:admin/src/ui/customers/filter_customer.dart';
import 'package:flutter/material.dart';
import 'package:admin/src/ui/coupons/coupon_list.dart';
import 'package:admin/src/models/customer/customer_model.dart';

import 'package:admin/src/ui/language/app_localizations.dart';
import 'add_customer.dart';

class SelectCustomer extends StatefulWidget {
  final CustomerBloc customersBloc = new CustomerBloc();
  @override
  _SelectCustomerState createState() => _SelectCustomerState();
}

class _SelectCustomerState extends State<SelectCustomer> {
  ScrollController _scrollController = new ScrollController();
  Widget appBarTitle = demo();
  bool _hideSearch = true;
  bool hasMoreItems = true;
  Icon actionIcon = new Icon(Icons.search);
  @override
  void initState() {
    super.initState();
    widget.customersBloc.fetchItems();
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
        appBar: AppBar(
          title: appBarTitle,
          actions: _hideSearch
              ? <Widget>[
                  IconButton(
                    icon: new Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        _hideSearch = false;
                        this.appBarTitle = new TextField(
                          controller: TextEditingController()
                            ..text = widget.customersBloc.filter['search'] ?? '',
                          onChanged: (text) {
                            widget.customersBloc.filter['search'] = text;
                            widget.customersBloc.fetchItems();
                          },
                          style: new TextStyle(
                            color: primaryIconThemeColor,
                          ),
                          decoration: new InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: new Icon(Icons.search,
                                  color: primaryIconThemeColor),
                              hintText: AppLocalizations.of(context)
                                  .translate("search"),
                              hintStyle:
                                  new TextStyle(color: primaryIconThemeColor)),
                        );
                      });
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
                ]
              : <Widget>[
                  IconButton(
                    icon: new Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _hideSearch = true;
                        this.appBarTitle = Text(AppLocalizations.of(context)
                            .translate("customers"));
                      });
                    },
                  ),
                ],
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

  Widget buildListTile(BuildContext context, Customer customer) {
    return MergeSemantics(
      child: ListTile(
        onTap: () => selectCustomer(customer),
        leading: customer.firstName.isNotEmpty
            ? ExcludeSemantics(
                child: CircleAvatar(child: Text(customer.firstName[0])))
            : ExcludeSemantics(child: CircleAvatar(child: Text(AppLocalizations.of(context)
            .translate("c")))),
        title: Text(customer.email),
        subtitle: Text(customer.lastName),
      ),
    );
  }

  List<Widget> buildList(AsyncSnapshot<List<Customer>> snapshot) {

    Iterable<Widget> listTiles = snapshot.data!
        .map<Widget>((Customer item) => buildListTile(context, item));
    listTiles = ListTile.divideTiles(context: context, tiles: listTiles);

    List<Widget> list = [];
    if (snapshot.data != null) {
      list.add(SliverPadding(
        padding: EdgeInsets.all(0.0),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return ListTile(
                onTap: () => selectCustomer(snapshot.data![index]),
                leading: snapshot.data![index].firstName.isNotEmpty
                    ? ExcludeSemantics(
                        child: CircleAvatar(
                            child: Text(
                                snapshot.data![index].firstName[0])))
                    : ExcludeSemantics(child: CircleAvatar(child: Text(AppLocalizations.of(context)
                    .translate("c")))),
                title: Text(snapshot.data![index].email),
                subtitle: Text(snapshot.data![index].lastName),
              );
            },
            childCount: snapshot.data!.length,
          ),
        ),
      ));
    }
    return list;
  }

  selectCustomer(Customer customer) {
    Navigator.of(context).pop(customer);
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
