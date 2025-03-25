import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:admin/src/models/app_state_model.dart';
import 'package:admin/src/resources/api_provider.dart';
import 'app_localizations.dart';

class LanguagePage extends StatefulWidget {
  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  final apiProvider = ApiProvider();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1.0,
          title: Text(
            AppLocalizations.of(context).translate("Language"),
          ),
        ),
        body: buildLanguageItems());
  }

  Widget buildLanguageItems() {
    return ListView.builder(
        itemCount: languages.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return Column(
            children: <Widget>[
              new ListTile(
                trailing: Radio<String>(
                  value: languages[index].code,
                  groupValue: ScopedModel.of<AppStateModel>(context).appLocal.languageCode,
                  onChanged: (value) async {
                    ScopedModel.of<AppStateModel>(context).changeLanguage(languages[index].code);
                  },
                ),
                title: Text(languages[index].name),
                onTap: () async {
                  ScopedModel.of<AppStateModel>(context).changeLanguage(languages[index].code);
                },
              ),
              Divider(
                height: 0,
              )
            ],
          );
        });
  }

  List<Language> languages = [
    Language(code: 'en', name: 'English'),
    Language(code: 'ar', name: 'عربى'),
    Language(code: 'pt', name: 'Português'),
    Language(code: 'es', name: 'Español'),
    Language(code: 'fr', name: 'Français'),
    Language(code: 'hi', name: 'हिंदी'),
    Language(code: 'id', name: 'bahasa Indonesia'),
    Language(code: 'ru', name: 'русский'),
  ];
}

class Language {
  String code;
  String name;

  Language({
    required this.code,
    required this.name,
  });
}
