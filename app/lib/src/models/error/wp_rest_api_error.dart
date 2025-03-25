// To parse this JSON data, do
//
//     final wpRestApiError = wpRestApiErrorFromJson(jsonString);

import 'dart:convert';

WooError wooErrorFromJson(String str) => WooError.fromJson(json.decode(str));

String wpRestApiErrorToJson(WooError data) => json.encode(data.toJson());

class WooError {
  WooError({
    required this.code,
    required this.message,
    required this.data,
  });

  String code;
  String message;
  Data data;

  factory WooError.fromJson(Map<String, dynamic> json) => WooError(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? Data.fromJson({}) : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "message": message == null ? null : message,
    "data": data == null ? null : data.toJson(),
  };
}

class Data {
  Data({
    required this.status,
  });

  int status;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
  };
}
