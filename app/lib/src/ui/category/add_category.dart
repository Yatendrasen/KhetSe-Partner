import 'package:admin/src/blocs/category/category_bloc.dart';
import 'package:admin/src/models/app_state_model.dart';
import 'package:admin/src/ui/products/buttons/buttons.dart';
import 'package:admin/src/ui/category/select_categories.dart';
import 'package:flutter/material.dart';
import 'package:admin/src/models/category/category_model.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:scoped_model/scoped_model.dart';

import 'filter_category.dart';

class AddCategory extends StatefulWidget {
  final CategoryBloc categoriesBloc;
  AddCategory({Key? key, required this.categoriesBloc});
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {

  final _formKey = GlobalKey<FormState>();
  final _category = Category.fromJson({});

  @override
  void initState() {
    super.initState();
    _category.display = 'default';
  }

  @override
  void dispose() {
    widget.categoriesBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("add_category")),
      ),
      body: SafeArea(child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: <Widget>[
          Form(
            key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 16),
                    TextFormField(
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).translate("category_name"),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return  AppLocalizations.of(context).translate("please_enter_category_name");
                      }
                    },
                    onSaved: (val) {
                      if(val != null) {
                        setState(() => _category.name = val);
                      }
                    }
                  ),
                  SizedBox(height: 16),
                    TextFormField(
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).translate("category_description"),
                    ),
                      onSaved: (val) {
                        if(val != null) {
                          setState(() => _category.description = val);
                        }
                      }
                  ),
                  ScopedModelDescendant<AppStateModel>(
                      builder: (context, child, model) {
                        if (model.categories.isNotEmpty) {
                          Text? name = model.categories.any((element) => _category.parent == element.id) ? Text(model.categories.firstWhere((element) => _category.parent == element.id).name) : null;
                          return ListTile(
                            trailing: Icon(Icons.arrow_right_rounded),
                            contentPadding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                            title: Text(AppLocalizations.of(context).translate(
                                "parent_category")),
                            subtitle: name,
                            onTap: () async {
                              Category? category = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SelectParentCategories()),
                              );
                              if(category != null) {
                                setState(() { _category.parent = category.id; });
                              }
                            },
                          );
                        } else return Container();
                      }
                  ),
                    /*TextFormField(
                    keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).translate("parent_category"),
                    ),
                    onSaved: (val) {
                      if(val != null) {
                        setState(() => _category.parent = int.parse(val));
                      }
                    }
                  ),*/
                  SizedBox(height: 16),
                    TextFormField(
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).translate("category_slug"),
                    ),
                    /*validator: (value) {
                      if (value == null || value.isEmpty) {
                        return  AppLocalizations.of(context).translate("please_enter_category_slug");
                      }
                    },*/
                      onSaved: (val) {
                        if(val != null) {
                          setState(() => _category.slug = val);
                        }
                      }
                  ),
                  const SizedBox(height: 16.0),
                  Text(AppLocalizations.of(context).translate("display_type")),
                  Row(
                    children: <Widget>[
                      Radio<String>(
                        value: 'default',
                        groupValue: _category.display,
                        onChanged: _handleDisplayTypeValueChanged,
                      ),
                      new Text(
                        AppLocalizations.of(context).translate("default"),
                        style: new TextStyle(fontSize: 16.0),
                      ),
                      Radio<String>(
                        value: 'products',
                        groupValue: _category.display,
                        onChanged: _handleDisplayTypeValueChanged,
                      ),
                      new Text(
                        AppLocalizations.of(context).translate("products"),
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio<String>(
                        value: 'subcategories',
                        groupValue: _category.display,
                        onChanged: _handleDisplayTypeValueChanged,
                      ),
                      new Text(
                        AppLocalizations.of(context).translate("subcategories"),
                        style: new TextStyle(fontSize: 16.0),
                      ),
                      Radio<String>(
                        value: 'both',
                        groupValue: _category.display,
                        onChanged: _handleDisplayTypeValueChanged,
                      ),
                      new Text(
                        AppLocalizations.of(context).translate("both"),
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: SizedBox(
                      width: double.maxFinite,
                      child: AccentButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            widget.categoriesBloc.addItem(_category);
                            Navigator.pop(context, DismissDialogAction.save);
                          }
                        },
                        text: AppLocalizations.of(context).translate("submit"),
                      ),
                    ),
                  ),
                ],
              )
          )
        ],
      )),
    );
  }

  void _handleDisplayTypeValueChanged(String? value) {
    if(value != null) {
      setState(() {
        _category.display = value;
      });
    }
  }
}
