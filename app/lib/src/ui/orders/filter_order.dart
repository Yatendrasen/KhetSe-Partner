import 'package:admin/src/blocs/orders/orders_bloc.dart';
import 'package:admin/src/blocs/products/vendor_bloc.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:flutter/material.dart';

class FilterOrder extends StatefulWidget {
  final OrdersBloc ordersBloc;

  const FilterOrder({Key? key, required this.ordersBloc}) : super(key: key);
  @override
  _FilterOrderState createState() => _FilterOrderState();
}

class _FilterOrderState extends State<FilterOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)
          .translate('filter_orders'),),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)
                    .translate("status").toUpperCase(),
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
                    selected:
                    widget.ordersBloc.filter.containsKey('status') &&
                        widget.ordersBloc.filter['status'] == 'any',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.ordersBloc.filter['status'] = 'any';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context)
                        .translate("pending"),),
                    selected:
                    widget.ordersBloc.filter.containsKey('status') &&
                        widget.ordersBloc.filter['status'] == 'pending',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.ordersBloc.filter['status'] = 'pending';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context)
                        .translate("processing"),),
                    selected:
                    widget.ordersBloc.filter.containsKey('status') &&
                        widget.ordersBloc.filter['status'] == 'processing',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.ordersBloc.filter['status'] = 'processing';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context)
                        .translate("on_hold"),),
                    selected:
                    widget.ordersBloc.filter.containsKey('status') &&
                        widget.ordersBloc.filter['status'] == 'on-hold',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.ordersBloc.filter['status'] = 'on-hold';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context)
                        .translate("completed"),),
                    selected:
                    widget.ordersBloc.filter.containsKey('status') &&
                        widget.ordersBloc.filter['status'] == 'completed',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.ordersBloc.filter['status'] = 'completed';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context)
                        .translate("cancelled"),),
                    selected:
                    widget.ordersBloc.filter.containsKey('status') &&
                        widget.ordersBloc.filter['status'] == 'cancelled',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.ordersBloc.filter['status'] = 'cancelled';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context)
                        .translate("refunded"),),
                    selected:
                    widget.ordersBloc.filter.containsKey('status') &&
                        widget.ordersBloc.filter['status'] == 'refunded',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.ordersBloc.filter['status'] = 'refunded';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context)
                        .translate("failed"),),
                    selected:
                    widget.ordersBloc.filter.containsKey('status') &&
                        widget.ordersBloc.filter['status'] == 'failed',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.ordersBloc.filter['status'] = 'failed';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context)
                        .translate("trash"),),
                    selected:
                    widget.ordersBloc.filter.containsKey('status') &&
                        widget.ordersBloc.filter['status'] == 'trash',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.ordersBloc.filter['status'] = 'trash';
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
                AppLocalizations.of(context)
                    .translate("order").toUpperCase(),
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
                    widget.ordersBloc.filter.containsKey('order') &&
                        widget.ordersBloc.filter['order'] == 'asc',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.ordersBloc.filter['order'] = 'asc';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context)
                        .translate("descending"),),
                    selected:
                    widget.ordersBloc.filter.containsKey('order') &&
                        widget.ordersBloc.filter['order'] == 'desc',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.ordersBloc.filter['order'] = 'desc';
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
                AppLocalizations.of(context)
                    .translate("order_by").toUpperCase(),
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
                    widget.ordersBloc.filter.containsKey('orderby') &&
                        widget.ordersBloc.filter['orderby'] == 'date',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.ordersBloc.filter['orderby'] = 'date';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context)
                        .translate("id"),),
                    selected:
                    widget.ordersBloc.filter.containsKey('orderby') &&
                        widget.ordersBloc.filter['orderby'] == 'id',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.ordersBloc.filter['orderby'] = 'id';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context)
                        .translate("title"),),
                    selected:
                    widget.ordersBloc.filter.containsKey('orderby') &&
                        widget.ordersBloc.filter['orderby'] == 'title',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.ordersBloc.filter['orderby'] = 'title';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context)
                        .translate("slug"),),
                    selected:
                    widget.ordersBloc.filter.containsKey('orderby') &&
                        widget.ordersBloc.filter['orderby'] == 'slug',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.ordersBloc.filter['orderby'] = 'slug';
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
                      widget.ordersBloc.filter.clear();
                      setState(() {});
                    },
                    child: Text(AppLocalizations.of(context)
                        .translate("clear_all"))),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        foregroundColor: Theme.of(context).colorScheme.onSecondary),
                    onPressed: () async {
                      widget.ordersBloc.fetchItems();
                      Navigator.of(context).pop();
                    }, child: Text(AppLocalizations.of(context)
                    .translate("apply"))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
