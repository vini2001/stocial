import 'package:stocial/model/currency_conversion.dart';
import 'package:stocial/model/ticker.dart';

import 'asset.dart';

class Wallet {

  double? usdBrlExchangeRate;

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

  void updateTicker(Ticker ticker) {
    for(var asset in assetsList) {
      if(asset.code == ticker.symbol) {
        asset.price = ticker.latestPrice;
        break;
      }
    }
  }


  List<String>? getGroupsTotals() {
    List<String> walletInfo = [];
    _wallet.forEach((key, assets) {
      final total = _getCategoryTotal(key);
      if(assets![0].currency == 'American Dollars' && usdBrlExchangeRate != null) {
        walletInfo.add('${getCurrencySymbol(assets[0].currency)}${total.toStringAsFixed(2)} / R\$${(total * usdBrlExchangeRate!).toStringAsFixed(2)}');
      }else{
        walletInfo.add('${getCurrencySymbol(assets[0].currency)}${total.toStringAsFixed(2)}');
      }
    });

    return walletInfo;
  }

  String getCurrencySymbol(String currency) {
    switch(currency) {
      case 'American Dollars': return '\$';
      case 'BRL': return 'R\$';
    }
    return '';
  }

  void addCurrencyConversion(CurrencyConversion currencyConversion) {
    if(currencyConversion.from == 'USD' && currencyConversion.to == 'BRL') {
      usdBrlExchangeRate = currencyConversion.value;
    }
  }

  double _getCategoryTotal(String key) {
    var total = 0.0;

    for(Asset asset in _wallet[key]!) {
      total += (asset.quantity) * (asset.price);
    }
    return total;
  }
}