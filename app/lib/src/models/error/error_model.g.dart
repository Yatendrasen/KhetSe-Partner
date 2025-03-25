// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Errors _$ErrorsFromJson(Map<String, dynamic> json) {
  return Errors(
      code: json['code'] as String, message: json['message'] as String);
}

Map<String, dynamic> _$ErrorsToJson(Errors instance) =>
    <String, dynamic>{'code': instance.code, 'message': instance.message};
