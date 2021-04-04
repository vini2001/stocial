// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Asset _$AssetFromJson(Map<String, dynamic> json) {
  return Asset(
    code: json['code'] as String,
    company: json['company'] as String,
    price: (json['price'] as num).toDouble(),
    quantity: (json['quantity'] as num).toDouble(),
    currency: json['currency'] as String? ?? 'BRL',
  );
}

Map<String, dynamic> _$AssetToJson(Asset instance) => <String, dynamic>{
      'code': instance.code,
      'company': instance.company,
      'price': instance.price,
      'quantity': instance.quantity,
      'currency': instance.currency,
    };
