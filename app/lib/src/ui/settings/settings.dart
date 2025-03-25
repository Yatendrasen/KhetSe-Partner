import 'package:admin/src/blocs/settings/settings_bloc.dart';
import 'package:admin/src/models/settings/settings_model.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';

import 'settings_options.dart';

class SettingsGroups extends StatefulWidget {
  SettingsBloc settingsBloc = SettingsBloc();
  @override
  _SettingsGroupsState createState() => _SettingsGroupsState();
}

class _SettingsGroupsState extends State<SettingsGroups> {
  @override
  void initState() {
    widget.settingsBloc.fetchSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)
            .translate("settings"),),
      ),
      body: StreamBuilder(
          stream: widget.settingsBloc.allSettings,
          builder: (context, AsyncSnapshot<List<SettingsModel>> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return ListView(
                children: buildList(snapshot),
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  List<Widget> buildList(AsyncSnapshot<List<SettingsModel>> snapshot) {
    List<Widget> list = [];
    snapshot.data!.forEach((element) {
      list.add(Card(
        elevation: 0,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        child: InkWell(
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingOptions(setting: element)),
              );
            },
            contentPadding: EdgeInsets.fromLTRB(16, 8, 0, 16),
            title: Text(_parseHtmlString(element.label)),
            subtitle: element.description == null || element.description.isEmpty ? null : Text(_parseHtmlString(element.description)),
          ),
        ),
      ));
    });
    return list;
  }
}

String _parseHtmlString(String htmlString) {
  var document = parse(htmlString);

  String parsedString = parse(document.body!.text).documentElement!.text;

  return parsedString;
}
