import 'package:admin/src/models/fcm_details_model.dart';
import 'package:admin/src/resources/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class AlertsBloc {

  final _fcmDetailsFetcher = BehaviorSubject<FcmDetails>();
  final api = ApiProvider();
  late FcmDetails fDetails;

  ValueStream<FcmDetails> get fcmDetails => _fcmDetailsFetcher.stream;

  fetchTopics(String token) async {
      Map<String, dynamic> data = {};
      data['token'] = token;
      final response = await api.postAjax('build-app-online-admin-fcm_details', data);
      if(response.statusCode == 200) {
        fDetails = fcmDetailsFromJson(response.body);
        _fcmDetailsFetcher.sink.add(fDetails);
      } else {
        _fcmDetailsFetcher.sink.addError(true);
        throw Exception(
          'Unexpected response from server: (${response.statusCode}) ${response.reasonPhrase}',
        );
      }
  }

  dispose() {
    _fcmDetailsFetcher.close();
  }

  void updateTopics(String topic, bool value) {
    if(value) {
      fDetails.topics.add(topic);
    } else {
      fDetails.topics.remove(topic);
    }
    _fcmDetailsFetcher.sink.add(fDetails);
  }
}

final bloc = AlertsBloc();