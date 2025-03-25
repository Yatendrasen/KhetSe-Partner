// To parse this JSON data, do
//
//     final deliveryBoyOptions = deliveryBoyOptionsFromJson(jsonString);

import 'dart:convert';
import 'package:admin/src/models/customer/customer_model.dart';
import 'package:admin/src/models/themes/theme.dart';
import 'package:admin/src/models/vendor_settings.dart';

DeliveryBoyOptions deliveryBoyOptionsFromJson(String str) => DeliveryBoyOptions.fromJson(json.decode(str));

String deliveryBoyOptionsToJson(DeliveryBoyOptions data) => json.encode(data.toJson());

class DeliveryBoyOptions {
  DeliveryBoyOptions({
    required this.deliveryBoyRole,
    this.user,
    required this.vendorType,
    required this.distance,
    this.info,
    required this.orderStatuses,
    required this.newOrderStatus,
    required this.blockTheme,
    this.settings,
  });

  String deliveryBoyRole;
  Customer? user;
  String vendorType;
  String distance;
  Info? info;
  List<OrderStatus> orderStatuses;
  List<OrderStatus> newOrderStatus;
  BlockThemes? blockTheme;
  VendorSettingsModel? settings;

  factory DeliveryBoyOptions.fromJson(Map<String, dynamic> json) => DeliveryBoyOptions(
    deliveryBoyRole: json["delivery_boy_role"] == null ? null : json["delivery_boy_role"],
    user: json["user"] == null ? Customer.fromJson({}) : Customer.fromJson(json["user"]),
    vendorType: json["vendor_type"] == null ? 'wcfm' : json["vendor_type"],
    distance: json["distance"] == null ? '10' : json["distance"].toString(),
    info: json["info"] == null ? null : Info.fromJson(json["info"]),
    orderStatuses: json["order_statuses"] == null ? [] : List<OrderStatus>.from(json["order_statuses"].map((x) => OrderStatus.fromJson(x))),
    newOrderStatus: json["new_order_status"] == null ? [] : List<OrderStatus>.from(json["new_order_status"].map((x) => OrderStatus.fromJson(x))),
    blockTheme: json["theme"] == null || json["theme"] == false ? null : BlockThemes.fromJson(json['theme'] as Map<String, dynamic>),
    settings: json["vendor_settings"] == null ? VendorSettingsModel.fromJson({}) : VendorSettingsModel.fromJson(json["vendor_settings"]),
  );

  Map<String, dynamic> toJson() => {
    "delivery_boy_role": deliveryBoyRole == null ? null : deliveryBoyRole,
    "vendor_type": vendorType == null ? null : vendorType,
  };
}

class Info {
  Info({
    required this.name,
    required this.description,
    required this.email,
    required this.url,
    required this.phone,
    required this.currency,
    required this.priceDecimal
  });

  String name;
  String description;
  String email;
  String url;
  String phone;
  String currency;
  int priceDecimal;

  factory Info.fromJson(Map<String, dynamic> json) => Info(
    name: json["name"] == null ? '' : json["name"],
    description: json["description"] == null ? '' : json["description"],
    email: json["email"] == null ? '' : json["email"],
    url: json["url"] == null ? '' : json["url"],
    phone: json["phone"] == null ? '' : json["phone"],
    currency: json["currency"] == null ? 'USD' : json["currency"],
    priceDecimal: json["priceDecimal"] == null ? 2 : json["priceDecimal"],
  );
}

class OrderStatus {
  OrderStatus({
    required this.key,
    required this.value,
  });

  String key;
  String? value;

  factory OrderStatus.fromJson(Map<String, dynamic> json) => OrderStatus(
    key: json["key"] == null ? null : json["key"],
    value: json["value"] == null ? null : json["value"],
  );

  Map<String, dynamic> toJson() => {
    "key": key == null ? null : key,
    "value": value == null ? null : value,
  };
}