import 'dart:convert';

class CouponsModel {
  final List<Coupon> coupons;

  CouponsModel({
    required this.coupons,
  });

  factory CouponsModel.fromJson(List<dynamic> parsedJson) {
    List<Coupon> coupons = [];
    coupons = parsedJson.map((i) => Coupon.fromJson(i)).toList();

    return new CouponsModel(coupons: coupons);
  }
}

// To parse this JSON data, do
//
//     final coupon = couponFromJson(jsonString);

List<Coupon> couponFromJson(String str) => List<Coupon>.from(json.decode(str).map((x) => Coupon.fromJson(x)));

String couponToJson(List<Coupon> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Coupon {
  int id;
  String code;
  String amount;
  DateTime dateCreated;
  DateTime dateCreatedGmt;
  DateTime dateModified;
  DateTime dateModifiedGmt;
  String discountType;
  String description;
  dynamic dateExpires;
  dynamic dateExpiresGmt;
  int usageCount;
  bool individualUse;
  List<dynamic> productIds;
  List<dynamic> excludedProductIds;
  dynamic usageLimit;
  dynamic usageLimitPerUser;
  dynamic limitUsageToXItems;
  bool freeShipping;
  List<dynamic> productCategories;
  List<dynamic> excludedProductCategories;
  bool excludeSaleItems;
  String minimumAmount;
  String maximumAmount;
  List<dynamic> emailRestrictions;
  List<dynamic> usedBy;
  List<dynamic> metaData;

  Coupon({
    required this.id,
    required this.code,
    required this.amount,
    required this.dateCreated,
    required this.dateCreatedGmt,
    required this.dateModified,
    required this.dateModifiedGmt,
    required this.discountType,
    required this.description,
    required this.dateExpires,
    required this.dateExpiresGmt,
    required this.usageCount,
    required this.individualUse,
    required this.productIds,
    required this.excludedProductIds,
    required this.usageLimit,
    required this.usageLimitPerUser,
    required this.limitUsageToXItems,
    required this.freeShipping,
    required this.productCategories,
    required this.excludedProductCategories,
    required this.excludeSaleItems,
    required this.minimumAmount,
    required this.maximumAmount,
    required this.emailRestrictions,
    required this.usedBy,
    required this.metaData,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
    id: json["id"] == null ? 0 : json["id"],
    code: json["code"] == null ? '' : json["code"],
    amount: json["amount"] == null ? '0' : json["amount"],
    dateCreated: json["date_created"] == null ? DateTime.now() : DateTime.parse(json["date_created"]),
    dateCreatedGmt: json["date_created_gmt"] == null ? DateTime.now() : DateTime.parse(json["date_created_gmt"]),
    dateModified: json["date_modified"] == null ? DateTime.now() : DateTime.parse(json["date_modified"]),
    dateModifiedGmt: json["date_modified_gmt"] == null ? DateTime.now() : DateTime.parse(json["date_modified_gmt"]),
    discountType: json["discount_type"] == null ? '' : json["discount_type"],
    description: json["description"] == null ? '' : json["description"],
    dateExpires: json["date_expires"] == null ? DateTime.now() : json["date_expires"],
    dateExpiresGmt: json["date_expires_gmt"] == null ? DateTime.now() : json["date_expires_gmt"],
    usageCount: json["usage_count"] == null ? 0 : json["usage_count"],
    individualUse: json["individual_use"] == null ? false : json["individual_use"],
    productIds: json["product_ids"] == null ? [] : List<dynamic>.from(json["product_ids"].map((x) => x)),
    excludedProductIds: json["excluded_product_ids"] == null ? [] : List<dynamic>.from(json["excluded_product_ids"].map((x) => x)),
    usageLimit: json["usage_limit"] == null ? 0 : json["usage_limit"],
    usageLimitPerUser: json["usage_limit_per_user"] == null ? 0 : json["usage_limit_per_user"],
    limitUsageToXItems: json["limit_usage_to_x_items"] == null ? 0 : json["limit_usage_to_x_items"],
    freeShipping: json["free_shipping"] == null ? false : json["free_shipping"],
    productCategories: json["product_categories"] == null ? [] : List<dynamic>.from(json["product_categories"].map((x) => x)),
    excludedProductCategories: json["excluded_product_categories"] == null ? [] : List<dynamic>.from(json["excluded_product_categories"].map((x) => x)),
    excludeSaleItems: json["exclude_sale_items"] == null ? false : json["exclude_sale_items"],
    minimumAmount: json["minimum_amount"] == null ? '0' : json["minimum_amount"],
    maximumAmount: json["maximum_amount"] == null ? '0' : json["maximum_amount"],
    emailRestrictions: json["email_restrictions"] == null ? [] : List<dynamic>.from(json["email_restrictions"].map((x) => x)),
    usedBy: json["used_by"] == null ? [] : List<dynamic>.from(json["used_by"].map((x) => x)),
    metaData: json["meta_data"] == null ? [] : List<dynamic>.from(json["meta_data"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "code": code == null ? null : code,
    "amount": amount == null ? null : amount,
    "date_created": dateCreated == null ? null : dateCreated.toIso8601String(),
    "date_created_gmt": dateCreatedGmt == null ? null : dateCreatedGmt.toIso8601String(),
    "date_modified": dateModified == null ? null : dateModified.toIso8601String(),
    "date_modified_gmt": dateModifiedGmt == null ? null : dateModifiedGmt.toIso8601String(),
    "discount_type": discountType == null ? null : discountType,
    "description": description == null ? null : description,
    "date_expires": dateExpires,
    "date_expires_gmt": dateExpiresGmt,
    "usage_count": usageCount == null ? null : usageCount,
    "individual_use": individualUse == null ? null : individualUse,
    "product_ids": productIds == null ? null : List<dynamic>.from(productIds.map((x) => x)),
    "excluded_product_ids": excludedProductIds == null ? null : List<dynamic>.from(excludedProductIds.map((x) => x)),
    "usage_limit": usageLimit,
    "usage_limit_per_user": usageLimitPerUser,
    "limit_usage_to_x_items": limitUsageToXItems,
    "free_shipping": freeShipping == null ? null : freeShipping,
    "product_categories": productCategories == null ? null : List<dynamic>.from(productCategories.map((x) => x)),
    "excluded_product_categories": excludedProductCategories == null ? null : List<dynamic>.from(excludedProductCategories.map((x) => x)),
    "exclude_sale_items": excludeSaleItems == null ? null : excludeSaleItems,
    "minimum_amount": minimumAmount == null ? null : minimumAmount,
    "maximum_amount": maximumAmount == null ? null : maximumAmount,
    "email_restrictions": emailRestrictions == null ? null : List<dynamic>.from(emailRestrictions.map((x) => x)),
    "used_by": usedBy == null ? null : List<dynamic>.from(usedBy.map((x) => x)),
    "meta_data": metaData == null ? null : List<dynamic>.from(metaData.map((x) => x)),
  };
}
