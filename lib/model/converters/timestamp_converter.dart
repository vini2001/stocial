import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class TimestampConverter implements JsonConverter<DateTime, dynamic> {
  const TimestampConverter();

  @override
  DateTime fromJson(dynamic data) {
    Timestamp? timestamp;
    if (data is Timestamp) {
      timestamp = data;
    } else if (data is Map) {
      timestamp = Timestamp(data['_seconds'], data['_nanoseconds']);
    }
    return timestamp!.toDate();
  }

  @override
  Map<String, dynamic> toJson(DateTime dateTime) {
    final timestamp = Timestamp.fromDate(dateTime);
    return {
      '_seconds': timestamp.seconds,
      '_nanoseconds': timestamp.nanoseconds,
    };
  }
}