// To parse this JSON data, do
//
//     final settings = settingsFromJson(jsonString);

import 'dart:convert';

List<SettingsOptionModel> settingsFromJson(String str) => List<SettingsOptionModel>.from(json.decode(str).map((x) => SettingsOptionModel.fromJson(x)));

String settingsToJson(List<SettingsOptionModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SettingsOptionModel {
  String id;
  String label;
  String description;
  String type;
  dynamic settingDefault;
  String? tip;
  dynamic value;
  Map<String, String> options;

  SettingsOptionModel({
    required this.id,
    required this.label,
    required this.description,
    required this.type,
    required this.settingDefault,
    this.tip,
    required this.value,
    required this.options,
  });

  factory SettingsOptionModel.fromJson(Map<String, dynamic> json) => SettingsOptionModel(
    id: json["id"] == null ? null : json["id"],
    label: json["label"] == null ? null : json["label"],
    description: json["description"] == null ? null : json["description"],
    type: json["type"] == null ? null : json["type"],
    settingDefault: json["default"] == null ? null : json["default"],
    tip: json["tip"] == null ? null : json["tip"],
    value: json["value"],
    options: json["options"] == null ? Map.from({}) : Map.from(json["options"]).map((k, v) => MapEntry<String, String>(k, v)),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "label": label == null ? null : label,
    "description": description == null ? null : description,
    "type": type == null ? null : type,
    "default": settingDefault == null ? null : settingDefault,
    "tip": tip == null ? null : tip,
    "value": value,
    "options": options == null ? null : Map.from(options).map((k, v) => MapEntry<String, dynamic>(k, v)),
  };
}
