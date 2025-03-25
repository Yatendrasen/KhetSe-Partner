import 'package:flutter/material.dart';
import 'package:admin/src/blocs/ordernotes/ordernotes_bloc.dart';
import 'package:admin/src/models/order_note/order_notes_model.dart';
import 'package:admin/src/ui/language/app_localizations.dart';

class OrderNoteDetail extends StatefulWidget {
  OrderNotesBloc orderNotesBloc = OrderNotesBloc();
  final String id;
  final OrderNote ordernotes;

  OrderNoteDetail({Key? key, required this.ordernotes, required this.id}) ;
  @override
  _OrderNoteDetailState createState() => _OrderNoteDetailState();
}

class _OrderNoteDetailState extends State<OrderNoteDetail> {

 @override
 void initState(){
   super.initState();
   widget.orderNotesBloc.id = widget.id;
 }

 @override
 void dispose() {
   super.dispose();
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("order_notes_detail"),),
        actions: <Widget>[

          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                widget.orderNotesBloc.deleteOrderNotes(widget.ordernotes, widget.id);
              }),
        ],
      ),
     body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        children: ListTile.divideTiles(

          context: context,
          tiles: [
          ListTile(
              title: Text(AppLocalizations.of(context).translate("id"),),
              subtitle: Text(widget.ordernotes.id.toString()),
            ),
          /* ListTile(
              title: Text('Author'),
              subtitle: Text(ordernotes.author),
            ),*/
            ListTile(
              title: Text(AppLocalizations.of(context).translate("note"),),
              subtitle: Text(widget.ordernotes.note),
            ),
          ],
        ).toList(),
      ),
    );
  }
}

