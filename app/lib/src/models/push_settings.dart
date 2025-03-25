// To parse this JSON data, do
//
//     final pushSettings = pushSettingsFromJson(jsonString);

import 'dart:convert';

List<PushSettings> pushSettingsFromJson(String str) => List<PushSettings>.from(json.decode(str).map((x) => PushSettings.fromJson(x)));

String pushSettingsToJson(List<PushSettings> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PushSettings {
  PushSettings({
    required this.newOrder,
    required this.newCustomer,
    required this.lowStock,
    required this.token,
  });

  String newOrder;
  String newCustomer;
  String lowStock;
  String token;

  factory PushSettings.fromJson(Map<String, dynamic> json) => PushSettings(
    newOrder: json["new_order"] == null ? null : json["new_order"],
    newCustomer: json["new_customer"] == null ? null : json["new_customer"],
    lowStock: json["low_stock"] == null ? null : json["low_stock"],
    token: json["token"] == null ? null : json["token"],
  );

  Map<String, dynamic> toJson() => {
    "new_order": newOrder == null ? null : newOrder,
    "new_customer": newCustomer == null ? null : newCustomer,
    "low_stock": lowStock == null ? null : lowStock,
    "token": token == null ? null : token,
  };
}
