// To parse this JSON data, do
//
//     final giftCardModel = giftCardModelFromJson(jsonString);

import 'dart:convert';

import 'package:admin/src/models/refund/refund_model.dart';

List<GiftCardModel> giftCardModelFromJson(String str) => List<GiftCardModel>.from(json.decode(str).map((x) => GiftCardModel.fromJson(x)));

String giftCardModelToJson(List<GiftCardModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GiftCardModel {
  GiftCardModel({
    required this.id,
    required this.code,
    required this.recipient,
    required this.sender,
    required this.senderEmail,
    required this.message,
    required this.balance,
    required this.remaining,
    required this.orderId,
    required this.orderItemId,
    required this.createDate,
    required this.deliverDate,
    required this.expireDate,
    required this.redeemDate,
    required this.redeemedBy,
    required this.delivered,
    required this.isActive,
    required this.activities,
    required this.metaData,
  });

  int? id;
  String code;
  String recipient;
  String sender;
  String senderEmail;
  String message;
  num? balance;
  num? remaining;
  int? orderId;
  int? orderItemId;
  DateTime createDate;
  DateTime? deliverDate;
  DateTime? expireDate;
  DateTime? redeemDate;
  DateTime? redeemedBy;
  String? delivered;
  String isActive;
  List<Activity> activities;
  List<MetaDatum> metaData;

  factory GiftCardModel.fromJson(Map<String, dynamic> json) => GiftCardModel(
    id: json["id"] == null ? 0 : json["id"],
    code: json["code"] == null ? '' : json["code"],
    recipient: json["recipient"] == null ? '' : json["recipient"],
    sender: json["sender"] == null ? '' : json["sender"],
    senderEmail: json["sender_email"] == null ? '' : json["sender_email"],
    message: json["message"] == null ? '' : json["message"],
    balance: json["balance"] == null ? null : json["balance"],
    remaining: json["remaining"] == null ? null : json["remaining"],
    orderId: json["order_id"] == null ? null : json["order_id"],
    orderItemId: json["order_item_id"] == null ? null : json["order_item_id"],
    createDate: json["create_date"] == null ? DateTime.now() : DateTime.parse(json["create_date"]),
    deliverDate: json["deliver_date"] is String ? DateTime.parse(json["deliver_date"]) : null,
    expireDate: json["expire_date"] is String ? DateTime.parse(json["expire_date"]) : null,
    redeemDate: json["redeem_date"] is String ? DateTime.parse(json["redeem_date"]) : null,
    redeemedBy: json["redeemed_by"] is String ? DateTime.parse(json["redeemed_by"]) : null,
    delivered: json["delivered"] is String ? json["delivered"] : null,
    isActive: json["is_active"] == null ? 'on' : json["is_active"],
    activities: json["activities"] == null ? [] : List<Activity>.from(json["activities"].map((x) => Activity.fromJson(x))),
    metaData: json["meta_data"] == null ? [] : List<MetaDatum>.from(json["meta_data"].map((x) => MetaDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "code": code == null ? null : code,
    "recipient": recipient == null ? null : recipient,
    "sender": sender == null ? null : sender,
    "sender_email": senderEmail == null ? null : senderEmail,
    "message": message == null ? null : message,
    "balance": balance == null ? null : balance,
    "remaining": remaining == null ? null : remaining,
    "order_id": orderId == null ? null : orderId,
    "order_item_id": orderItemId == null ? null : orderItemId,
    "create_date": createDate == null ? null : createDate.toIso8601String(),
    "deliver_date": deliverDate == null ? null : deliverDate,
    "expire_date": expireDate == null ? null : expireDate,
    "redeem_date": redeemDate == null ? null : redeemDate,
    "redeemed_by": redeemedBy == null ? null : redeemedBy,
    "delivered": delivered == null ? null : delivered,
    "is_active": isActive == null ? null : isActive,
    "activities": activities == null ? null : List<dynamic>.from(activities.map((x) => x.toJson())),
    "meta_data": metaData == null ? null : List<dynamic>.from(metaData.map((x) => x)),
  };
}

class Activity {
  Activity({
    required this.id,
    required this.type,
    required this.userId,
    required this.userEmail,
    required this.objectId,
    required this.gcId,
    required this.gcCode,
    required this.amount,
    required this.date,
    required this.note,
  });

  int id;
  String type;
  int userId;
  String userEmail;
  int objectId;
  int gcId;
  String gcCode;
  num amount;
  DateTime? date;
  String? note;

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
    id: json["id"] == null ? null : json["id"],
    type: json["type"] == null ? null : json["type"],
    userId: json["user_id"] == null ? null : json["user_id"],
    userEmail: json["user_email"] == null ? null : json["user_email"],
    objectId: json["object_id"] == null ? null : json["object_id"],
    gcId: json["gc_id"] == null ? null : json["gc_id"],
    gcCode: json["gc_code"] == null ? null : json["gc_code"],
    amount: json["amount"] == null ? null : json["amount"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    note: json["note"] == null ? null : json["note"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "type": type == null ? null : type,
    "user_id": userId == null ? null : userId,
    "user_email": userEmail == null ? null : userEmail,
    "object_id": objectId == null ? null : objectId,
    "gc_id": gcId == null ? null : gcId,
    "gc_code": gcCode == null ? null : gcCode,
    "amount": amount == null ? null : amount,
    "note": note == null ? null : note,
  };
}
