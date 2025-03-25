import 'package:admin/src/blocs/settings/settings_bloc.dart';
import 'package:admin/src/blocs/settings/settings_option_bloc.dart';
import 'package:admin/src/models/settings/settings_model.dart';
import 'package:admin/src/models/settings/settings_option_model.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';

import 'options_detail.dart';
import 'settings_options.dart';

class SettingOptions extends StatefulWidget {
  final SettingOptionsBloc settingsBloc = SettingOptionsBloc();
  final SettingsModel setting;
  SettingOptions({Key? key, required this.setting}) : super(key: key);
  @override
  _SettingOptionsState createState() => _SettingOptionsState();
}

class _SettingOptionsState extends State<SettingOptions> {
  @override
  void initState() {
    widget.settingsBloc.fetchSettingOptions(widget.setting);
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
          builder: (context, AsyncSnapshot<List<SettingsOptionModel>> snapshot) {
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

  List<Widget> buildList(AsyncSnapshot<List<SettingsOptionModel>> snapshot) {
    List<Widget> list = [];
    snapshot.data!.forEach((element) {
      list.add(Card(
        elevation: 0,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        child: InkWell(
          child: ListTile(
            // onTap: () {
            //   print("anillllllllllllll");
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => OptionDetail(option: element)),
            //   );
            // },
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
