import 'dart:convert';

import 'package:admin/src/models/customer/customer_model.dart';

import '../product/vendor_product_model.dart';

class OrdersModel {
  final List<Order> orders;

  OrdersModel({
    required this.orders,
  });

  factory OrdersModel.fromJson(List<dynamic> parsedJson) {

    List<Order> orders = [];
    orders = parsedJson.map((i)=>Order.fromJson(i)).toList();

    return new OrdersModel(orders : orders);
  }

}

// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

List<Order> orderFromJson(String str) => List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String orderToJson(List<Order> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Order {
  int id;
  int parentId;
  String number;
  String orderKey;
  String? createdVia;
  String? version;
  String? status;
  String currency;
  DateTime dateCreated;
  DateTime? dateCreatedGmt;
  DateTime? dateModified;
  DateTime? dateModifiedGmt;
  String? discountTotal;
  String? discountTax;
  String? shippingTotal;
  String? shippingTax;
  String? cartTax;
  double total;
  String? totalTax;
  bool? pricesIncludeTax;
  int? customerId;
  String? customerIpAddress;
  String? customerUserAgent;
  String? customerNote;
  Address billing;
  Address shipping;
  String? paymentMethod;
  String paymentMethodTitle;
  String? transactionId;
  DateTime? datePaid;
  DateTime? datePaidGmt;
  DateTime? dateCompleted;
  DateTime? dateCompletedGmt;
  String? cartHash;
  List<LineItemMetaDatum> metaData;
  List<LineItem> lineItems;
  List<TaxLine>? taxLines;
  List<ShippingLine> shippingLines;
  List<dynamic> feeLines;
  List<CouponLine> couponLines;
  List<OrderRefund>? refunds;
  CustomerData? customerData;
  DriverData? driverData;
  List<Vendor>? vendors;

  Order({
    required this.id,
    required this.parentId,
    required this.number,
    required this.orderKey,
    this.createdVia,
    this.version,
    required this.status,
    required this.currency,
    required this.dateCreated,
    this.dateCreatedGmt,
    this.dateModified,
    this.dateModifiedGmt,
    this.discountTotal,
    this.discountTax,
    this.shippingTotal,
    this.shippingTax,
    this.cartTax,
    required this.total,
    this.totalTax,
    this.pricesIncludeTax,
    this.customerId,
    this.customerIpAddress,
    this.customerUserAgent,
    required this.customerNote,
    required this.billing,
    required this.shipping,
    this.paymentMethod,
    required this.paymentMethodTitle,
    this.transactionId,
    this.datePaid,
    this.datePaidGmt,
    this.dateCompleted,
    this.dateCompletedGmt,
    this.cartHash,
    required this.metaData,
    required this.lineItems,
    this.taxLines,
    required this.shippingLines,
    required this.feeLines,
    required this.couponLines,
    this.refunds,
    this.customerData,
    this.driverData,
    this.vendors,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"] == null ? 0 : json["id"],
    parentId: json["parent_id"] == null ? 0 : json["parent_id"],
    number: json["number"] == null ? '0' : json["number"],
    orderKey: json["order_key"] == null ? '' : json["order_key"],
    createdVia: json["created_via"] == null ? null : json["created_via"],
    version: json["version"] == null ? null : json["version"],
    status: json["status"] == null ? null : json["status"],
    currency: json["currency"] == null ? 'USD' : json["currency"],
    dateCreated: json["date_created"] == null ? DateTime.now() : DateTime.parse(json["date_created"]),
    dateCreatedGmt: json["date_created_gmt"] == null ? null : DateTime.parse(json["date_created_gmt"]),
    dateModified: json["date_modified"] == null ? null : DateTime.parse(json["date_modified"]),
    dateModifiedGmt: json["date_modified_gmt"] == null ? null : DateTime.parse(json["date_modified_gmt"]),
    discountTotal: json["discount_total"] == null ? null : json["discount_total"],
    discountTax: json["discount_tax"] == null ? null : json["discount_tax"],
    shippingTotal: json["shipping_total"] == null ? null : json["shipping_total"],
    shippingTax: json["shipping_tax"] == null ? null : json["shipping_tax"],
    cartTax: json["cart_tax"] == null ? null : json["cart_tax"],
    total: json["total"] == null ? 0 : double.parse(json["total"]),
    totalTax: json["total_tax"] == null ? null : json["total_tax"],
    pricesIncludeTax: json["prices_include_tax"] == null ? false : json["prices_include_tax"],
    customerId: json["customer_id"] == null ? null : json["customer_id"],
    customerIpAddress: json["customer_ip_address"] == null ? null : json["customer_ip_address"],
    customerUserAgent: json["customer_user_agent"] == null ? null : json["customer_user_agent"],
    customerNote: json["customer_note"] == null ? null : json["customer_note"],
    billing: json["billing"] == null ? Address.fromJson({}) : Address.fromJson(json["billing"]),
    shipping: json["shipping"] == null ? Address.fromJson({}) : Address.fromJson(json["shipping"]),
    paymentMethod: json["payment_method"] == null ? null : json["payment_method"],
    paymentMethodTitle: json["payment_method_title"] == null ? '' : json["payment_method_title"],
    transactionId: json["transaction_id"] == null ? null : json["transaction_id"],
    datePaid: json["date_paid"] == null ? null : DateTime.parse(json["date_paid"]),
    datePaidGmt: json["date_paid_gmt"] == null ? null : DateTime.parse(json["date_paid_gmt"]),
    dateCompleted: json["date_completed"] == null ? null : DateTime.parse(json["date_completed"]),
    dateCompletedGmt: json["date_completed_gmt"] == null ? null : DateTime.parse(json["date_completed_gmt"]),
    cartHash: json["cart_hash"] == null ? null : json["cart_hash"],
    metaData: json["meta_data"] == null ? [] : List<LineItemMetaDatum>.from(json["meta_data"].map((x) => LineItemMetaDatum.fromJson(x))),
    lineItems: json["line_items"] == null ? [] : List<LineItem>.from(json["line_items"].map((x) => LineItem.fromJson(x))),
    taxLines: json["tax_lines"] == null ? [] : List<TaxLine>.from(json["tax_lines"].map((x) => TaxLine.fromJson(x))),
    shippingLines: json["shipping_lines"] == null ? [] : List<ShippingLine>.from(json["shipping_lines"].map((x) => ShippingLine.fromJson(x))),
    feeLines: json["fee_lines"] == null ? [] : List<dynamic>.from(json["fee_lines"].map((x) => x)),
    couponLines: json["coupon_lines"] == null ? [] : List<CouponLine>.from(json["coupon_lines"].map((x) => CouponLine.fromJson(x))),
    refunds: json["refunds"] == null ? [] : List<OrderRefund>.from(json["refunds"].map((x) => OrderRefund.fromJson(x))),
    customerData: json["customer_data"] == null ? null : CustomerData.fromJson(json["customer_data"]),
    driverData: json["driver_data"] == null ? null : DriverData.fromJson(json["driver_data"]),
    vendors: json["vendors"] == null ? null : List<Vendor>.from(json["vendors"].map((x) => Vendor.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "parent_id": parentId == null ? null : parentId,
    "number": number == null ? null : number,
    "status": status == null ? null : status,
    "currency": currency == null ? null : currency,
    //"date_created": dateCreated == null ? null : dateCreated.toIso8601String(),
    //"date_created_gmt": dateCreatedGmt == null ? null : dateCreatedGmt.toIso8601String(),
    //"date_modified": dateModified == null ? null : dateModified.toIso8601String(),
    //"date_modified_gmt": dateModifiedGmt == null ? null : dateModifiedGmt.toIso8601String(),
    "total": total == null ? null : total.toString(),
    "customer_id": customerId == null ? null : customerId,
    "customer_note": customerNote == null ? null : customerNote,
    "billing": billing == null ? null : billing.toJson(),
    "shipping": shipping == null ? null : shipping.toJson(),
    "payment_method": paymentMethod == null ? null : paymentMethod,
    "payment_method_title": paymentMethodTitle == null ? null : paymentMethodTitle,
    "transaction_id": transactionId == null ? null : transactionId,
    "cart_hash": cartHash == null ? null : cartHash,
    "meta_data": metaData == null ? null : List<dynamic>.from(metaData.map((x) => x.toJson())),
    "line_items": lineItems == null ? null : List<dynamic>.from(lineItems.map((x) => x.toJson())),
    "shipping_lines": shippingLines == null ? null : List<dynamic>.from(shippingLines.map((x) => x.toJson())),
    "fee_lines": feeLines == null ? null : List<dynamic>.from(feeLines.map((x) => x)),
    "coupon_lines": couponLines == null ? null : List<dynamic>.from(couponLines.map((x) => x.toJson())),
    //"refunds": refunds == null ? null : List<dynamic>.from(refunds.map((x) => x.toJson())),
  };
}

class CouponLine {
  final int? id;
  final String? code;
  final String? discount;
  final String? discountTax;

  CouponLine({
    this.id,
    this.code,
    this.discount,
    this.discountTax,
  });


  factory CouponLine.fromJson(Map<String, dynamic> json) => CouponLine(
    id: json["id"],
    code: json["code"],
    discount: json["discount"],
    discountTax: json["discount_tax"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "discount": discount,
    "discount_tax": discountTax,
  };
}

class CustomerData {
  CustomerData({
    this.latitude,
    this.longitude,
  });

  String? latitude;
  String? longitude;

  factory CustomerData.fromJson(Map<String?, dynamic> json) => CustomerData(
    latitude: json["latitude"] == null || json["latitude"] == '' ? null : json["latitude"],
    longitude: json["longitude"] == null || json["longitude"] == '' ? null : json["longitude"],
  );

  Map<String?, dynamic> toJson() => {
    "latitude": latitude == null ? null : latitude,
    "longitude": longitude == null ? null : longitude,
  };
}

class DriverData {
  DriverData({
    this.latitude,
    this.longitude,
    this.name,
  });

  String? latitude;
  String? longitude;
  String? name;

  factory DriverData.fromJson(Map<String?, dynamic> json) => DriverData(
    latitude: json["latitude"] is String ? json["latitude"] : null,
    longitude: json["longitude"] is String ? json["longitude"] : null,
    name: json["name"] is String ? json["name"] : null,
  );

  Map<String?, dynamic> toJson() => {
    "latitude": latitude == null ? null : latitude,
    "longitude": longitude == null ? null : longitude,
    "name": name == null ? null : name,
  };
}

class Vendor {
  Vendor({
    this.id,
    this.name,
    this.address,
    this.latitude,
    this.longitude,
    this.icon,
  });

  String? id;
  String? name;
  String? address;
  String? latitude;
  String? longitude;
  String? icon;

  factory Vendor.fromJson(Map<String?, dynamic> json) => Vendor(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    address: json["address"] == null ? null : json["address"],
    latitude: json["latitude"] == null ? null : json["latitude"],
    longitude: json["longitude"] == null ? null : json["longitude"],
    icon: json["icon"] == String ? json["icon"] : null,
  );

  Map<String?, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "address": address == null ? null : address,
    "latitude": latitude == null ? null : latitude,
    "longitude": longitude == null ? null : longitude,
    "icon": icon == null ? null : icon,
  };
}

/*
class Address {
  String firstName;
  String lastName;
  String? company;
  String address1;
  String? address2;
  String city;
  String? state;
  String? postcode;
  String? country;
  String email;
  String phone;

  Address({
    required this.firstName,
    required this.lastName,
    this.company,
    required this.address1,
    this.address2,
    required this.city,
    this.state,
    this.postcode,
    this.country,
    required this.email,
    required this.phone,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    firstName: json["first_name"] == null ? '' : json["first_name"],
    lastName: json["last_name"] == null ? '' : json["last_name"],
    company: json["company"] == null ? null : json["company"],
    address1: json["address_1"] == null ? '' : json["address_1"],
    address2: json["address_2"] == null ? '' : json["address_2"],
    city: json["city"] == null ? '' : json["city"],
    state: json["state"] == null ? null : json["state"],
    postcode: json["postcode"] == null ? null : json["postcode"],
    country: json["country"] == null ? null : json["country"],
    email: json["email"] == null ? '' : json["email"],
    phone: json["phone"] == null ? '' : json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName == null ? null : firstName,
    "last_name": lastName == null ? null : lastName,
    "company": company == null ? null : company,
    "address_1": address1 == null ? null : address1,
    "address_2": address2 == null ? null : address2,
    "city": city == null ? null : city,
    "state": state == null ? null : state,
    "postcode": postcode == null ? null : postcode,
    "country": country == null ? null : country,
    "email": email == null ? null : email,
    "phone": phone == null ? null : phone,
  };
}
*/

class LineItem {
  int? id;
  String name;
  int productId;
  int? variationId;
  int quantity;
  String? taxClass;
  String? subtotal;
  String? subtotalTax;
  double total;
  String? totalTax;
  List<Tax>? taxes;
  List<LineItemMetaDatum>? metaData;
  String? sku;
  double price;
  List<ProductImage> images;
  OrderImage? image;

  LineItem({
    this.id,
    required this.name,
    required this.productId,
    this.variationId,
    required this.quantity,
    this.taxClass,
    this.subtotal,
    this.subtotalTax,
    required this.total,
    this.totalTax,
    this.taxes,
    this.metaData,
    this.sku,
    required this.price,
    this.image,
    required this.images
  });

  factory LineItem.fromJson(Map<String, dynamic> json) => LineItem(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? '' : json["name"],
    productId: json["product_id"] == null ? null : json["product_id"],
    variationId: json["variation_id"] == null ? null : json["variation_id"],
    quantity: json["quantity"] == null ? 0 : json["quantity"],
    taxClass: json["tax_class"] == null ? null : json["tax_class"],
    subtotal: json["subtotal"] == null ? null : json["subtotal"],
    subtotalTax: json["subtotal_tax"] == null ? null : json["subtotal_tax"],
    total: json["total"] == null ? 0 : double.parse(json["total"]),
    totalTax: json["total_tax"] == null ? null : json["total_tax"],
    taxes: json["taxes"] == null ? [] : List<Tax>.from(json["taxes"].map((x) => Tax.fromJson(x))),
    metaData: json["meta_data"] == null ? [] : List<LineItemMetaDatum>.from(json["meta_data"].map((x) => LineItemMetaDatum.fromJson(x))),
    sku: json["sku"] == null ? null : json["sku"],
    price: json["price"] == null ? null : json["price"].toDouble(),
    image: json["image"] == null ? OrderImage.fromJson({}) : OrderImage.fromJson(json["image"]),
    images: json["images"] == null ? [] : List<ProductImage>.from(json["images"].map((x) => ProductImage.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "product_id": productId == null ? null : productId,
    //"variation_id": variationId == null ? null : variationId,
    "quantity": quantity == null ? '1' : quantity,
    //"tax_class": taxClass == null ? null : taxClass,
    //"subtotal": subtotal == null ? null : subtotal,
    //"subtotal_tax": subtotalTax == null ? null : subtotalTax,
    "total": total == null ? '0' : total.toString(),
    //"total_tax": totalTax == null ? null : totalTax,
    //"taxes": taxes == null ? null : List<dynamic>.from(taxes.map((x) => x.toJson())),
    "meta_data": metaData == null ? null : List<dynamic>.from(metaData!.map((x) => x.toJson())),
    //"sku": sku == null ? null : sku,
    //"price": price == null ? null : price,
  };
}

class OrderImage {
  OrderImage({
    required this.id,
    required this.src,
  });

  dynamic id;
  String src;

  factory OrderImage.fromJson(Map<String, dynamic> json) => OrderImage(
    id: json["id"],
    src: json["src"] == null ? '' : json["src"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "src": src == null ? null : src,
  };
}

class LineItemMetaDatum {
  LineItemMetaDatum({
    this.id,
    required this.key,
    this.value,
    this.displayKey,
    this.displayValue,
  });

  int? id;
  String key;
  dynamic value;
  String? displayKey;
  dynamic displayValue;

  factory LineItemMetaDatum.fromJson(Map<String, dynamic> json) => LineItemMetaDatum(
    id: json["id"] == null ? null : json["id"],
    key: json["key"] == null ? '' : json["key"],
    value: json["value"] == null ? null : json["value"],
    displayKey: json["display_key"] == null ? null : json["display_key"],
    displayValue: json["display_value"] == null ? null : json["display_value"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "key": key == null ? null : key,
    "value": value == null ? null : value,
    "display_key": displayKey == null ? null : displayKey,
    "display_value": displayValue == null ? null : displayValue,
  };
}

class Tax {
  int id;
  String total;
  String subtotal;

  Tax({
    required this.id,
    required this.total,
    required this.subtotal,
  });

  factory Tax.fromJson(Map<String, dynamic> json) => Tax(
    id: json["id"] == null ? null : json["id"],
    total: json["total"] == null ? null : json["total"],
    subtotal: json["subtotal"] == null ? null : json["subtotal"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "total": total == null ? null : total,
    "subtotal": subtotal == null ? null : subtotal,
  };
}


class OrderRefund {
  int id;
  String? refund;
  String? total;

  OrderRefund({
    required this.id,
    this.refund,
    this.total,
  });

  factory OrderRefund.fromJson(Map<String, dynamic> json) => OrderRefund(
    id: json["id"] == null ? null : json["id"],
    refund: json["refund"] == null ? null : json["refund"],
    total: json["total"] == null ? null : json["total"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "refund": refund == null ? null : refund,
    "total": total == null ? null : total,
  };
}

class ShippingLine {
  int id;
  String methodTitle;
  String methodId;
  String total;
  String totalTax;
  List<dynamic> taxes;
  List<LineItemMetaDatum> metaData;

  ShippingLine({
    required this.id,
    required this.methodTitle,
    required this.methodId,
    required this.total,
    required this.totalTax,
    required this.taxes,
    required this.metaData,
  });

  factory ShippingLine.fromJson(Map<String, dynamic> json) => ShippingLine(
    id: json["id"] == null ? null : json["id"],
    methodTitle: json["method_title"] == null ? null : json["method_title"],
    methodId: json["method_id"] == null ? null : json["method_id"],
    total: json["total"] == null ? null : json["total"],
    totalTax: json["total_tax"] == null ? null : json["total_tax"],
    taxes: json["taxes"] == null ? [] : List<dynamic>.from(json["taxes"].map((x) => x)),
    metaData: json["meta_data"] == null ? [] : List<LineItemMetaDatum>.from(json["meta_data"].map((x) => LineItemMetaDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "method_title": methodTitle == null ? null : methodTitle,
    "method_id": methodId == null ? null : methodId,
    "total": total == null ? null : total,
    "total_tax": totalTax == null ? null : totalTax,
    "taxes": taxes == null ? null : List<dynamic>.from(taxes.map((x) => x)),
    "meta_data": metaData == null ? null : List<dynamic>.from(metaData.map((x) => x.toJson())),
  };
}

class TaxLine {
  int id;
  String rateCode;
  int rateId;
  String label;
  bool compound;
  String taxTotal;
  String shippingTaxTotal;
  List<dynamic> metaData;

  TaxLine({
    required this.id,
    required this.rateCode,
    required this.rateId,
    required this.label,
    required this.compound,
    required this.taxTotal,
    required this.shippingTaxTotal,
    required this.metaData,
  });

  factory TaxLine.fromJson(Map<String, dynamic> json) => TaxLine(
    id: json["id"] == null ? null : json["id"],
    rateCode: json["rate_code"] == null ? null : json["rate_code"],
    rateId: json["rate_id"] == null ? null : json["rate_id"],
    label: json["label"] == null ? null : json["label"],
    compound: json["compound"] == null ? null : json["compound"],
    taxTotal: json["tax_total"] == null ? null : json["tax_total"],
    shippingTaxTotal: json["shipping_tax_total"] == null ? null : json["shipping_tax_total"],
    metaData: json["meta_data"] == null ? [] : List<dynamic>.from(json["meta_data"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "rate_code": rateCode == null ? null : rateCode,
    "rate_id": rateId == null ? null : rateId,
    "label": label == null ? null : label,
    "compound": compound == null ? null : compound,
    "tax_total": taxTotal == null ? null : taxTotal,
    "shipping_tax_total": shippingTaxTotal == null ? null : shippingTaxTotal,
    "meta_data": metaData == null ? null : List<dynamic>.from(metaData.map((x) => x)),
  };
}
