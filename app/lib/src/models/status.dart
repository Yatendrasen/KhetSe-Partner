// To parse this JSON data, do
//
//     final status = statusFromJson(jsonString);

import 'dart:convert';

Status statusFromJson(String str) => Status.fromJson(json.decode(str));

String statusToJson(Status data) => json.encode(data.toJson());

class Status {
  Status({
    this.status,
    this.message,
  });

  bool? status;
  String? message;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
  };
}

List<DeliveryIds> deliveryIdsFromJson(String str) => List<DeliveryIds>.from(json.decode(str).map((x) => DeliveryIds.fromJson(x)));

class DeliveryIds {
  DeliveryIds({
    required this.id,
  });

  String id;

  factory DeliveryIds.fromJson(Map<String, dynamic> json) => DeliveryIds(
    id: json["ID"] == null ? [] : json["ID"],
  );
}
