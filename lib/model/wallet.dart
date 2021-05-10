import 'asset.dart';

class Wallet {

  Wallet(this.assetsList) {
    _wallet = Map();
    for(Asset asset in assetsList) {
      String type = asset.getAssetType();
      if(!_wallet.containsKey(type)) {
        _wallet[type] = [asset];
      }else{
        _wallet[type]!.add(asset);
      }
    }
  }

  final List<Asset> assetsList;
  late Map<String, List<Asset>?> _wallet;

  List<String>? getGroupsNames() {
    return _wallet.entries.map((e) => e.key).toList();
  }

  int? getGroupSize(String groupIndex) {
    return _wallet[groupIndex]?.length;
  }

  Asset? getAsset(String groupKey, int itemIndex) {
    return _wallet[groupKey]?[itemIndex];
  }

  List<Asset> getAssetsList() {
    return assetsList;
  }
}