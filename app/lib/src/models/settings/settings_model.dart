// To parse this JSON data, do
//
//     final settingsModel = settingsModelFromJson(jsonString);

import 'dart:convert';

List<SettingsModel> settingsModelFromJson(String str) => List<SettingsModel>.from(json.decode(str).map((x) => SettingsModel.fromJson(x)));

String settingsModelToJson(List<SettingsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SettingsModel {
  SettingsModel({
    required this.id,
    required this.label,
    required this.description,
    this.parentId,
    required this.subGroups,
  });

  String id;
  String label;
  String description;
  ParentId? parentId;
  List<String> subGroups;

  factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel(
    id: json["id"] == null ? null : json["id"],
    label: json["label"] == null ? null : json["label"],
    description: json["description"] == null ? null : json["description"],
    parentId: json["parent_id"] == null ? null : parentIdValues.map[json["parent_id"]],
    subGroups: json["sub_groups"] == null ? [] : List<String>.from(json["sub_groups"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "label": label == null ? null : label,
    "description": description == null ? null : description,
    "parent_id": parentId == null ? null : parentIdValues.reverse![parentId],
    "sub_groups": subGroups == null ? null : List<dynamic>.from(subGroups.map((x) => x)),
  };
}

class Links {
  Links({
    required this.options,
  });

  List<Option> options;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    options: json["options"] == null ? [] : List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "options": options == null ? null : List<dynamic>.from(options.map((x) => x.toJson())),
  };
}

class Option {
  Option({
    required this.href,
  });

  String href;

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    href: json["href"] == null ? null : json["href"],
  );

  Map<String, dynamic> toJson() => {
    "href": href == null ? null : href,
  };
}

enum ParentId { EMPTY, EMAIL }

final parentIdValues = EnumValues({
  "email": ParentId.EMAIL,
  "": ParentId.EMPTY
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
