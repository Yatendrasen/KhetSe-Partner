import 'dart:async';
import 'package:admin/src/blocs/customers/customer_bloc.dart';
import 'package:admin/src/models/customer/customer_model.dart';
import 'package:admin/src/ui/customers/customer_detail.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:admin/src/ui/products/products/search_field.dart';
import 'package:flutter/material.dart';

class SearchCustomer extends StatefulWidget {
  final CustomerBloc customersBloc = CustomerBloc();
  @override
  _SearchCustomerState createState() => _SearchCustomerState();
}

class _SearchCustomerState extends State<SearchCustomer> {

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
          widget.customersBloc.moreItems) {
        widget.customersBloc.loadMore();
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
        widget.customersBloc.filter['search'] = inputController.text;
        widget.customersBloc.fetchItems();
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
          hintText: AppLocalizations.of(context)
            .translate("search_customers"),
          onChanged: (value) {
            _onSearchChanged();
          },
          autofocus: true,
        ),
      ),
      body: StreamBuilder(
          stream: widget.customersBloc.results,
          builder: (context, AsyncSnapshot<List<Customer>> snapshot) {
          return snapshot.hasData && snapshot.data != null ? RefreshIndicator(
            onRefresh: () async {
              widget.customersBloc.fetchItems();
              await new Future.delayed(const Duration(seconds: 2));
            },
            child: CustomScrollView(
                controller: _scrollController,
                slivers: buildList(snapshot)),
          ) : Container();
        }
      ),
    );
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

    Iterable<Widget> listTiles = snapshot.data!.map<Widget>((Customer item) => buildListTile(context, item));
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
    }

    return list;
  }

  openDetail(Customer customer) {
    //TODO Implement
  }

}
