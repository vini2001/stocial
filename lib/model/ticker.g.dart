// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ticker _$TickerFromJson(Map<String, dynamic> json) {
  return Ticker(
    lastRefresh: const TimestampConverter().fromJson(json['lastRefresh']),
    currency: json['currency'] as String,
    latestPrice: (json['latestPrice'] as num).toDouble(),
    symbol: json['symbol'] as String,
  );
}

Map<String, dynamic> _$TickerToJson(Ticker instance) => <String, dynamic>{
      'lastRefresh': const TimestampConverter().toJson(instance.lastRefresh),
      'currency': instance.currency,
      'latestPrice': instance.latestPrice,
      'symbol': instance.symbol,
    };
