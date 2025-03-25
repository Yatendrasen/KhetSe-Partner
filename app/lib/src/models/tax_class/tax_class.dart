// To parse this JSON data, do
//
//     final taxClassModel = taxClassModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<TaxClassModel> taxClassModelFromJson(String str) => List<TaxClassModel>.from(json.decode(str).map((x) => TaxClassModel.fromJson(x)));

class TaxClassModel {
  TaxClassModel({
    required this.slug,
    required this.name,
  });

  String slug;
  String name;

  factory TaxClassModel.fromJson(Map<String, dynamic> json) => TaxClassModel(
    slug: json["slug"] == null ? '' : json["slug"],
    name: json["name"] == null ? '' : json["name"],
  );

  Map<String, dynamic> toJson() => {
    "slug": slug == null ? '' : slug,
    "name": name == null ? '' : name,
  };
}
