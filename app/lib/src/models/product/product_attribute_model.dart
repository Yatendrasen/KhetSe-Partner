// To parse this JSON data, do
//
//     final productAttribute = productAttributeFromJson(jsonString);

import 'dart:convert';

List<ProductAttribute> productAttributeFromJson(String str) => List<ProductAttribute>.from(json.decode(str).map((x) => ProductAttribute.fromJson(x)));

String productAttributeToJson(List<ProductAttribute> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductAttribute {
  int id;
  String name;
  String? slug;
  String type;
  String orderBy;
  bool hasArchives;

  ProductAttribute({
    required this.id,
    required this.name,
    required this.slug,
    required this.type,
    required this.orderBy,
    required this.hasArchives,
  });

  factory ProductAttribute.fromJson(Map<String, dynamic> json) => ProductAttribute(
    id: json["id"] == null ? 0 : json["id"],
    name: json["name"] == null ? '' : json["name"],
    slug: json["slug"] == null ? null : json["slug"],
    type: json["type"] == null ? 'select' : json["type"],
    orderBy: json["order_by"] == null ? 'menu_order' : json["order_by"],
    hasArchives: json["has_archives"] == null ? false : json["has_archives"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "slug": slug == null ? null : slug,
    "type": type == null ? null : type,
    "order_by": orderBy == null ? null : orderBy,
    "has_archives": hasArchives == null ? null : hasArchives,
  };
}


List<AttributeTerms> attributeTermsFromJson(String str) => List<AttributeTerms>.from(json.decode(str).map((x) => AttributeTerms.fromJson(x)));

String attributeTermsToJson(List<AttributeTerms> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AttributeTerms {
  int id;
  String name;
  String slug;
  String description;
  int menuOrder;
  int count;

  AttributeTerms({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.menuOrder,
    required this.count,
  });

  factory AttributeTerms.fromJson(Map<String, dynamic> json) => AttributeTerms(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    slug: json["slug"] == null ? null : json["slug"],
    description: json["description"] == null ? null : json["description"],
    menuOrder: json["menu_order"] == null ? null : json["menu_order"],
    count: json["count"] == null ? null : json["count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "slug": slug == null ? null : slug,
    "description": description == null ? null : description,
    "menu_order": menuOrder == null ? null : menuOrder,
    "count": count == null ? null : count,
  };
}
