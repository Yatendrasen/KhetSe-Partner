import 'package:admin/src/blocs/tax_rates/tax_rates_bloc.dart';
import 'package:admin/src/models/tax_rates/tax_rates.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:admin/src/ui/tax_rates/add_tax_rate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TaxRates extends StatefulWidget {
  TaxRatesBloc taxRatesBloc = TaxRatesBloc();
  TaxRates({Key? key}) : super(key: key);
  @override
  State<TaxRates> createState() => _TaxRatesState();
}

class _TaxRatesState extends State<TaxRates> {
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    widget.taxRatesBloc.fetchItems();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.taxRatesBloc.loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
          stream: widget.taxRatesBloc.results,
          builder: (context, AsyncSnapshot<List<TaxRatesModel>> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return snapshot.data!.length > 0 ? ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Slidable(
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            label: AppLocalizations.of(context)
                          .translate("delete"),
                            backgroundColor: Colors.red,
                            icon: Icons.delete,
                            onPressed: (context) {
                              widget.taxRatesBloc.deleteItem(snapshot.data![index]);
                            },
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(snapshot.data![index].name),
                        subtitle: Text(snapshot.data![index].rate),
                      ),
                    );
                  }) : Center(child: Text(AppLocalizations.of(context)
                  .translate("no_items_found"),));
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else return Center(child: CircularProgressIndicator());
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddTaxRate(taxRatesBloc: widget.taxRatesBloc)),
          );
        },
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }
}
