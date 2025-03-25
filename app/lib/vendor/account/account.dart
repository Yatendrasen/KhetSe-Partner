import 'package:admin/src/config.dart';
import 'package:admin/src/models/app_state_model.dart';
import 'package:admin/src/ui/custom_card.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:admin/src/ui/webview.dart';
import 'package:admin/vendor/account/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)
            .translate("account"),),
      ),
      body: ScopedModelDescendant<AppStateModel>(
          builder: (context, child, model) {
          return ListView(
            children: [
              CustomCard(
                child: SwitchListTile(
                  //leading: Icon(CupertinoIcons.bell),
                  title: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading: Icon(CupertinoIcons.person_alt_circle),
                    title: Text(AppLocalizations.of(context)
                .translate("online"),),
                  ),
                  onChanged: (value) {
                    model.setIsOnline(value);
                    //TODO Implement Notification and test it
                  }, value: model.user!.isOnline == true,
                ),
              ),
              CustomCard(
                child: SwitchListTile(
                  //leading: Icon(CupertinoIcons.bell),
                  title: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading: Icon(CupertinoIcons.bell_fill),
                    title: Text(AppLocalizations.of(context)
                .translate("notification"),),
                  ),
                  onChanged: (value) {
                    model.enableNotifications(value);
                    //TODO Implement Notification and test it
                  }, value: model.user!.notification == true,
                ),
              ),
             /* CustomCard(
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => WebViewPage(url: Config().url + _getVendorUrl(model.options.vendorType))));
                  },
                  leading: Icon(CupertinoIcons.chart_bar_circle_fill),
                  trailing: Icon(Icons.arrow_right),
                  title: Text('Dashboard'),
                ),
              ),*/
              CustomCard(
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => ThemeSettingsPage()));
                  },
                  leading: Icon(CupertinoIcons.brightness_solid),
                  trailing: Icon(Icons.arrow_right),
                  title: Text(AppLocalizations.of(context)
                .translate("theme"),),
                ),
              ),
              CustomCard(child: ListTile(
                leading: Icon(Icons.exit_to_app_rounded),
                trailing: Icon(Icons.arrow_right),
                title: Text(AppLocalizations.of(context)
                .translate("logout"),),
                onTap: () {
                  model.logout();
                },
              ))
            ],
          );
        }
      ),
    );
  }

  String _getVendorUrl(String vendorType) {
    switch (vendorType) {
      case 'wcfm':
        return '/store-manager';
      case 'dokan':
        return '/dashboard';
      case 'wcfm':
        return '/wp-admin';
      default:
        return '/wp-admin';
    }
  }
}
