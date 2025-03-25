import 'package:admin/src/blocs/products/products_bloc_new.dart';
import 'package:admin/src/ui/cart/cart.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:flutter/material.dart';

class FilterProducts extends StatefulWidget {
  final ProductBloc productBloc;

  const FilterProducts({Key? key, required this.productBloc}) : super(key: key);
  @override
  _FilterProductsState createState() => _FilterProductsState();
}

class _FilterProductsState extends State<FilterProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)
            .translate("filter_products"),),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                //"Order".toUpperCase(),
                AppLocalizations.of(context)
                    .translate("order"),

                style: Theme.of(context).textTheme.titleMedium,
              ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context)
        .translate("ascending"),),
                    selected:
                    widget.productBloc.filter.containsKey('order') &&
                        widget.productBloc.filter['order'] == 'asc',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.productBloc.filter['order'] = 'asc';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context)
        .translate("descending"),),
                    selected:
                    widget.productBloc.filter.containsKey('order') &&
                        widget.productBloc.filter['order'] == 'desc',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.productBloc.filter['order'] = 'desc';
                      });
                    },
                  )
                ],
              ),
            ],
          ),
          Divider(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                //"Status".toUpperCase(),
                AppLocalizations.of(context)
                    .translate("status"),
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context)
        .translate("any"),),
                    selected:
                    widget.productBloc.filter.containsKey('status') &&
                        widget.productBloc.filter['status'] == 'any',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.productBloc.filter['status'] = 'any';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context)
                        .translate("draft"),),
                    selected:
                    widget.productBloc.filter.containsKey('status') &&
                        widget.productBloc.filter['status'] == 'draft',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.productBloc.filter['status'] = 'draft';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context)
        .translate("pending"),),
                    selected:
                    widget.productBloc.filter.containsKey('status') &&
                        widget.productBloc.filter['status'] == 'pending',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.productBloc.filter['status'] = 'pending';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context)
        .translate("private"),),
                    selected:
                    widget.productBloc.filter.containsKey('status') &&
                        widget.productBloc.filter['status'] == 'private',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.productBloc.filter['status'] = 'private';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context)
        .translate("publish"),),
                    selected:
                    widget.productBloc.filter.containsKey('status') &&
                        widget.productBloc.filter['status'] == 'publish',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.productBloc.filter['status'] = 'publish';
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          Divider(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                //"Order By".toUpperCase(),
                AppLocalizations.of(context)
                    .translate("order_by"),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context)
        .translate("date"),),
                    selected:
                    widget.productBloc.filter.containsKey('orderby') &&
                        widget.productBloc.filter['orderby'] == 'date',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.productBloc.filter['orderby'] = 'date';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context)
                        .translate("id"),),
                    selected:
                    widget.productBloc.filter.containsKey('orderby') &&
                        widget.productBloc.filter['orderby'] == 'id',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.productBloc.filter['orderby'] = 'id';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context)
        .translate("title"),),
                    selected:
                    widget.productBloc.filter.containsKey('orderby') &&
                        widget.productBloc.filter['orderby'] == 'title',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.productBloc.filter['orderby'] = 'title';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context)
        .translate("slug"),),
                    selected:
                    widget.productBloc.filter.containsKey('orderby') &&
                        widget.productBloc.filter['orderby'] == 'slug',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.productBloc.filter['orderby'] = 'slug';
                      });
                    },
                  )
                ],
              ),
            ],
          ),
          Divider(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                //"Type".toUpperCase(),
                AppLocalizations.of(context)
                    .translate("type"),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context)
        .translate("any"),),
                    selected: widget.productBloc.filter.containsKey('type') &&
                        widget.productBloc.filter['type'] == 'any',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.productBloc.filter['type'] = 'any';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context)
                        .translate("simple"),),
                    selected: widget.productBloc.filter.containsKey('type') &&
                        widget.productBloc.filter['type'] == 'simple',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.productBloc.filter['type'] = 'simple';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context)
        .translate("grouped"),),
                    selected: widget.productBloc.filter.containsKey('type') &&
                        widget.productBloc.filter['type'] == 'grouped',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.productBloc.filter['type'] = 'grouped';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context)
        .translate("external"),),
                    selected: widget.productBloc.filter.containsKey('type') &&
                        widget.productBloc.filter['type'] == 'external',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.productBloc.filter['type'] = 'external';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context)
        .translate("variable"),),
                    selected: widget.productBloc.filter.containsKey('type') &&
                        widget.productBloc.filter['type'] == 'variable',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.productBloc.filter['type'] = 'variable';
                      });
                    },
                  )
                ],
              ),
            ],
          ),
          Divider(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                //"Stock Status".toUpperCase(),
                AppLocalizations.of(context)
                    .translate("stock_status"),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context)
        .translate("any"),),
                    selected: widget.productBloc.filter
                        .containsKey('stockStatus') &&
                        widget.productBloc.filter['stockStatus'] == 'any',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.productBloc.filter['stockStatus'] = 'any';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context)
        .translate("in_stock"),),
                    selected: widget.productBloc.filter
                        .containsKey('stockStatus') &&
                        widget.productBloc.filter['stockStatus'] == 'instock',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.productBloc.filter['stockStatus'] = 'instock';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context)
        .translate("out_of_stock"),),
                    selected: widget.productBloc.filter
                        .containsKey('stockStatus') &&
                        widget.productBloc.filter['stockStatus'] ==
                            'outofstock',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.productBloc.filter['stockStatus'] =
                        'outofstock';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context)
        .translate("on_back_order"),),
                    selected: widget.productBloc.filter
                        .containsKey('stockStatus') &&
                        widget.productBloc.filter['stockStatus'] ==
                            'onbackorder',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.productBloc.filter['stockStatus'] =
                        'onbackorder';
                      });
                    },
                  )
                ],
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                    onPressed: () async {
                      widget.productBloc.filter.clear();
                      setState(() {});
                    },
                    child: Text(AppLocalizations.of(context)
                        .translate("clear_all"),)),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        foregroundColor: Theme.of(context).colorScheme.onSecondary),
                    onPressed: () async {
                      widget.productBloc.fetchProducts();
                      Navigator.of(context).pop();
                    }, child: Text(AppLocalizations.of(context)
                    .translate("apply"),)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
