import 'package:admin/src/ui/products/buttons/buttons.dart';
import 'package:flutter/material.dart';
import 'package:admin/src/blocs/ordernotes/ordernotes_bloc.dart';
import 'package:admin/src/ui/language/app_localizations.dart';

enum DismissDialogAction {
  cancel,
  discard,
  save,
}

class FilterOrderNotes extends StatefulWidget {
  @override
  _FilterOrderNotesState createState() => _FilterOrderNotesState();
}

class _FilterOrderNotesState extends State<FilterOrderNotes> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("order_notes"),),
        actions: <Widget>[
          TextButton(
            child: Text(AppLocalizations.of(context).translate("reset"),
              style: Theme.of(context).primaryTextTheme.titleMedium,),
            onPressed: () {
              bloc.reset();
              bloc.fetchAllOrderNotes();
              Navigator.pop(context, DismissDialogAction.save);
            },
          ),
        ],
      ),
      body: Form(
        child: ListView(padding: const EdgeInsets.all(16.0), children: <Widget>[
         /* Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 16.0),
                TextField(
                  controller: TextEditingController()..text = bloc.search,
                  onChanged: (text) {
                    bloc.search = text;
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Search category',
                    hintText: 'Type category name to search',
                  ),
                  maxLines: 1,
                ),
              ]),*/
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //const SizedBox(height: 16.0),
             /* Text('Context', style: theme.textTheme.titleSmall),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Radio<String>(
                    value: 'view',
                    groupValue: bloc.context,
                    onChanged: handleContextValueChanged,
                  ),
                  new Text(
                    'View',
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  Radio<String>(
                    value: 'edit',
                    groupValue: bloc.context,
                    onChanged: handleContextValueChanged,
                  ),
                  new Text(
                    'Edit',
                    style: new TextStyle(fontSize: 16.0),
                  ),
                ],
              ),*/

              const SizedBox(height: 16.0),
              Text( AppLocalizations.of(context).translate("type"), style: theme.textTheme.titleSmall),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Radio<String>(
                    value: 'any',
                    groupValue: bloc.type,
                    onChanged: handleTypeValueChanged,
                  ),
                  new Text(
                    AppLocalizations.of(context).translate("any"),
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  Radio<String>(
                    value: 'customer',
                    groupValue: bloc.type,
                    onChanged: handleTypeValueChanged,
                  ),
                  new Text(
                    AppLocalizations.of(context).translate("customer"),
                    style: new TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Radio<String>(
                    value: 'internal',
                    groupValue: bloc.type,
                    onChanged: handleTypeValueChanged,
                  ),
                  new Text(
                    AppLocalizations.of(context).translate("internal"),
                    style: new TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ],
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: AccentButton(
                    onPressed: () {

                      bloc.fetchAllOrderNotes();
                      Navigator.pop(context, DismissDialogAction.save);
                    },
                    text: AppLocalizations.of(context).translate("submit"),
                  ),
                ),
              ),
            ],
          ),

          /*
           Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: AccentButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            bloc.addOrderNotes(ordernote);
                          }
                          Navigator.pop(context);
                        },
                        text: AppLocalizations.of(context).translate("submit"),
                      ),
                    ),
                  ),*/
        ]),
      ),
    );
  }

 /* void handleContextValueChanged(String value) {
    setState(() {
      bloc.context = value;
    });
  }*/

  void handleTypeValueChanged(String? value) {
    if(value != null) {
      setState(() {
        bloc.type = value;
      });
    }
  }
}

