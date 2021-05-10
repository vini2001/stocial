import 'package:json_annotation/json_annotation.dart';

part 'asset.g.dart';

@JsonSerializable()
class Asset {
  final String code;
  final String company;
  final double price;
  final double quantity;

  @JsonKey(defaultValue: "BRL")
  final String currency;

  @JsonKey(ignore: true)
  bool visible = true;

  Asset({required this.code, required this.company, required this.price, required this.quantity, required this.currency});

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);
  Map<String, dynamic> toJson() => _$AssetToJson(this);

  String getCurrencySymbol() {
    switch(currency) {
      case 'American Dollars': return 'USD';
      default: return 'R\$ ';
    }
  }

  String getAssetType() {
    switch(currency) {
      case 'American Dollars': return 'Ações Americanas';
      default: return 'Ações';
    }
  }

  bool contains(String searchQuery) {
    searchQuery = searchQuery.toLowerCase();
    return code.toLowerCase().contains(searchQuery) || company.toLowerCase().contains(searchQuery);
  }

}