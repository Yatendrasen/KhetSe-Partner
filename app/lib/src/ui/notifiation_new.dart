import 'package:admin/src/blocs/settings/notification_bloc.dart';
import 'package:admin/src/models/push_settings.dart';
import 'package:admin/src/resources/api_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
//import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'language/app_localizations.dart';

class NotificationNewPage extends StatefulWidget {
  final NotificationBloc notificationBloc = NotificationBloc();

  @override
  _NotificationNewPageState createState() => _NotificationNewPageState();
}

class _NotificationNewPageState extends State<NotificationNewPage> {

  late String token;

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<String>(
            stream: null,
            builder: (context, snapshot) {
              return Text(
                  AppLocalizations.of(context).translate("notifications"));
            }),
      ),
      body: StreamBuilder<List<PushSettings>>(
          stream: widget.notificationBloc.notifications,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              PushSettings pushSettings = snapshot.data!.firstWhere((element) => element.token == token);
              return Column(
                children: [
                  Card(
                    elevation: 0,
                    margin: EdgeInsets.all(0.2),
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    child: SwitchListTile(
                      title: Text(
                        AppLocalizations.of(context).translate("orders"),
                      ),
                      value: pushSettings.newOrder == '1' ? true : false,
                      onChanged: (value) {
                        setState(() {
                          pushSettings.newOrder = value ? '1' : '0';
                        });
                        widget.notificationBloc.update(pushSettings, token);
                      },
                    ),
                  ),
                  Card(
                    elevation: 0,
                    margin: EdgeInsets.all(0.2),
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    child: SwitchListTile(
                      title: Text(
                        AppLocalizations.of(context).translate("low_stock"),
                      ),
                      value: pushSettings.lowStock == '1' ? true : false,
                      onChanged: (value) {
                        setState(() {
                          pushSettings.lowStock = value ? '1' : '0';
                        });
                        widget.notificationBloc.update(pushSettings, token);
                      },
                    ),
                  ),
                  Card(
                    elevation: 0,
                    margin: EdgeInsets.all(0.2),
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    child: SwitchListTile(
                      title: Text(
                        AppLocalizations.of(context).translate("customers"),
                      ),
                      value:
                      pushSettings.newCustomer == '1' ? true : false,
                      onChanged: (value) {
                        setState(() {
                          pushSettings.newCustomer = value ? '1' : '0';
                        });
                        widget.notificationBloc.update(pushSettings, token);
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: TextButton(onPressed: () async {
                      Uri uri = Uri.parse('https://wa.me/+918073253788?text=Request%20for%20Pushnotification%20plugin%20');
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      }
                    }, child: Text('Request plugin for PushNotification')),
                  )
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  void getDetails() async {
    FirebaseMessaging.instance.getToken().then((String? t) {
      if(t != null) {
        token = t;
        widget.notificationBloc.fetchNotification(token);
      }
    });
  }
}
