import 'package:json_annotation/json_annotation.dart';
import 'package:stocial/model/converters/timestamp_converter.dart';

part 'ticker.g.dart';

@JsonSerializable()
class Ticker {

  @TimestampConverter()
  final DateTime lastRefresh;
  final String currency;
  final double latestPrice;
  final String symbol;

  Ticker({required this.lastRefresh, required this.currency, required this.latestPrice, required this.symbol});

  factory Ticker.fromJson(Map<String, dynamic> json) => _$TickerFromJson(json);
  Map<String, dynamic> toJson() => _$TickerToJson(this);
}
