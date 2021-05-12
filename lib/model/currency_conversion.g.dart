// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_conversion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyConversion _$CurrencyConversionFromJson(Map<String, dynamic> json) {
  return CurrencyConversion(
    from: json['from'] as String,
    to: json['to'] as String,
    value: const StringDoubleConverter().fromJson(json['value'] as String),
  );
}

Map<String, dynamic> _$CurrencyConversionToJson(CurrencyConversion instance) =>
    <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
      'value': const StringDoubleConverter().toJson(instance.value),
    };
