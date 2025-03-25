import 'dart:convert';

class PaymentGatewaysModel {
  final List<PaymentGateway> payment_gateways;

  PaymentGatewaysModel({
    required this.payment_gateways,
  });

  factory PaymentGatewaysModel.fromJson(List<dynamic> parsedJson) {

    List<PaymentGateway> payment_gateways = [];
    payment_gateways = parsedJson.map((i)=>PaymentGateway.fromJson(i)).toList();

    return new PaymentGatewaysModel(payment_gateways : payment_gateways);
  }

}

// To parse this JSON data, do
//
//     final paymentGateway = paymentGatewayFromJson(jsonString);



List<PaymentGateway> paymentGatewayFromJson(String str) => List<PaymentGateway>.from(json.decode(str).map((x) => PaymentGateway.fromJson(x)));

String paymentGatewayToJson(List<PaymentGateway> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PaymentGateway {
  String id;
  String title;
  String? description;
  String order;
  bool enabled;
  String methodTitle;
  String methodDescription;
  List<String> methodSupports;
  //Map<String, Setting> settings;

  PaymentGateway({
    required this.id,
    required this.title,
    this.description,
    required this.order,
    required this.enabled,
    required this.methodTitle,
    required this.methodDescription,
    required this.methodSupports,
    //required this.settings,
  });

  factory PaymentGateway.fromJson(Map<String, dynamic> json) => PaymentGateway(
    id: json["id"] == null ? null : json["id"],
    title: json["title"] == null ? null : json["title"],
    description: json["description"] == null ? null : json["description"],
    order: json["order"] == null ? '0' : json["order"].toString(),
    enabled: json["enabled"] == null ? null : json["enabled"],
    methodTitle: json["method_title"] == null ? null : json["method_title"],
    methodDescription: json["method_description"] == null ? null : json["method_description"],
    methodSupports: json["method_supports"] == null ? [] : List<String>.from(json["method_supports"].map((x) => x)),
    //settings: json["settings"] == null ? null : Map.from(json["settings"]).map((k, v) => MapEntry<String, Setting>(k, Setting.fromJson(v))),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "title": title == null ? null : title,
    "description": description == null ? null : description,
    "order": order == null ? null : order,
    "enabled": enabled == null ? null : enabled,
    "method_title": methodTitle == null ? null : methodTitle,
    "method_description": methodDescription == null ? null : methodDescription,
    "method_supports": methodSupports == null ? null : List<dynamic>.from(methodSupports.map((x) => x)),
    //"settings": settings == null ? null : Map.from(settings).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  };
}

class Setting {
  String id;
  String label;
  String description;
  String type;
  //String value;
  //String settingDefault;
  String tip;
  String placeholder;
  Options options;

  Setting({
    required this.id,
    required this.label,
    required this.description,
    required this.type,
    //required this.value,
    //required this.settingDefault,
    required this.tip,
    required this.placeholder,
    required this.options,
  });

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
    id: json["id"] == null ? null : json["id"],
    label: json["label"] == null ? null : json["label"],
    description: json["description"] == null ? null : json["description"],
    type: json["type"] == null ? null : json["type"],
    //value: json["value"] == null ? null : json["value"],
    //settingDefault: json["default"] == null ? null : json["default"],
    tip: json["tip"] == null ? null : json["tip"],
    placeholder: json["placeholder"] == null ? null : json["placeholder"],
    options: json["options"] == null ? Options.fromJson({}) : Options.fromJson(json["options"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "label": label == null ? null : label,
    "description": description == null ? null : description,
    "type": type == null ? null : type,
    //"value": value == null ? null : value,
    //"default": settingDefault == null ? null : settingDefault,
    "tip": tip == null ? null : tip,
    "placeholder": placeholder == null ? null : placeholder,
    "options": options == null ? null : options.toJson(),
  };
}

class Options {
  String flatRate;
  String freeShipping;
  String localPickup;
  String sale;
  String authorization;

  Options({
    required this.flatRate,
    required this.freeShipping,
    required this.localPickup,
    required this.sale,
    required this.authorization,
  });

  factory Options.fromJson(Map<String, dynamic> json) => Options(
    flatRate: json["flat_rate"] == null ? null : json["flat_rate"],
    freeShipping: json["free_shipping"] == null ? null : json["free_shipping"],
    localPickup: json["local_pickup"] == null ? null : json["local_pickup"],
    sale: json["sale"] == null ? null : json["sale"],
    authorization: json["authorization"] == null ? null : json["authorization"],
  );

  Map<String, dynamic> toJson() => {
    "flat_rate": flatRate == null ? null : flatRate,
    "free_shipping": freeShipping == null ? null : freeShipping,
    "local_pickup": localPickup == null ? null : localPickup,
    "sale": sale == null ? null : sale,
    "authorization": authorization == null ? null : authorization,
  };
}