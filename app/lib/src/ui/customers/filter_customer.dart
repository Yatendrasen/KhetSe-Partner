import 'package:admin/src/blocs/customers/customer_bloc.dart';
import 'package:admin/src/ui/products/buttons/buttons.dart';
import 'package:flutter/material.dart';

import 'package:admin/src/ui/language/app_localizations.dart';

enum DismissDialogAction {
  cancel,
  discard,
  save,
}

class FilterCustomer extends StatefulWidget {
  final CustomerBloc customersBloc;
  FilterCustomer({Key? key, required this.customersBloc});
  @override
  _FilterCustomerState createState() => _FilterCustomerState();
}

class _FilterCustomerState extends State<FilterCustomer> {

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate("filter")),
        ),
        body: Form(
          child: ListView(padding: const EdgeInsets.all(16.0), children: <Widget>[
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: TextEditingController()..text = widget.customersBloc.filter['search'] ?? '',
                    onChanged: (text) {
                      widget.customersBloc.filter['search'] = text;
                    },
                    decoration:  InputDecoration(
                      border: InputBorder.none,
                      labelText:  AppLocalizations.of(context).translate("search_customer"),
                      hintText: AppLocalizations.of(context).translate("type_customer_name_to_search"),
                    ),
                    maxLines: 1,
                  ),
                ]),

            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 16.0),
                  TextField(
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    controller: TextEditingController()..text = widget.customersBloc.filter['email'] ?? '',
                    onChanged: (text) {
                      widget.customersBloc.filter['email'] = text;
                    },
                    decoration:  InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: AppLocalizations.of(context).translate("email"),
                      hintText:  AppLocalizations.of(context).translate("type_email"),
                    ),
                    maxLines: 1,
                  ),
                ]),

            Divider(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 16.0),
                Text(AppLocalizations.of(context).translate("order").toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium,),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ChoiceChip(
                      //shape: RoundedRectangleBorder(),
                      label: Text(AppLocalizations.of(context).translate("ascending")),
                      selected: widget.customersBloc.filter.containsKey('order') && widget.customersBloc.filter['order'] == 'asc',
                      onSelected: (bool selected) {
                        setState(() {
                          widget.customersBloc.filter['order'] = 'asc';
                        });
                      },
                    ),
                    ChoiceChip(
                      //shape: RoundedRectangleBorder(),
                      label: Text(AppLocalizations.of(context).translate("descending")),
                      selected: widget.customersBloc.filter['order'] == 'desc',
                      onSelected: (bool selected) {
                        setState(() {
                          widget.customersBloc.filter['order'] = 'desc';
                        });
                      },
                    ),
                  ],
                ),
                Divider(height: 24),
                Text(AppLocalizations.of(context).translate("order_by").toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium,),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ChoiceChip(
                      //shape: RoundedRectangleBorder(),
                      label: Text(AppLocalizations.of(context).translate("id")),
                      selected: widget.customersBloc.filter.containsKey('orderby') && widget.customersBloc.filter['orderby'] == 'id',
                      onSelected: (bool selected) {
                        setState(() {
                          widget.customersBloc.filter['orderby'] = 'id';
                        });
                      },
                    ),
                    ChoiceChip(
                      //shape: RoundedRectangleBorder(),
                      label: Text(AppLocalizations.of(context).translate("include")),
                      selected: widget.customersBloc.filter.containsKey('orderby') && widget.customersBloc.filter['orderby'] == 'include',
                      onSelected: (bool selected) {
                        setState(() {
                          widget.customersBloc.filter['orderby'] = 'include';
                        });
                      },
                    ),
                    ChoiceChip(
                      //shape: RoundedRectangleBorder(),
                      label: Text(AppLocalizations.of(context).translate("name")),
                      selected: widget.customersBloc.filter.containsKey('orderby') && widget.customersBloc.filter['orderby'] == 'name',
                      onSelected: (bool selected) {
                        setState(() {
                          widget.customersBloc.filter['orderby'] = 'name';
                        });
                      },
                    ),
                    ChoiceChip(
                      //shape: RoundedRectangleBorder(),
                      label: Text(AppLocalizations.of(context).translate("registered_date")),
                      selected: widget.customersBloc.filter.containsKey('orderby') && widget.customersBloc.filter['orderby'] == 'registered_date',
                      onSelected: (bool selected) {
                        setState(() {
                          widget.customersBloc.filter['orderby'] = 'registered_date';
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            Divider(height: 24),
            Text(AppLocalizations.of(context).translate("role").toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium,),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ChoiceChip(
                  //shape: RoundedRectangleBorder(),
                  label: Text(AppLocalizations.of(context).translate("all")),
                  selected: widget.customersBloc.filter.containsKey('role') && widget.customersBloc.filter['role'] == 'all',
                  onSelected: (bool selected) {
                    setState(() {
                      widget.customersBloc.filter['role'] = 'all';
                    });
                  },
                ),
                ChoiceChip(
                  //shape: RoundedRectangleBorder(),
                  label: Text(AppLocalizations.of(context).translate("administrator")),
                  selected: widget.customersBloc.filter.containsKey('role') && widget.customersBloc.filter['role'] == 'administrator',
                  onSelected: (bool selected) {
                    setState(() {
                      widget.customersBloc.filter['role'] = 'administrator';
                    });
                  },
                ),
                ChoiceChip(
                  //shape: RoundedRectangleBorder(),
                  label: Text(AppLocalizations.of(context).translate("editor")),
                  selected: widget.customersBloc.filter.containsKey('role') && widget.customersBloc.filter['role'] == 'editor',
                  onSelected: (bool selected) {
                    setState(() {
                      widget.customersBloc.filter['role'] = 'editor';
                    });
                  },
                ),
                ChoiceChip(
                  //shape: RoundedRectangleBorder(),
                  label: Text(AppLocalizations.of(context).translate("author")),
                  selected: widget.customersBloc.filter.containsKey('role') && widget.customersBloc.filter['role'] == 'author',
                  onSelected: (bool selected) {
                    setState(() {
                      widget.customersBloc.filter['role'] = 'author';
                    });
                  },
                ),
                ChoiceChip(
                  //shape: RoundedRectangleBorder(),
                  label: Text(AppLocalizations.of(context).translate("contributor")),
                  selected: widget.customersBloc.filter.containsKey('role') && widget.customersBloc.filter['role'] == 'contributor',
                  onSelected: (bool selected) {
                    setState(() {
                      widget.customersBloc.filter['role'] = 'contributor';
                    });
                  },
                ),
                ChoiceChip(
                  //shape: RoundedRectangleBorder(),
                  label: Text(AppLocalizations.of(context).translate("subscriber")),
                  selected: widget.customersBloc.filter.containsKey('role') && widget.customersBloc.filter['role'] == 'subscriber',
                  onSelected: (bool selected) {
                    setState(() {
                      widget.customersBloc.filter['role'] = 'subscriber';
                    });
                  },
                ),
                ChoiceChip(
                  //shape: RoundedRectangleBorder(),
                  label: Text(AppLocalizations.of(context).translate("customer")),
                  selected: widget.customersBloc.filter.containsKey('role') && widget.customersBloc.filter['role'] == 'customer',
                  onSelected: (bool selected) {
                    setState(() {
                      widget.customersBloc.filter['role'] = 'customer';
                    });
                  },
                ),
                ChoiceChip(
                  //shape: RoundedRectangleBorder(),
                  label: Text(AppLocalizations.of(context).translate("shop_manager")),
                  selected: widget.customersBloc.filter.containsKey('role') && widget.customersBloc.filter['role'] == 'shop_manager',
                  onSelected: (bool selected) {
                    setState(() {
                      widget.customersBloc.filter['role'] = 'shop_manager';
                    });
                  },
                ),
              ],
            ),
          ]),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: () async {
                        widget.customersBloc.filter.clear();
                        widget.customersBloc.fetchItems();
                        setState(() {});
                      },
                      child: Text('Clear All')),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          foregroundColor: Theme.of(context).colorScheme.onSecondary),
                      onPressed: () async {
                        widget.customersBloc.fetchItems();
                        Navigator.of(context).pop();
                      }, child: Text('Apply')),
                )
              ],
            ),
          ),
        )
    );
  }
}


