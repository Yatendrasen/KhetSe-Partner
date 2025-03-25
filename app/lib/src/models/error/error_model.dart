import 'package:json_annotation/json_annotation.dart';
part 'error_model.g.dart';

@JsonSerializable()
class Errors {
  String code;
  String message;
  //Data data;

  Errors({
    required this.code,
    required this.message,
    //required this.data,
  });

  factory Errors.fromJson(Map<String, dynamic> json) => _$ErrorsFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorsToJson(this);
}

class Data {
  int status;
  Params params;

  Data({
    required this.status,
    required this.params,
  });

  factory Data.fromJson(Map<String, dynamic> json) => new Data(
    status: json["status"],
    params: Params.fromJson(json["params"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "params": params.toJson(),
  };
}

class Params {
  String billing;
  String shipping;

  Params({
    required this.billing,
    required this.shipping,
  });

  factory Params.fromJson(Map<String, dynamic> json) => new Params(
    billing: json["billing"],
    shipping: json["shipping"],
  );

  Map<String, dynamic> toJson() => {
    "billing": billing,
    "shipping": shipping,
  };
}