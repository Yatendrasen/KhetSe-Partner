import 'package:admin/src/blocs/customers/customer_bloc.dart';
import 'package:admin/src/ui/customers/search_customer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:admin/src/models/customer/customer_model.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'add_customer.dart';
import 'customer_detail.dart';
import 'filter_customer.dart';

class SelectCustomer extends StatefulWidget {
  final CustomerBloc customersBloc = CustomerBloc();
  @override
  _SelectCustomerState createState() => _SelectCustomerState();
}

class _SelectCustomerState extends State<SelectCustomer> {
  ScrollController _scrollController = new ScrollController();
  bool _hideSearch = true;
  bool hasMoreItems = true;
  Icon actionIcon = new Icon(Icons.search);
  @override
  void initState() {
    widget.customersBloc.fetchItems();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.customersBloc.loadMore();
      }
    });
    super.initState();
  }

  final TextStyle _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    Color primaryIconThemeColor = Theme.of(context).primaryIconTheme.color!;
    return Scaffold(
        appBar: AppBar(
            title: Text(AppLocalizations.of(context).translate("customers")),
          actions: [
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
            )
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

  Widget buildListTile(BuildContext context, Customer customer) {
    return MergeSemantics(
      child: Card(
        margin: EdgeInsets.all(0.2),
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        child: ListTile(
          onTap: () => openDetail(customer),
          leading: customer.firstName.isNotEmpty
              ? ExcludeSemantics(
                  child: CircleAvatar(child: Text(customer.firstName[0].toUpperCase())))
              : ExcludeSemantics(child: CircleAvatar(child: Text('C'))),
          title: Text(customer.email),
          subtitle: Text(customer.lastName),
        ),
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
              return Card(
                margin: EdgeInsets.all(0.2),
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  onTap: () {
                    Navigator.of(context).pop(snapshot.data![index]);
                  },
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
