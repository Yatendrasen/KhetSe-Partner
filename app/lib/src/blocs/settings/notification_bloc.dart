import 'package:admin/src/models/push_settings.dart';
import 'package:admin/src/resources/api_provider.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:rxdart/rxdart.dart';

class NotificationBloc {

  final _notificationFetcher = BehaviorSubject<List<PushSettings>>();
  var apiProvider = ApiProvider();

 ValueStream<List<PushSettings>> get notifications => _notificationFetcher.stream;

  fetchNotification(String token) async {
    Response response = await apiProvider.postAjax('build-app-online-admin-notifications',
        {'token': token});
    if (response.statusCode == 200 || response.statusCode == 201) {
      List<PushSettings> pushSettings = pushSettingsFromJson(response.body);
      _notificationFetcher.sink.add(pushSettings);
    } else {
      _notificationFetcher.sink.addError(true);
      throw Exception('Failed to load data');
    }
  }

  dispose() {
    _notificationFetcher.close();
  }

  void update(PushSettings settings, String token) async {
    Map<String, String> data = Map();
    data['token'] = token;
    data['new_order'] = settings.newOrder;
    data['new_customer'] = settings.newCustomer;
    data['low_stock'] = settings.lowStock;
    Response response = await apiProvider.postAjax('build-app-online-admin-notifications', data);
  }

  void getNotificationDetails(String token) {

  }
}
