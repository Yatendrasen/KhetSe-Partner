// To parse this JSON data, do
//
//     final shippingZones = shippingZonesFromJson(jsonString);

import 'dart:convert';

List<ShippingZones> shippingZonesFromJson(String str) => List<ShippingZones>.from(json.decode(str).map((x) => ShippingZones.fromJson(x)));

String shippingZonesToJson(List<ShippingZones> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShippingZones {
  ShippingZones({
    required this.id,
    required this.name,
    required this.order,
  });

  int id;
  String name;
  int order;

  factory ShippingZones.fromJson(Map<String, dynamic> json) => ShippingZones(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    order: json["order"] == null ? null : json["order"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "order": order == null ? null : order,
  };
}
