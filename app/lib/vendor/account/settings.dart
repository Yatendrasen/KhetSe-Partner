import 'package:admin/src/models/app_state_model.dart';
import 'package:admin/src/ui/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';


class ThemeSettingsPage extends StatefulWidget {
  @override
  _ThemeSettingsPageState createState() => _ThemeSettingsPageState();
}

class _ThemeSettingsPageState extends State<ThemeSettingsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Theme Settings'),
      ),
      body: ScopedModelDescendant<AppStateModel>(
          builder: (context, child, model) {
            return ListView(
              children: [
                CustomCard(
                  child: RadioListTile<ThemeMode>(
                      title: Text('System'),
                      value: ThemeMode.system,
                      groupValue: model.themeMode,
                      onChanged: (value) {
                        if(value != null) {
                          model.updateTheme(value);
                        }
                      }),
                ),
                CustomCard(
                  child: RadioListTile<ThemeMode>(
                      title: Text('Light'),
                      value: ThemeMode.light,
                      groupValue: model.themeMode,
                      onChanged: (value) {
                        if(value != null) {
                          model.updateTheme(value);
                        }
                      }),
                ),
                CustomCard(
                  child: RadioListTile<ThemeMode>(
                      title: Text('Dark'),
                      value: ThemeMode.dark,
                      groupValue: model.themeMode,
                      onChanged: (value) {
                        if(value != null) {
                          model.updateTheme(value);
                        }
                      }),
                )
              ],
            );
          }
      ),
    );
  }
}