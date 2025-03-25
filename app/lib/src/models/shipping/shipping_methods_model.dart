// To parse this JSON data, do
//
//     final shippingMethods = shippingMethodsFromJson(jsonString);

import 'dart:convert';

List<ShippingMethods> shippingMethodsFromJson(String str) => List<ShippingMethods>.from(json.decode(str).map((x) => ShippingMethods.fromJson(x)));

String shippingMethodsToJson(List<ShippingMethods> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShippingMethods {
  ShippingMethods({
    required this.instanceId,
    required this.title,
    required this.order,
    required this.enabled,
    required this.methodId,
    required this.methodTitle,
    required this.methodDescription,
    required this.settings,
  });

  int instanceId;
  String title;
  int order;
  bool enabled;
  String methodId;
  String methodTitle;
  String methodDescription;
  Settings settings;

  factory ShippingMethods.fromJson(Map<String, dynamic> json) => ShippingMethods(
    instanceId: json["instance_id"] == null ? null : json["instance_id"],
    title: json["title"] == null ? null : json["title"],
    order: json["order"] == null ? null : json["order"],
    enabled: json["enabled"] == null ? null : json["enabled"],
    methodId: json["method_id"] == null ? null : json["method_id"],
    methodTitle: json["method_title"] == null ? null : json["method_title"],
    methodDescription: json["method_description"] == null ? null : json["method_description"],
    settings: json["settings"] == null ? Settings.fromJson({}) : Settings.fromJson(json["settings"]),
  );

  Map<String, dynamic> toJson() => {
    "instance_id": instanceId == null ? null : instanceId,
    "title": title == null ? null : title,
    "order": order == null ? null : order,
    "enabled": enabled == null ? null : enabled,
    "method_id": methodId == null ? null : methodId,
    "method_title": methodTitle == null ? null : methodTitle,
    "method_description": methodDescription == null ? null : methodDescription,
    "settings": settings == null ? null : settings.toJson(),
  };
}


class Settings {
  Settings({
    required this.title,
    required this.taxStatus,
    required this.cost,
    required this.classCosts,
    required this.classCost92,
    required this.classCost91,
    required this.noClassCost,
    required this.type,
    required this.requires,
    required this.minAmount,
  });

  ClassCost91 title;
  ClassCost91 taxStatus;
  ClassCost91 cost;
  ClassCost91 classCosts;
  ClassCost91 classCost92;
  ClassCost91 classCost91;
  ClassCost91 noClassCost;
  ClassCost91 type;
  ClassCost91 requires;
  ClassCost91 minAmount;

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    title: json["title"] == null ? ClassCost91.fromJson({}) : ClassCost91.fromJson(json["title"]),
    taxStatus: json["tax_status"] == null ? ClassCost91.fromJson({}) : ClassCost91.fromJson(json["tax_status"]),
    cost: json["cost"] == null ? ClassCost91.fromJson({}) : ClassCost91.fromJson(json["cost"]),
    classCosts: json["class_costs"] == null ? ClassCost91.fromJson({}) : ClassCost91.fromJson(json["class_costs"]),
    classCost92: json["class_cost_92"] == null ? ClassCost91.fromJson({}) : ClassCost91.fromJson(json["class_cost_92"]),
    classCost91: json["class_cost_91"] == null ? ClassCost91.fromJson({}) : ClassCost91.fromJson(json["class_cost_91"]),
    noClassCost: json["no_class_cost"] == null ? ClassCost91.fromJson({}) : ClassCost91.fromJson(json["no_class_cost"]),
    type: json["type"] == null ? ClassCost91.fromJson({}) : ClassCost91.fromJson(json["type"]),
    requires: json["requires"] == null ? ClassCost91.fromJson({}) : ClassCost91.fromJson(json["requires"]),
    minAmount: json["min_amount"] == null ? ClassCost91.fromJson({}) : ClassCost91.fromJson(json["min_amount"]),
  );

  Map<String, dynamic> toJson() => {
    "title": title == null ? null : title.toJson(),
    "tax_status": taxStatus == null ? null : taxStatus.toJson(),
    "cost": cost == null ? null : cost.toJson(),
    "class_costs": classCosts == null ? null : classCosts.toJson(),
    "class_cost_92": classCost92 == null ? null : classCost92.toJson(),
    "class_cost_91": classCost91 == null ? null : classCost91.toJson(),
    "no_class_cost": noClassCost == null ? null : noClassCost.toJson(),
    "type": type == null ? null : type.toJson(),
    "requires": requires == null ? null : requires.toJson(),
    "min_amount": minAmount == null ? null : minAmount.toJson(),
  };
}

class ClassCost91 {
  ClassCost91({
    this.id,
    this.label,
    this.description,
    this.type,
    this.value,
    this.classCost91Default,
    this.tip,
    this.placeholder,
    this.options,
  });

  String? id;
  String? label;
  String? description;
  String? type;
  String? value;
  String? classCost91Default;
  String? tip;
  Placeholder? placeholder;
  Options? options;

  factory ClassCost91.fromJson(Map<String, dynamic> json) => ClassCost91(
    id: json["id"] == null ? null : json["id"],
    label: json["label"] == null ? null : json["label"],
    description: json["description"] == null ? null : json["description"],
    type: json["type"] == null ? null : json["type"],
    value: json["value"] == null ? null : json["value"],
    classCost91Default: json["default"] == null ? null : json["default"],
    tip: json["tip"] == null ? null : json["tip"],
    placeholder: json["placeholder"] == null ? null : placeholderValues.map[json["placeholder"]],
    options: json["options"] == null ? Options.fromJson({}) : Options.fromJson(json["options"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "label": label == null ? null : label,
    "description": description == null ? null : description,
    "type": type == null ? null : type,
    "value": value == null ? null : value,
    "default": classCost91Default == null ? null : classCost91Default,
    "tip": tip == null ? null : tip,
    "placeholder": placeholder == null ? null : placeholderValues.reverse![placeholder],
    "options": options == null ? null : options!.toJson(),
  };
}

class Options {
  Options({
    required this.empty,
    this.coupon,
    this.minAmount,
    this.either,
    this.both,
    this.taxable,
    this.none,
    this.optionsClass,
    this.order,
  });

  Placeholder? empty;
  String? coupon;
  String? minAmount;
  String? either;
  String? both;
  String? taxable;
  String? none;
  String? optionsClass;
  String? order;

  factory Options.fromJson(Map<String, dynamic> json) => Options(
    empty: json[""] == null ? null : placeholderValues.map[json[""]],
    coupon: json["coupon"] == null ? null : json["coupon"],
    minAmount: json["min_amount"] == null ? null : json["min_amount"],
    either: json["either"] == null ? null : json["either"],
    both: json["both"] == null ? null : json["both"],
    taxable: json["taxable"] == null ? null : json["taxable"],
    none: json["none"] == null ? null : json["none"],
    optionsClass: json["class"] == null ? null : json["class"],
    order: json["order"] == null ? null : json["order"],
  );

  Map<String, dynamic> toJson() => {
    "empty": empty == null ? null : placeholderValues.reverse![empty],
    "coupon": coupon == null ? null : coupon,
    "min_amount": minAmount == null ? null : minAmount,
    "either": either == null ? null : either,
    "both": both == null ? null : both,
    "taxable": taxable == null ? null : taxable,
    "none": none == null ? null : none,
    "class": optionsClass == null ? null : optionsClass,
    "order": order == null ? null : order,
  };
}

enum Placeholder { N_A, EMPTY }

final placeholderValues = EnumValues({
  "": Placeholder.EMPTY,
  "N/A": Placeholder.N_A
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
