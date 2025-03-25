//     final topSellers = topSellersFromJson(jsonString);

import 'dart:convert';

class TopSellersModel {
  final List<TopSellers> topSellers;

  TopSellersModel({
    required this.topSellers,
  });

  factory TopSellersModel.fromJson(List<dynamic> parsedJson) {

    List<TopSellers> topSellers = [];
    topSellers = parsedJson.map((i)=>TopSellers.fromJson(i)).toList();

    return new TopSellersModel(topSellers : topSellers);
  }
}

// To parse this JSON data, do
//


List<TopSellers> topSellersFromJson(String str) => List<TopSellers>.from(json.decode(str).map((x) => TopSellers.fromJson(x)));

String topSellersToJson(List<TopSellers> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TopSellers {
  String name;
  int productId;
  double quantity;

  TopSellers({
    required this.name,
    required this.productId,
    required this.quantity,
  });

  factory TopSellers.fromJson(Map<String, dynamic> json) => TopSellers(
    name: json["name"] == null ? null : json["name"],
    productId: json["product_id"] == null ? null : json["product_id"],
    quantity: json["quantity"] == null ? 0 : double.parse(json["quantity"].toString()),
  );

  Map<String, dynamic> toJson() => {
    "title": name == null ? null : name,
    "product_id": productId == null ? null : productId,
    "quantity": quantity == null ? null : quantity,
  };
}
