class Config {

  /* Replace your sire url and api keys */
  String appName = 'Khet Se - Partner';
  String androidPackageName = 'co.khetse.partner';
  String iosPackageName = 'co.khetse.partner';

  // String url = 'https://khetse.co';
  String url = 'https://livingcart.in/khetse';
  String consumerKey = 'ck_2cda9f57ee9e9491f8fd39741c0c8d022c27ac88';
  String consumerSecret = 'cs_1c9caaede5a2aae5fd0acdfd191f244c71f3cbd1';
  String mapApiKey = 'AIzaSyDe-KSuLzbWf3zdIqFF8I657iT8m9RHveg';

  static Config _singleton = new Config._internal();

  factory Config() {
    return _singleton;
  }

  Config._internal();

  Map<String, dynamic> appConfig = Map<String, dynamic>();

  Config loadFromMap(Map<String, dynamic> map) {
    appConfig.addAll(map);
    return _singleton;
  }

  dynamic get(String key) => appConfig[key];

  bool getBool(String key) => appConfig[key];

  int getInt(String key) => appConfig[key];

  double getDouble(String key) => appConfig[key];

  String getString(String key) => appConfig[key];

  void clear() => appConfig.clear();

  @Deprecated("use updateValue instead")
  void setValue(key, value) => value.runtimeType != appConfig[key].runtimeType
      ? throw ("wrong type")
      : appConfig.update(key, (dynamic) => value);

  void updateValue(String key, dynamic value) {
    if (appConfig[key] != null &&
        value.runtimeType != appConfig[key].runtimeType) {
      throw ("The persistent type of ${appConfig[key].runtimeType} does not match the given type ${value.runtimeType}");
    }
    appConfig.update(key, (dynamic) => value);
  }

  void addValue(String key, dynamic value) =>
      appConfig.putIfAbsent(key, () => value);

  add(Map<String, dynamic> map) => appConfig.addAll(map);

}
