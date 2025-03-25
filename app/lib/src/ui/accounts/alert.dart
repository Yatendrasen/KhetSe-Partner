import 'package:admin/src/blocs/account/alerts_bloc.dart';
import 'package:admin/src/models/fcm_details_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';


class AlertsPage extends StatefulWidget {
  final alertsBloc = AlertsBloc();
  @override
  _AlertsPageState createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {

  String? selectedTopic;

  @override
  void initState() {
    fetchTopics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Notifications')
      ),
      body: StreamBuilder<FcmDetails>(
          stream: widget.alertsBloc.fcmDetails,
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data != null ? ListView(
              children: [
                SwitchListTile(
                    value: snapshot.data!.topics.contains('admin_orders'),
                    title: Text('Orders'),
                    onChanged: (bool value) {_onChanged('admin_orders', value);}
                ),
                SwitchListTile(
                    value: snapshot.data!.topics.contains('admin_reviews'),
                    title: Text('New Reviews'),
                    onChanged: (bool value) {_onChanged('admin_reviews', value);}
                ),
                SwitchListTile(
                    value: snapshot.data!.topics.contains('admin_low_stock'),
                    title: Text('Low Stock'),
                    onChanged: (bool value) {_onChanged('admin_low_stock', value);}
                ),
                SwitchListTile(
                    value: snapshot.data!.topics.contains('admin_products'),
                    title: Text('New Products'),
                    onChanged: (bool value) {_onChanged('admin_products', value);}
                ),
              ],
            ) : Center(child: CircularProgressIndicator());
          }
      ),
    );
  }

  void _onChanged(String topic, bool value) {
    if(value) {
      FirebaseMessaging.instance.subscribeToTopic(topic);
    } else {
      FirebaseMessaging.instance.unsubscribeFromTopic(topic);
    }
    widget.alertsBloc.updateTopics(topic, value);
  }

  fetchTopics() {
    FirebaseMessaging.instance.getToken().then((String? token) {
      if(token != null)
      widget.alertsBloc.fetchTopics(token);
    });
  }
}
