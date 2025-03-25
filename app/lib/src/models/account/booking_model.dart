// To parse this JSON data, do
//
//     final bookingModel = bookingModelFromJson(jsonString);

import 'dart:convert';

List<BookingModel> bookingModelFromJson(String str) => List<BookingModel>.from(json.decode(str).map((x) => BookingModel.fromJson(x)));

class BookingModel {
  BookingModel({
    required this.id,
    required this.orderId,
    required this.productTitle,
    required this.productId,
    required this.startDate,
    required this.endDate,
    required this.hasPersons,
    this.persons,
    required this.status,
    required this.calcelUrl,
  });

  int id;
  String orderId;
  String productTitle;
  int productId;
  String startDate;
  String endDate;
  String status;
  bool hasPersons;
  int? persons;
  String calcelUrl;

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
    id: json["id"] == null ? null : json["id"],
    orderId: json["order_id"] == null ? null : json["order_id"],
    productTitle: json["product_title"] == null ? null : json["product_title"],
    productId: json["product_id"] == null ? null : json["product_id"],
    startDate: json["start_date"] == null ? null : json["start_date"],
    endDate: json["end_date"] == null ? null : json["end_date"],
    hasPersons: json["has_persons"] == true ? true : false,
    persons: json["persons"] == null ? null : json["persons"],
    status: json["status"] == null ? '' : json["status"],
    calcelUrl: json["calcel_url"] == null ? '' : json["calcel_url"],
  );
}
