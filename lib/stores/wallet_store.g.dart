// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$WalletStore on _WalletStore, Store {
  final _$searchQueryAtom = Atom(name: '_WalletStore.searchQuery');

  @override
  String? get searchQuery {
    _$searchQueryAtom.reportRead();
    return super.searchQuery;
  }

  @override
  set searchQuery(String? value) {
    _$searchQueryAtom.reportWrite(value, super.searchQuery, () {
      super.searchQuery = value;
    });
  }

  final _$showCEIImportAtom = Atom(name: '_WalletStore.showCEIImport');

  @override
  bool get showCEIImport {
    _$showCEIImportAtom.reportRead();
    return super.showCEIImport;
  }

  @override
  set showCEIImport(bool value) {
    _$showCEIImportAtom.reportWrite(value, super.showCEIImport, () {
      super.showCEIImport = value;
    });
  }

  final _$loadingAtom = Atom(name: '_WalletStore.loading');

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  final _$cpfCeiAtom = Atom(name: '_WalletStore.cpfCei');

  @override
  String? get cpfCei {
    _$cpfCeiAtom.reportRead();
    return super.cpfCei;
  }

  @override
  set cpfCei(String? value) {
    _$cpfCeiAtom.reportWrite(value, super.cpfCei, () {
      super.cpfCei = value;
    });
  }

  final _$passwordCeiAtom = Atom(name: '_WalletStore.passwordCei');

  @override
  String? get passwordCei {
    _$passwordCeiAtom.reportRead();
    return super.passwordCei;
  }

  @override
  set passwordCei(String? value) {
    _$passwordCeiAtom.reportWrite(value, super.passwordCei, () {
      super.passwordCei = value;
    });
  }

  final _$usdBrlExchangeRateAtom =
      Atom(name: '_WalletStore.usdBrlExchangeRate');

  @override
  double? get usdBrlExchangeRate {
    _$usdBrlExchangeRateAtom.reportRead();
    return super.usdBrlExchangeRate;
  }

  @override
  set usdBrlExchangeRate(double? value) {
    _$usdBrlExchangeRateAtom.reportWrite(value, super.usdBrlExchangeRate, () {
      super.usdBrlExchangeRate = value;
    });
  }

  final _$initAsyncAction = AsyncAction('_WalletStore.init');

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  final _$_WalletStoreActionController = ActionController(name: '_WalletStore');

  @override
  void onSearchQueryChanged(String? query) {
    final _$actionInfo = _$_WalletStoreActionController.startAction(
        name: '_WalletStore.onSearchQueryChanged');
    try {
      return super.onSearchQueryChanged(query);
    } finally {
      _$_WalletStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onCpfCeiChanged(String? cpf) {
    final _$actionInfo = _$_WalletStoreActionController.startAction(
        name: '_WalletStore.onCpfCeiChanged');
    try {
      return super.onCpfCeiChanged(cpf);
    } finally {
      _$_WalletStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onPasswordCeiChanged(String? pass) {
    final _$actionInfo = _$_WalletStoreActionController.startAction(
        name: '_WalletStore.onPasswordCeiChanged');
    try {
      return super.onPasswordCeiChanged(pass);
    } finally {
      _$_WalletStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool isAssetVisible({required String groupKey, required int itemIndex}) {
    final _$actionInfo = _$_WalletStoreActionController.startAction(
        name: '_WalletStore.isAssetVisible');
    try {
      return super.isAssetVisible(groupKey: groupKey, itemIndex: itemIndex);
    } finally {
      _$_WalletStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
searchQuery: ${searchQuery},
showCEIImport: ${showCEIImport},
loading: ${loading},
cpfCei: ${cpfCei},
passwordCei: ${passwordCei},
usdBrlExchangeRate: ${usdBrlExchangeRate}
    ''';
  }
}
