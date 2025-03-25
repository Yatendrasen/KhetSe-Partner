import 'package:admin/src/blocs/category/category_bloc.dart';
import 'package:admin/src/functions.dart';
import 'package:admin/src/ui/products/buttons/buttons.dart';
import 'package:flutter/material.dart';

import 'package:admin/src/models/category/category_model.dart';
import 'package:admin/src/ui/language/app_localizations.dart';

enum DismissDialogAction {
  cancel,
  discard,
  save,
}

class FilterCategory extends StatefulWidget {

  final CategoryBloc categoriesBloc;
  FilterCategory({Key? key, required this.categoriesBloc}) : super(key: key);
  @override
  _FilterCategoryState createState() => _FilterCategoryState();
}

class _FilterCategoryState extends State<FilterCategory> {
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
                  controller: TextEditingController()..text = widget.categoriesBloc.filter['search'] ?? '',
                  onChanged: (text) {
                    widget.categoriesBloc.filter['search'] = text;
                  },
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: AppLocalizations.of(context).translate("search_category"),
                    hintText: AppLocalizations.of(context).translate("type_category_name_to_search"),
                  ),
                  maxLines: 1,
                ),
              ]),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 16.0),
              Text(AppLocalizations.of(context).translate("order").toUpperCase(), style: theme.textTheme.titleMedium),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ChoiceChip(
                  //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context).translate("ascending")),
                    selected: widget.categoriesBloc.filter.containsKey('order') && widget.categoriesBloc.filter['order'] == 'asc',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.categoriesBloc.filter['order'] = 'asc';
                      });
                    },
                  ),
                  ChoiceChip(
                  //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context).translate("descending")),
                    selected: widget.categoriesBloc.filter['order'] == 'desc',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.categoriesBloc.filter['order'] = 'desc';
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Text(AppLocalizations.of(context).translate("order_by").toUpperCase(), style: theme.textTheme.titleMedium),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ChoiceChip(
                  //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context).translate("name")),
                    selected: widget.categoriesBloc.filter.containsKey('orderby') && widget.categoriesBloc.filter['orderby'] == 'name',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.categoriesBloc.filter['orderby'] = 'name';
                      });
                    },
                  ),
                  ChoiceChip(
                  //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context).translate("description")),
                    selected: widget.categoriesBloc.filter.containsKey('orderby') && widget.categoriesBloc.filter['orderby'] == 'description',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.categoriesBloc.filter['orderby'] = 'description';
                      });
                    },
                  ),
                  ChoiceChip(
                  //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context).translate("group")),
                    selected: widget.categoriesBloc.filter.containsKey('orderby') && widget.categoriesBloc.filter['orderby'] == 'term_group',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.categoriesBloc.filter['orderby'] = 'term_group';
                      });
                    },
                  ),
                  ChoiceChip(
                  //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context).translate("id")),
                    selected: widget.categoriesBloc.filter.containsKey('orderby') && widget.categoriesBloc.filter['orderby'] == 'id',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.categoriesBloc.filter['orderby'] = 'id';
                      });
                    },
                  ),
                  ChoiceChip(
                  //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context).translate("slug")),
                    selected: widget.categoriesBloc.filter.containsKey('orderby') && widget.categoriesBloc.filter['orderby'] == 'slug',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.categoriesBloc.filter['orderby'] = 'slug';
                      });
                    },
                  ),
                  ChoiceChip(
                  //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context).translate("count")),
                    selected: widget.categoriesBloc.filter.containsKey('orderby') && widget.categoriesBloc.filter['orderby'] == 'count',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.categoriesBloc.filter['orderby'] = 'count';
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          StreamBuilder<List<Category>>(
            stream: widget.categoriesBloc.results,
            builder: (context, snapshot) {
              return snapshot.hasData && snapshot.data != null ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 16.0),
                    new DropdownButtonFormField<String>(
                      hint: Text(AppLocalizations.of(context).translate("parent")),
                      isExpanded: true,
                      value: widget.categoriesBloc.filter.containsKey('parent') ? widget.categoriesBloc.filter['parent'] : null,
                      items: snapshot.data!.map((Category value) {
                        return new DropdownMenuItem<String>(
                          value: value.id.toString(),
                          child: new Text(parseHtmlString(value.name)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if(newValue != null) {
                          setState(() {
                            widget.categoriesBloc.filter['parent'] = newValue;
                          });
                        }
                      },
                    )
                   /* TextField(
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      controller: TextEditingController()..text = widget.categoriesBloc.parent,
                      onChanged: (text) {
                        widget.categoriesBloc.parent = text;
                      },
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Parent category',
                        hintText: 'Type parent category id',
                      ),
                      maxLines: 1,
                    ),*/
                  ]) : Container();
            }
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 16.0),
                TextField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: TextEditingController()..text = widget.categoriesBloc.filter['product'] ?? '',
                  onChanged: (text) {
                    widget.categoriesBloc.filter['product'] = text;
                  },
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: AppLocalizations.of(context).translate("product_id"),
                    hintText: AppLocalizations.of(context).translate("type_assigned_product_id"),
                  ),
                  maxLines: 1,
                ),
              ]),
          const SizedBox(height: 16.0),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(AppLocalizations.of(context).translate("hide_empty")),
            value: widget.categoriesBloc.filter['hideEmpty'] == true,
            onChanged: (bool value) {
              setState(() {
                widget.categoriesBloc.filter['hideEmpty'] = value;
              });
            },
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
                        widget.categoriesBloc.filter.clear();
                        widget.categoriesBloc.fetchItems();
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
                        widget.categoriesBloc.fetchItems();
                        Navigator.of(context).pop();
                      }, child: Text('Apply')),
                )
              ],
            ),
          ),
        )
    );
  }

  void handleOrderValueChanged(String? value) {
    if(value != null) {
      setState(() {
        widget.categoriesBloc.filter['order'] = value;
      });
    }
  }

  void handleOrderByValueChanged(String? value) {
    if(value != null) {
      setState(() {
        widget.categoriesBloc.filter['orderby'] = value;
      });
    }
  }
}
