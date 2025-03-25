import 'package:admin/src/models/app_state_model.dart';
import 'package:admin/src/ui/custom_card.dart';
import 'package:admin/src/ui/driver_app/account/wallet.dart';
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
        title: Text('Account'),
      ),
      body: ScopedModelDescendant<AppStateModel>(
          builder: (context, child, model) {
          return ListView(
            children: [
              CustomCard(
                child: SwitchListTile(
                  title: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading: Icon(CupertinoIcons.person_alt_circle),
                    title: Text('Online'),
                  ),
                  onChanged: (value) {
                    model.setIsOnline(value);
                    //TODO Implement Notification and test it
                  }, value: model.user!.isOnline == true,
                ),
              ),
              CustomCard(
                child: SwitchListTile(
                  title: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading: Icon(CupertinoIcons.brightness_solid),
                    title: Text('Notification'),
                  ),
                  onChanged: (value) {
                    model.enableNotifications(value);
                    //TODO Implement Notification and test it
                  }, value: model.user!.notification == true,
                ),
              ),
              // CustomCard(
              //   child: ListTile(
              //     onTap: () {
              //       Navigator.push(context, MaterialPageRoute(builder: (context) => Wallet()));
              //     },
              //     leading: Icon(CupertinoIcons.money_dollar_circle),
              //     trailing: Icon(Icons.arrow_right),
              //     title: Text('Wallet'),
              //   ),
              // ),
              CustomCard(
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => ThemeSettingsPage()));
                  },
                  leading: Icon(CupertinoIcons.brightness_solid),
                  trailing: Icon(Icons.arrow_right),
                  title: Text('Theme'),
                ),
              ),
              CustomCard(child: ListTile(
                leading: Icon(CupertinoIcons.power),
                trailing: Icon(Icons.arrow_right),
                title: Text('Logout'),
                onTap: () {
                 AppStateModel().logout();
                },
              ))
            ],
          );
        }
      ),
    );
  }
}
