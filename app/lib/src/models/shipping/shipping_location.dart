// To parse this JSON data, do
//
//     final shippingLocation = shippingLocationFromJson(jsonString);

import 'dart:convert';

List<ShippingLocation> shippingLocationFromJson(String str) => List<ShippingLocation>.from(json.decode(str).map((x) => ShippingLocation.fromJson(x)));

String shippingLocationToJson(List<ShippingLocation> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShippingLocation {
  ShippingLocation({
    required this.code,
    required this.type,
  });

  String code;
  String type;

  factory ShippingLocation.fromJson(Map<String, dynamic> json) => ShippingLocation(
    code: json["code"] == null ? null : json["code"],
    type: json["type"] == null ? null : json["type"],
  );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "type": type == null ? null : type,
  };
}
