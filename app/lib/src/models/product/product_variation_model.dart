// To parse this JSON data, do
//
//     final productVariation = productVariationFromJson(jsonString);

import 'dart:convert';

List<ProductVariation> productVariationFromJson(String str) => List<ProductVariation>.from(json.decode(str).map((x) => ProductVariation.fromJson(x)));

String productVariationToJson(List<ProductVariation> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductVariation {
  int id;
  DateTime? dateCreated;
  DateTime? dateCreatedGmt;
  DateTime? dateModified;
  DateTime? dateModifiedGmt;
  String description;
  String? permalink;
  String? sku;
  String price;
  dynamic regularPrice;
  dynamic salePrice;
  dynamic dateOnSaleFrom;
  dynamic dateOnSaleFromGmt;
  dynamic dateOnSaleTo;
  dynamic dateOnSaleToGmt;
  bool onSale;
  String status;
  bool purchasable;
  bool virtual;
  bool downloadable;
  List<dynamic> downloads;
  int downloadLimit;
  int downloadExpiry;
  String taxStatus;
  String? taxClass;
  bool manageStock;
  dynamic stockQuantity;
  String stockStatus;
  String? backorders;
  bool? backordersAllowed;
  bool? backordered;
  String? weight;
  Dimensions? dimensions;
  String? shippingClass;
  int? shippingClassId;
  VariationImage image;
  List<VariationAttribute> attributes;
  int? menuOrder;
  List<dynamic>? metaData;

  ProductVariation({
    required this.id,
    this.dateCreated,
    this.dateCreatedGmt,
    this.dateModified,
    this.dateModifiedGmt,
    required this.description,
    this.permalink,
    this.sku,
    required this.price,
    this.regularPrice,
    this.salePrice,
    this.dateOnSaleFrom,
    this.dateOnSaleFromGmt,
    this.dateOnSaleTo,
    this.dateOnSaleToGmt,
    required this.onSale,
    required this.status,
    required this.purchasable,
    required this.virtual,
    required this.downloadable,
    required this.downloads,
    required this.downloadLimit,
    required this.downloadExpiry,
    required this.taxStatus,
    this.taxClass,
    required this.manageStock,
    required this.stockQuantity,
    required this.stockStatus,
    this.backorders,
    this.backordersAllowed,
    this.backordered,
    this.weight,
    this.dimensions,
    this.shippingClass,
    this.shippingClassId,
    required this.image,
    required this.attributes,
    required this.menuOrder,
    required this.metaData,
  });

  factory ProductVariation.fromJson(Map<String, dynamic> json) => ProductVariation(
    id: json["id"] == null ? 0 : json["id"],
    dateCreated: json["date_created"] == null ? null : DateTime.parse(json["date_created"]),
    dateCreatedGmt: json["date_created_gmt"] == null ? null : DateTime.parse(json["date_created_gmt"]),
    dateModified: json["date_modified"] == null ? null : DateTime.parse(json["date_modified"]),
    dateModifiedGmt: json["date_modified_gmt"] == null ? null : DateTime.parse(json["date_modified_gmt"]),
    description: json["description"] == null ? '' : json["description"],
    permalink: json["permalink"] == null ? null : json["permalink"],
    sku: json["sku"] == null ? null : json["sku"],
    price: json["price"] == null || json["price"] == '' ? '0' : json["price"],
    regularPrice: json["regular_price"] == null ? null : json["regular_price"],
    salePrice: json["sale_price"] == null ? null : json["sale_price"],
    dateOnSaleFrom: json["date_on_sale_from"],
    dateOnSaleFromGmt: json["date_on_sale_from_gmt"],
    dateOnSaleTo: json["date_on_sale_to"],
    dateOnSaleToGmt: json["date_on_sale_to_gmt"],
    onSale: json["on_sale"] == null ? false : json["on_sale"],
    status: json["status"] == null ? 'draft' : json["status"],
    purchasable: json["purchasable"] == null ? true : json["purchasable"],
    virtual: json["virtual"] == null ? false : json["virtual"],
    downloadable: json["downloadable"] == null ? false : json["downloadable"],
    downloads: json["downloads"] == null ? [] : List<dynamic>.from(json["downloads"].map((x) => x)),
    downloadLimit: json["download_limit"] == null ? -1 : json["download_limit"],
    downloadExpiry: json["download_expiry"] == null ? -1 : json["download_expiry"],
    taxStatus: json["tax_status"] == null ? 'taxable' : json["tax_status"],
    taxClass: json["tax_class"] == null ? null : json["tax_class"],
    manageStock: json["manage_stock"] is bool ? json["manage_stock"] : false,
    stockQuantity: json["stock_quantity"] == null ? 1 : json["stock_quantity"],
    stockStatus: json["stock_status"] == null ? 'instock' : json["stock_status"],
    backorders: json["backorders"] == null ? null : json["backorders"],
    backordersAllowed: json["backorders_allowed"] == null ? null : json["backorders_allowed"],
    backordered: json["backordered"] == null ? null : json["backordered"],
    weight: json["weight"] == null ? null : json["weight"],
    dimensions: json["dimensions"] == null ? null : Dimensions.fromJson(json["dimensions"]),
    shippingClass: json["shipping_class"] == null ? null : json["shipping_class"],
    shippingClassId: json["shipping_class_id"] == null ? null : json["shipping_class_id"],
    image: json["image"] == null ? VariationImage.fromJson({}) : VariationImage.fromJson(json["image"]),
    attributes: json["attributes"] == null ? [] : List<VariationAttribute>.from(json["attributes"].map((x) => VariationAttribute.fromJson(x))),
    menuOrder: json["menu_order"] == null ? null : json["menu_order"],
    metaData: json["meta_data"] == null ? [] : List<dynamic>.from(json["meta_data"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "description": description == null ? null : description,
    "sku": sku == null ? null : sku,
    "regular_price": regularPrice == null ? null : regularPrice,
    "sale_price": salePrice == null ? null : salePrice,
    "date_on_sale_from": dateOnSaleFrom,
    "date_on_sale_from_gmt": dateOnSaleFromGmt,
    "date_on_sale_to": dateOnSaleTo,
    "date_on_sale_to_gmt": dateOnSaleToGmt,
    "status": status == null ? null : status,
    "virtual": virtual == null ? null : virtual,
    "downloadable": downloadable == null ? null : downloadable,
    "downloads": downloads == null ? null : List<dynamic>.from(downloads.map((x) => x)),
    "download_limit": downloadLimit == null ? null : downloadLimit,
    "download_expiry": downloadExpiry == null ? null : downloadExpiry,
    "tax_status": taxStatus == null ? null : taxStatus,
    "tax_class": taxClass == null ? null : taxClass,
    "manage_stock": manageStock == null ? null : manageStock,
    "stock_quantity": stockQuantity,
    "stock_status": stockStatus == null ? null : stockStatus,
    "backorders": backorders == null ? null : backorders,
    "weight": weight == null ? null : weight,
    "dimensions": dimensions == null ? null : dimensions!.toJson(),
    "shipping_class": shippingClass == null ? null : shippingClass,
    "image": image == null ? null : image.toJson(),
    "attributes": attributes == null ? null : List<dynamic>.from(attributes.map((x) => x.toJson())),
    "menu_order": menuOrder == null ? null : menuOrder,
    "meta_data": metaData == null ? null : List<dynamic>.from(metaData!.map((x) => x)),
  };
}

class VariationAttribute {
  int id;
  String name;
  String option;

  VariationAttribute({
    required this.id,
    required this.name,
    required this.option,
  });

  factory VariationAttribute.fromJson(Map<String, dynamic> json) => VariationAttribute(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    option: json["option"] == null ? null : json["option"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "option": option == null ? null : option,
  };
}

class Dimensions {
  String length;
  String width;
  String height;

  Dimensions({
    required this.length,
    required this.width,
    required this.height,
  });

  factory Dimensions.fromJson(Map<String, dynamic> json) => Dimensions(
    length: json["length"] == null ? null : json["length"],
    width: json["width"] == null ? null : json["width"],
    height: json["height"] == null ? null : json["height"],
  );

  Map<String, dynamic> toJson() => {
    "length": length == null ? null : length,
    "width": width == null ? null : width,
    "height": height == null ? null : height,
  };
}

class VariationImage {
  int id;
  DateTime dateCreated;
  DateTime dateCreatedGmt;
  DateTime dateModified;
  DateTime dateModifiedGmt;
  String src;
  String name;
  String alt;

  VariationImage({
    required this.id,
    required this.dateCreated,
    required this.dateCreatedGmt,
    required this.dateModified,
    required this.dateModifiedGmt,
    required this.src,
    required this.name,
    required this.alt,
  });

  factory VariationImage.fromJson(Map<String, dynamic> json) => VariationImage(
    id: json["id"] == null ? 0 : json["id"],
    dateCreated: json["date_created"] == null ? DateTime.now() : DateTime.parse(json["date_created"]),
    dateCreatedGmt: json["date_created_gmt"] == null ? DateTime.now() : DateTime.parse(json["date_created_gmt"]),
    dateModified: json["date_modified"] == null ? DateTime.now() : DateTime.parse(json["date_modified"]),
    dateModifiedGmt: json["date_modified_gmt"] == null ? DateTime.now() : DateTime.parse(json["date_modified_gmt"]),
    src: json["src"] == null ? '' : json["src"],
    name: json["name"] == null ? '' : json["name"],
    alt: json["alt"] == null ? '' : json["alt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "date_created": dateCreated == null ? null : dateCreated.toIso8601String(),
    "date_created_gmt": dateCreatedGmt == null ? null : dateCreatedGmt.toIso8601String(),
    "date_modified": dateModified == null ? null : dateModified.toIso8601String(),
    "date_modified_gmt": dateModifiedGmt == null ? null : dateModifiedGmt.toIso8601String(),
    "src": src == null ? null : src,
    "name": name == null ? null : name,
    "alt": alt == null ? null : alt,
  };
}
