import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class StringDoubleConverter implements JsonConverter<double, String> {
  const StringDoubleConverter();

  @override
  double fromJson(dynamic data) {
    return double.parse(data);
  }

  @override
  String toJson(double value) {
    return value.toString();
  }
}