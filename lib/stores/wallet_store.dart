import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobx/mobx.dart';
import 'package:stocial/constants/constants.dart';
import 'package:stocial/constants/routes.dart';
import 'package:stocial/model/asset.dart';
import 'package:stocial/model/currency_conversion.dart';
import 'package:stocial/model/ticker.dart';
import 'package:stocial/model/wallet.dart';

import '../main.dart';
import '../user.dart';
import 'base_state_store.dart';

part 'wallet_store.g.dart';

class WalletStore = _WalletStore with _$WalletStore;

abstract class _WalletStore  with Store {

  _WalletStore(this.baseStateStore);

  @observable
  String? searchQuery = "";

  @observable
  bool showCEIImport = false;

  @observable
  bool loading = false;

  @observable
  bool notifyWalletTable = false;

  @observable
  String? cpfCei;

  @observable
  String? passwordCei;

  @observable
  double? usdBrlExchangeRate;

  @action
  Future<void> init() async {
    getQuotes();
    getWallet();
  }

  @action
  void onSearchQueryChanged(String? query) {
    searchQuery = query;
  }

  @action
  void onCpfCeiChanged(String? cpf) {
    this.cpfCei = cpf;
  }

  @action
  void onPasswordCeiChanged(String? pass) {
    this.passwordCei = pass;
  }

  BaseStateStore baseStateStore;


  // call the cloud function to assure we have the latest prices for the quotes
  Future getQuotes() async {
    print("getQuotes: loading...");
    final callable = FirebaseFunctions.instance.httpsCallable('getQuotes');
    try {
      final x = await callable({});
      print("getQuotes: ${x.data}");
      updateQuotes();
    } on FirebaseFunctionsException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  Future refreshCEI() async {
    showCEIImport = true;

    if(supportSecureStorage()) {
      FlutterSecureStorage storage = FlutterSecureStorage();
      final user = await storage.read(key: cei_user);
      final pass = await storage.read(key: cei_password);

      if(user != null && pass != null) {
        cpfCei = user;
        passwordCei = pass;
      }
    }
  }

  Future<void> updateCurrencies() async {
    if(firestore != null) {
      List<QueryDocumentSnapshot> docs = (await firestore!.collection('currencies').get()).docs;
      for(QueryDocumentSnapshot snapshot in docs) {
        if(snapshot.data() != null) {
          final ticker = CurrencyConversion.fromJson(snapshot.data()!);
          if(ticker.from == 'USD' && ticker.to == 'BRL') {
            usdBrlExchangeRate = ticker.value;
          }
          debugPrint(ticker.value.toString());
        }
      }
    }
  }

  Future<void> updateQuotes() async {
    debugPrint("toUpdateQuotes");

    await Future.forEach(wallet!.getAssetsList(), (Asset asset) async {
      List<QueryDocumentSnapshot>? docs = (await firestore?.collection('tickers').where('symbol', isEqualTo: asset.code).get())?.docs;
      if(docs != null) {
        for(QueryDocumentSnapshot snapshot in docs) {
          if(snapshot.data() != null) {
            final ticker = Ticker.fromJson(snapshot.data()!);
            wallet?.updateTicker(ticker);
            debugPrint('ticket updated: ${ticker.symbol}');
          }
        }
      }
    });

    debugPrint("quotes updated successfully");
    notifyWalletTable = true;
  }


  Future<void> tdAmeritrade() async {
    baseStateStore.goToRouteNamed(Routes.tdAmeritrade, onReturn: (dynamic argument) {
      if(argument != null) {
        final imported = argument as bool;
        print("imported: $imported");
        if(imported is bool && imported) getWallet();
      }
    });
  }

  bool isMobile() {
    try {
      return (Platform.isAndroid || Platform.isIOS);
    }catch(ex) {
      return false;
    }
  }

  Future<void> logout() async {
    if(auth != null) {
      await auth!.signOut();
      baseStateStore.goToRouteReplacement(Routes.login);
    }
  }

  Future importCEI() async {
    stocialUser.cpfCEI = cpfCei;
    stocialUser.passwordCEI = passwordCei;

    if(supportSecureStorage()) {
      FlutterSecureStorage storage = FlutterSecureStorage();
      storage.write(key: cei_user, value: stocialUser.cpfCEI);
      storage.write(key: cei_password, value: stocialUser.passwordCEI);
    }

    showCEIImport = false;
    loading = true;

    final callable = FirebaseFunctions.instance.httpsCallable('importCei');

    try {
      final x = await callable({
        "userId": stocialUser.uid,
        "cpf_cei":  stocialUser.cpfCEI,
        "password_cei": stocialUser.passwordCEI
      });
      print(x.data);
      await getWallet();
    } on FirebaseFunctionsException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  Future getWallet() async {
    List<QueryDocumentSnapshot>? docs = (await firestore?.collection('assets').where('user_id', isEqualTo: stocialUser.uid).orderBy('code').get())?.docs;

    if(docs != null) {
      assetsList = docs.map((snapshot) => Asset.fromJson(snapshot.data()!)).toList();
      if(assetsList != null) {
        wallet = Wallet(assetsList!);
      }
      loading = false;

      updateCurrencies();
      updateQuotes();
    }
  }

  @action
  bool isAssetVisible({required String groupKey, required int itemIndex}) {
    return wallet?.getAsset(groupKey, itemIndex)?.contains(searchQuery ?? '') ?? true;
  }

  Wallet? wallet;
  List<Asset>? assetsList;
  StocialUser stocialUser = StocialUser();

  bool supportSecureStorage() => Platform.isAndroid || Platform.isIOS || Platform.isLinux;
}
