import 'package:admin/src/ui/products/buttons/buttons.dart';
import 'package:flutter/material.dart';
import 'package:admin/src/blocs/ordernotes/ordernotes_bloc.dart';
import 'package:admin/src/models/order_note/order_notes_model.dart';
import 'package:admin/src/ui/language/app_localizations.dart';


class AddOrderNotes extends StatefulWidget {
  OrderNotesBloc orderNotesBloc = OrderNotesBloc();
  final String id;

  AddOrderNotes({Key? key, required this.id}) : super(key: key);
  
  @override
  _AddOrderNotesState createState() => _AddOrderNotesState();
}

class _AddOrderNotesState extends State<AddOrderNotes> {
  
  final _formKey = GlobalKey<FormState>();
  final orderNote = OrderNote.fromJson({});

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
        title: Text(AppLocalizations.of(context).translate("add_order_note"),),
      ),

      body: SafeArea(child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: <Widget>[
          Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                /*  SizedBox(height: 16),
                    TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Id',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter id';
                      }
                    },
                    onSaved: (val) =>
                        setState(() => ordernote.id ),
                  ),
                  SizedBox(height: 16),
                    TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Author',
                    ),
                    onSaved: (val) =>
                        setState(() => ordernote.author = val),
                  ),*/

                  SizedBox(height: 16),
                    TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).translate("note"),

                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter note';
                      }
                    },
                    onSaved: (val) {
                      if(val != null) {
                        setState(() => orderNote.note = val); 
                      }
                    },
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: AccentButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            widget.orderNotesBloc.addOrderNotes(orderNote);
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
