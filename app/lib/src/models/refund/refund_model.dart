import 'dart:convert';

class RefundsModel {
  final List<Refund> refunds;

  RefundsModel({
    required this.refunds,
  });

  factory RefundsModel.fromJson(List<dynamic> parsedJson) {

    List<Refund> refunds = [];
    refunds = parsedJson.map((i)=>Refund.fromJson(i)).toList();

    return new RefundsModel(refunds : refunds);
  }

}
// To parse this JSON data, do
//
//     final refund = refundFromJson(jsonString);



List<Refund> refundFromJson(String str) => List<Refund>.from(json.decode(str).map((x) => Refund.fromJson(x)));

String refundToJson(List<Refund> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Refund {
  int? id;
  DateTime dateCreated;
  DateTime dateCreatedGmt;
  String amount;
  String reason;
  int refundedBy;
  bool refundedPayment;
  List<dynamic> metaData;
  List<LineItem> lineItems;

  Refund({
    required this.id,
    required this.dateCreated,
    required this.dateCreatedGmt,
    required this.amount,
    required this.reason,
    required this.refundedBy,
    required this.refundedPayment,
    required this.metaData,
    required this.lineItems,
  });

  factory Refund.fromJson(Map<String, dynamic> json) => Refund(
    id: json["id"] == null ? null : json["id"],
    dateCreated: json["date_created"] == null ? DateTime.now() : DateTime.parse(json["date_created"]),
    dateCreatedGmt: json["date_created_gmt"] == null ? DateTime.now() : DateTime.parse(json["date_created_gmt"]),
    amount: json["amount"] == null ? '0' : json["amount"],
    reason: json["reason"] == null ? '' : json["reason"],
    refundedBy: json["refunded_by"] == null ? 0 : json["refunded_by"],
    refundedPayment: json["refunded_payment"] == null ? false : json["refunded_payment"],
    metaData: json["meta_data"] == null ? [] : List<dynamic>.from(json["meta_data"].map((x) => x)),
    lineItems: json["line_items"] == null ? [] : List<LineItem>.from(json["line_items"].map((x) => LineItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "date_created": dateCreated == null ? null : dateCreated.toIso8601String(),
    "date_created_gmt": dateCreatedGmt == null ? null : dateCreatedGmt.toIso8601String(),
    "amount": amount == null ? null : amount,
    "reason": reason == null ? null : reason,
    "refunded_by": refundedBy == null ? null : refundedBy,
    "refunded_payment": refundedPayment == null ? null : refundedPayment,
    "meta_data": metaData == null ? null : List<dynamic>.from(metaData.map((x) => x)),
    "line_items": lineItems == null ? null : List<dynamic>.from(lineItems.map((x) => x.toJson())),
  };
}

class LineItem {
  int id;
  String name;
  int productId;
  int variationId;
  int quantity;
  String taxClass;
  String subtotal;
  String subtotalTax;
  String total;
  String totalTax;
  List<dynamic> taxes;
  List<MetaDatum> metaData;
  String sku;
  int price;

  LineItem({
    required this.id,
    required this.name,
    required this.productId,
    required this.variationId,
    required this.quantity,
    required this.taxClass,
    required this.subtotal,
    required this.subtotalTax,
    required this.total,
    required this.totalTax,
    required this.taxes,
    required this.metaData,
    required this.sku,
    required this.price,
  });

  factory LineItem.fromJson(Map<String, dynamic> json) => LineItem(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    productId: json["product_id"] == null ? null : json["product_id"],
    variationId: json["variation_id"] == null ? null : json["variation_id"],
    quantity: json["quantity"] == null ? null : json["quantity"],
    taxClass: json["tax_class"] == null ? null : json["tax_class"],
    subtotal: json["subtotal"] == null ? null : json["subtotal"],
    subtotalTax: json["subtotal_tax"] == null ? null : json["subtotal_tax"],
    total: json["total"] == null ? null : json["total"],
    totalTax: json["total_tax"] == null ? null : json["total_tax"],
    taxes: json["taxes"] == null ? [] : List<dynamic>.from(json["taxes"].map((x) => x)),
    metaData: json["meta_data"] == null ? [] : List<MetaDatum>.from(json["meta_data"].map((x) => MetaDatum.fromJson(x))),
    sku: json["sku"] == null ? null : json["sku"],
    price: json["price"] == null ? null : json["price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "product_id": productId == null ? null : productId,
    "variation_id": variationId == null ? null : variationId,
    "quantity": quantity == null ? null : quantity,
    "tax_class": taxClass == null ? null : taxClass,
    "subtotal": subtotal == null ? null : subtotal,
    "subtotal_tax": subtotalTax == null ? null : subtotalTax,
    "total": total == null ? null : total,
    "total_tax": totalTax == null ? null : totalTax,
    "taxes": taxes == null ? null : List<dynamic>.from(taxes.map((x) => x)),
    "meta_data": metaData == null ? null : List<dynamic>.from(metaData.map((x) => x.toJson())),
    "sku": sku == null ? null : sku,
    "price": price == null ? null : price,
  };
}

class MetaDatum {
  int id;
  String key;
  String value;

  MetaDatum({
    required this.id,
    required this.key,
    required this.value,
  });

  factory MetaDatum.fromJson(Map<String, dynamic> json) => MetaDatum(
    id: json["id"] == null ? null : json["id"],
    key: json["key"] == null ? null : json["key"],
    value: json["value"] == null ? null : json["value"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "key": key == null ? null : key,
    "value": value == null ? null : value,
  };
}
