import 'package:json_annotation/json_annotation.dart';

part 'institution.g.dart';

@JsonSerializable()
class Institution {
  final String country;
  final String name;

  Institution({required this.country, required this.name});

  factory Institution.fromJson(Map<String, dynamic> json) => _$InstitutionFromJson(json);
  Map<String, dynamic> toJson() => _$InstitutionToJson(this);
}