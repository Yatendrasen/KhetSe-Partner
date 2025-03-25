import 'package:admin/src/blocs/category/category_bloc.dart';
import 'package:admin/src/models/app_state_model.dart';
import 'package:admin/src/models/product/product_model.dart';
import 'package:admin/src/models/product/vendor_product_model.dart';
import 'package:admin/src/ui/products/buttons/buttons.dart';
import 'package:admin/src/ui/products/products/select_categories.dart';
import 'package:flutter/material.dart';

import 'package:admin/src/models/category/category_model.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:scoped_model/scoped_model.dart';

import 'select_categories.dart';

class EditCategory extends StatefulWidget {
  final Category category;
  CategoryBloc categoriesBloc = CategoryBloc();
   EditCategory({Key? key, required this.category});

  @override
  _EditCategoryState createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.categoriesBloc.dispose();
    super.dispose();
  }

  void _handleDisplayTypeValueChanged(String? value) {
    if(value != null) {
      setState(() {
        widget.category.display = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("edit_category")),
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
                    initialValue: widget.category.name,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).translate("category_name"),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context).translate("please_enter_category_name");
                      }
                    },
                      onSaved: (val) {
                        if(val != null) {
                          setState(() => widget.category.name = val);
                        }
                      }
                  ),
                  SizedBox(height: 16),
                    TextFormField(
                    keyboardType: TextInputType.multiline,
                    initialValue: widget.category.description,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).translate("category_description"),
                    ),
                      onSaved: (val) {
                        if(val != null) {
                          setState(() => widget.category.description = val);
                        }
                      }
                  ),
                  SizedBox(height: 16),
                    TextFormField(
                    initialValue: widget.category.slug,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).translate("category_slug"),
                    ),
                    /*validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context).translate("please_enter_category_slug");
                      }
                    },*/
                    onSaved: (val) {
                      if(val != null) {
                        setState(() => widget.category.slug = val);
                      }
                    }
                  ),
                  const SizedBox(height: 16.0),
                  Text(AppLocalizations.of(context).translate("display_type")),
                  Row(
                    children: <Widget>[
                      Radio<String>(
                        value: 'default',
                        groupValue: widget.category.display,
                        onChanged: _handleDisplayTypeValueChanged,
                      ),
                      new Text(
                        AppLocalizations.of(context).translate("default"),
                        style: new TextStyle(fontSize: 16.0),
                      ),
                      Radio<String>(
                        value: 'products',
                        groupValue: widget.category.display,
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
                        groupValue: widget.category.display,
                        onChanged: _handleDisplayTypeValueChanged,
                      ),
                      new Text(
                        AppLocalizations.of(context).translate("subcategories"),
                        style: new TextStyle(fontSize: 16.0),
                      ),
                      Radio<String>(
                        value: 'both',
                        groupValue: widget.category.display,
                        onChanged: _handleDisplayTypeValueChanged,
                      ),
                      new Text(
                        AppLocalizations.of(context).translate("both"),
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  ScopedModelDescendant<AppStateModel>(
                  builder: (context, child, model) {
                    if (model.categories.isNotEmpty) {
                      Text? name = model.categories.any((element) => widget.category.parent == element.id) ? Text(model.categories.firstWhere((element) => widget.category.parent == element.id).name) : null;
                        return ListTile(
                          trailing: Icon(Icons.arrow_right_rounded),
                          contentPadding: EdgeInsets.fromLTRB(0, 16, 0, 16),
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
                              setState(() { widget.category.parent = category.id; });
                            }
                          },
                        );
                      } else return Container();
                    }
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: SizedBox(
                      width: double.maxFinite,
                      child: AccentButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            widget.categoriesBloc.editItem(widget.category);
                          }
                          Navigator.pop(context);
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
}
