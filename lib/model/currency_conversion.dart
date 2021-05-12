import 'package:json_annotation/json_annotation.dart';
import 'package:stocial/model/converters/string_number_converter.dart';

part 'currency_conversion.g.dart';

@JsonSerializable()
class CurrencyConversion {
  final String from;
  final String to;
  @StringDoubleConverter()
  final double value;

  CurrencyConversion({required this.from, required this.to, required this.value});

  factory CurrencyConversion.fromJson(Map<String, dynamic> json) => _$CurrencyConversionFromJson(json);
  Map<String, dynamic> toJson() => _$CurrencyConversionToJson(this);
}