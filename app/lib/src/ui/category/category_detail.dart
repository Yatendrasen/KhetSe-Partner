import 'package:admin/src/blocs/category/category_bloc.dart';
import 'package:flutter/material.dart';

import 'package:admin/src/models/category/category_model.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'edit_category.dart';

class CategoryDetail extends StatefulWidget {
  final Category category;
  CategoryBloc categoriesBloc = CategoryBloc();
   CategoryDetail({Key? key, required this.category}) : super(key: key);

  @override
  _CategoryDetailState createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("category_detail")),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditCategory(category: widget.category)),
                );
              }),
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                widget.categoriesBloc.deleteItem(widget.category);
              }),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        children: ListTile.divideTiles(
          //          <-- ListTile.divideTiles
           context: context,
          tiles: [
            ListTile(
              title: Text(AppLocalizations.of(context).translate("id")),
              subtitle: Text(widget.category.id.toString()),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context).translate("name")),
              subtitle: Text(widget.category.name),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context).translate("description")),
              subtitle: Text(widget.category.description),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context).translate("count")),
              subtitle: Text(widget.category.count.toString()),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context).translate("parent")),
              subtitle: Text(widget.category.parent.toString()),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context).translate("menu_order")),
              subtitle: Text(widget.category.menuOrder.toString()),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context).translate("display")),
              subtitle: Text(widget.category.display),
            ),
          ],
        ).toList(),
      ),
    );
  }
}
