import 'package:admin/src/models/push_settings.dart';
import 'package:admin/src/models/settings/settings_model.dart';
import 'package:admin/src/resources/api_provider.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:rxdart/rxdart.dart';

class SettingsBloc {

  final _settingsFetcher = BehaviorSubject<List<SettingsModel>>();
  final apiProvider = ApiProvider();

  ValueStream<List<SettingsModel>> get allSettings => _settingsFetcher.stream;

  fetchSettings() async {
    dynamic response = await apiProvider.get('settings');
    _settingsFetcher.sink.add(settingsModelFromJson(response));
  }

  dispose() {
    _settingsFetcher.close();
  }
}
