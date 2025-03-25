import 'package:flutter/material.dart';
import 'package:admin/src/blocs/ordernotes/ordernotes_bloc.dart';
import 'package:admin/src/models/order_note/order_notes_model.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'add_ordernotes.dart';
import 'filter_ordernotes.dart';
import 'ordernotes_detail.dart';
import 'package:html/dom.dart' as dom;

class OrderNotesList extends StatefulWidget {

  OrderNotesBloc orderNotesBloc = OrderNotesBloc();
  final String id;

  OrderNotesList({Key? key, required this.id}) : super(key: key);


  @override
  _OrderNotesListState createState() => _OrderNotesListState();
}

class _OrderNotesListState extends State<OrderNotesList> {

  ScrollController _scrollController = new ScrollController();
  Widget appBarTitle = new Text("Order Notes");
  bool _hideSearch = true;
  var formatter1 = new DateFormat('dd-MMM-yy hh:mm a');

  @override
  void initState(){
    super.initState();
    widget.orderNotesBloc.id = widget.id;
    widget.orderNotesBloc.fetchAllOrderNotes();
  }

  @override
   void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("order_notes"),),
        actions: _hideSearch
            ? <Widget>[
       /*   IconButton(
            icon: new Icon(Icons.search),
            onPressed: () {
              
              setState(() {
                _hideSearch = false;
                this.appBarTitle = new TextField(
                  controller: TextEditingController()..text = bloc.search,
                  onChanged: (text) {
                    bloc.search = text;
                    bloc.fetchAllOrderNotes();
                  },
                  style: new TextStyle(
                    color: Colors.white,
                  ),
                  decoration: new InputDecoration(
                  border:InputBorder.none,
                      prefixIcon:
                      new Icon(Icons.search, color: Colors.white),
                      hintText: "Search...",
                      hintStyle: new TextStyle(color: Colors.white)),
                );
              });
            },
          ),*/

         IconButton(
            icon: Icon(
              Icons.tune,
              semanticLabel: 'filter',
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<DismissDialogAction>(
                builder: (BuildContext context) => FilterOrderNotes(),
                fullscreenDialog: true,
              ));
            },
          ),

          IconButton(
            icon: Icon(
              Icons.add,
              semanticLabel: 'add',
            ),
            onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddOrderNotes(id: widget.id)),
              );
            },
          ),
        ]
            : <Widget>[
          IconButton(
            icon: new Icon(Icons.close),
            onPressed: () {
              setState(() {
                _hideSearch = true;
                this.appBarTitle = new Text(AppLocalizations.of(context).translate("order_notes"),);
              });
            },
          ),
        ],
      ),


      body: StreamBuilder(
          stream:  widget.orderNotesBloc.allOrderNotes,
          builder: (context, AsyncSnapshot<OrderNotesModel> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return buildList(snapshot);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }


  Widget buildListTile(BuildContext context, OrderNote item) {
    return MergeSemantics(
      child: Card(
          elevation: 0.5,
          margin: EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          child: ListTile(
              onTap: () => openDetail(item, widget.id),
              title: Container(
                child: Html(
                  data: item.note,
                  onLinkTap: (String? url, RenderContext renderContext, Map<String, String> attributes, dom.Element? element) async {
                    if(url != null) {
                      if (url.contains('https://wa.me')) {
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      } else launch(url);
                    }
                  },
                ),//Text(parseHtmlString(snapshot.data[index].note))
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(formatter1.format(item.dateCreated)),
                  ],
                ),
              ))),
    );
  }

  Widget buildList(AsyncSnapshot<OrderNotesModel> snapshot) {

    Iterable<Widget> listTiles = snapshot.data!.ordernotes.map<Widget>((OrderNote item) => buildListTile(context, item));
    listTiles = ListTile.divideTiles(context: context, tiles: listTiles);

    return Scrollbar(
      child: ListView(
        //padding: EdgeInsets.symmetric(vertical: 8.0),
        children: listTiles.toList(),
      ),
    );
  }

  openDetail(OrderNote ordernotes,id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderNoteDetail(ordernotes:ordernotes, id:id)),
    );
  }
}


