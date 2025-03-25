import 'package:admin/src/blocs/settings/settings_bloc.dart';
import 'package:admin/src/blocs/settings/settings_option_bloc.dart';
import 'package:admin/src/models/settings/settings_model.dart';
import 'package:admin/src/models/settings/settings_option_model.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';

import 'settings_options.dart';

class OptionDetail extends StatefulWidget {
  final SettingsOptionModel option;
  OptionDetail({Key? key, required this.option}) : super(key: key);
  @override
  _OptionDetailState createState() => _OptionDetailState();
}

class _OptionDetailState extends State<OptionDetail> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( AppLocalizations.of(context)
            .translate("settings"),),
      ),
      body: ListView(
        children: buildList(),
      ),
    );
  }

  List<Widget> buildList() {
    List<Widget> list = [];
    list.add(Card(
      margin: EdgeInsets.all(0.2),
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: InkWell(
        child: ListTile(
          onTap: () {

          },
          contentPadding: EdgeInsets.fromLTRB(16, 8, 0, 16),
          title: Text(_parseHtmlString(widget.option.label)),
          subtitle: widget.option.description == null || widget.option.description.isEmpty ? null : Text(_parseHtmlString(widget.option.description)),
        ),
      ),
    ));

    if(widget.option.tip != null && widget.option.tip!.isNotEmpty)
      list.add(Card(
        margin: EdgeInsets.all(0.2),
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        child: InkWell(
          child: ListTile(
            onTap: () {

            },
            contentPadding: EdgeInsets.fromLTRB(16, 8, 0, 16),
            title: Text(AppLocalizations.of(context)
                .translate("tip"),),
            subtitle: Text(_parseHtmlString(widget.option.tip!)),
          ),
        ),
      ));

    if(widget.option.value is String || widget.option.value is int)
    list.add(Card(
      margin: EdgeInsets.all(0.2),
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: InkWell(
        child: ListTile(
          onTap: () {

          },
          contentPadding: EdgeInsets.fromLTRB(16, 8, 0, 16),
          title: Text(AppLocalizations.of(context)
              .translate("Value"),),
          subtitle: Text(_parseHtmlString(widget.option.value)),
        ),
      ),
    ));

    if(widget.option.options.length > 0)
    widget.option.options.forEach((key, value) {
      list.add(
          Card(
            margin: EdgeInsets.all(0.2),
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
            child: InkWell(
              child: ListTile(
                onTap: () {

                },
                contentPadding: EdgeInsets.fromLTRB(16, 8, 0, 16),
                title: Text(_parseHtmlString(key)),
                subtitle: value.isEmpty ? null : Text(_parseHtmlString(value)),
              ),
            ),
          )
      );
    });

    return list;
  }
}

String _parseHtmlString(String htmlString) {
  var document = parse(htmlString);

  String parsedString = parse(document.body!.text).documentElement!.text;

  return parsedString;
}
