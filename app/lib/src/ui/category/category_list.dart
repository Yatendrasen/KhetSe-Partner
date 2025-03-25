import 'package:admin/src/blocs/category/category_bloc.dart';
import 'package:admin/src/ui/category/search_category.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import '../drawer.dart';
import 'package:admin/src/models/category/category_model.dart';
import 'add_category.dart';
import 'filter_category.dart';
import 'category_detail.dart';
import 'package:html/parser.dart';

class CategoryList extends StatefulWidget {

  CategoryBloc categoriesBloc = CategoryBloc();
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {

  ScrollController _scrollController = new ScrollController();
  Widget appBarTitle = Container();

  @override
  void initState() {
    super.initState();
    widget.categoriesBloc.fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    Color? primaryIconThemeColor = Theme.of(context).primaryIconTheme.color;
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        actions: <Widget>[
          IconButton(
            icon: new Icon(CupertinoIcons.search),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => SearchCategory()
                  ));
            },
          ),
          IconButton(
            icon: Icon(
              Icons.tune,
              semanticLabel: 'filter',
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<DismissDialogAction>(
                builder: (BuildContext context) => FilterCategory(categoriesBloc: widget.categoriesBloc),
                fullscreenDialog: true,
              ));
            },
          ),
        ]
      ),
      //drawer: MyDrawer(),
      body: StreamBuilder(
          stream: widget.categoriesBloc.results,
          builder: (context, AsyncSnapshot<List<Category>> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return buildList(snapshot);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddCategory(categoriesBloc: widget.categoriesBloc)),
          );
        },
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }

  Widget buildListTile(BuildContext context, Category item) {
    return MergeSemantics(
      child: Center(
        child: ListTile(
          onTap: () => openDetail(item),
          isThreeLine: item.description != '',
          leading: SizedBox(
            height: 40,
            width: 40,
            child: CachedNetworkImage(
              imageUrl: item.image.src.isNotEmpty ? item.image.src : '',
              imageBuilder: (context, imageProvider) => Card(
                elevation: 0.0,
                margin: EdgeInsets.all(0.0),
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
              ),
              placeholder: (context, url) => Container(
                width: 40,
                height: 40,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              errorWidget: (context, url, error) => Container(
                width: 40,
                height: 40,
                color: Colors.black12,
              ),
            ),
          ),
          title: Text(_parseHtmlString(item.name)),
          subtitle: item.description == '' ? null : Text(_parseHtmlString(item.description)),
        ),
      ),
    );
  }

  Widget buildList(AsyncSnapshot<List<Category>> snapshot) {
    Iterable<Widget> listTiles = snapshot.data!.map<Widget>((Category item) => buildListTile(context, item));
    listTiles = ListTile.divideTiles(context: context, tiles: listTiles);

    return Scrollbar(
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        children: listTiles.toList(),
      ),
    );
  }

  openDetail(Category category) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CategoryDetail(category: category)),
    );
  }
}

String _parseHtmlString(String htmlString) {
  var document = parse(htmlString);
  String parsedString = parse(document.body!.text).documentElement!.text;
  return parsedString;
}