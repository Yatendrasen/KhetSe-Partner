import 'package:flutter/material.dart';
import 'package:admin/src/models/refund/refund_model.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:admin/src/ui/refunds/add_refund.dart'hide DismissDialogAction;
import 'package:admin/src/ui/refunds/filter_refund.dart';
import 'package:admin/src/ui/refunds/refund_detail.dart';
import '../../blocs/refunds/refund_bloc.dart';

class RefundList extends StatefulWidget {
  RefundsBloc refundsBloc = RefundsBloc();
  final String id;

  RefundList({Key? key, required this.id}) : super(key: key);

  @override
  _RefundListState createState() => _RefundListState();
}

class _RefundListState extends State<RefundList> {
  Widget appBarTitle = demo();
  bool _hideSearch = true;

  @override
  void initState() {
    super.initState();
    widget.refundsBloc.id = widget.id;
    widget.refundsBloc.fetchRefunds();

  }

/*  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        actions: _hideSearch
            ? <Widget>[
                IconButton(
                  icon: new Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _hideSearch = false;
                      this.appBarTitle = new TextField(
                        controller: TextEditingController()..text =  widget.refundsBloc.search,
                        onChanged: (text) {
                          widget.refundsBloc.search = text;
                         //  widget.refundsBloc.fetchRefunds();
                        },
                        style: new TextStyle(
                          color: Colors.white,
                        ),
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                            prefixIcon:
                                new Icon(Icons.search, color: Colors.white),
                            hintText: "Search...",
                            hintStyle: new TextStyle(color: Colors.white)),
                      );
                    });
                  },
                ),

                IconButton(
                  icon: Icon(
                    Icons.tune,
                    semanticLabel: 'filter',
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute<DismissDialogAction>(
                          builder: (BuildContext context) => FilterRefund(),
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
                MaterialPageRoute(
                    builder: (context) => AddRefund(id: widget.id)),
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
                      this.appBarTitle = Text(AppLocalizations.of(context).translate("refunds"),);
                    });
                  },
                ),
              ],
      ),
      //drawer: MyDrawer(),
      body: StreamBuilder(
          stream:  widget.refundsBloc.allRefunds,
          builder: (context, AsyncSnapshot<RefundsModel> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return buildList(snapshot);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  Widget buildList(AsyncSnapshot<RefundsModel> snapshot) {
    Iterable<Widget> listTiles = snapshot.data!.refunds
        .map<Widget>((Refund item) => buildListTile(context, item));
    listTiles = ListTile.divideTiles(context: context, tiles: listTiles);

    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      children: listTiles.toList(),
    );
  }

  Widget buildListTile(BuildContext context, Refund item) {
    return MergeSemantics(
      child: ListTile(
        onTap: () => openDetail(item, widget.id),
        title: Text(item.id.toString()),
        subtitle: item.amount == '' ? null : Text(item.amount),
      ),
    );
  }

  openDetail(Refund refund, String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RefundDetail(refund: refund, id: id)),
    );
  }


  static Widget demo() {
    return  Builder(
        builder: (context) {
          return new Text(AppLocalizations.of(context).translate("refunds"));
        }
    );
  }
}
