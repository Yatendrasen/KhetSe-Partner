import 'package:admin/src/models/settings/settings_model.dart';
import 'package:admin/src/models/settings/settings_option_model.dart';
import 'package:admin/src/resources/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class SettingOptionsBloc {

  final _settingsFetcher = BehaviorSubject<List<SettingsOptionModel>>();
  final apiProvider = ApiProvider();

 ValueStream<List<SettingsOptionModel>> get allSettings => _settingsFetcher.stream;

  fetchSettingOptions(SettingsModel setting) async {
    dynamic response = await apiProvider.get('settings/' + setting.id);
    _settingsFetcher.sink.add(settingsFromJson(response));
  }

  dispose() {
    _settingsFetcher.close();
  }
}
