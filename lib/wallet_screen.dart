
import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stocial/base_state.dart';
import 'package:stocial/constants/colors.dart';
import 'package:stocial/model/asset.dart';
import 'package:stocial/model/ticker.dart';

import 'package:stocial/constants/constants.dart';
import 'package:stocial/widgets/grouped_list.dart';
import 'package:stocial/widgets/stocial_text_field.dart';
import 'package:stocial/user.dart';

import 'constants/routes.dart';
import 'main.dart';
import 'model/currency_conversion.dart';
import 'model/wallet.dart';

class WalletScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WalletState();
  }

}

class WalletState extends BaseState<WalletScreen> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Wallet? wallet;
  List<Asset>? assetsList;

  var _searchController = TextEditingController();
  StocialUser stocialUser = StocialUser();

  var _cpfCEIController = TextEditingController();
  var _passwordCEIController = TextEditingController();

  StreamSubscription<DocumentSnapshot>? userStream;

  bool showCEIImport = false;
  bool loading = false;

  String? _searchQuery;

  @override
  void initState() {
    super.initState();
    getQuotes();
    getWallet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            if(loading) Padding(
              padding: EdgeInsets.only(top: 20),
              child: CircularProgressIndicator(),
            ),
            if(showCEIImport) _buildCEIImport(),
            Container(
              margin: EdgeInsets.only(top: 20),
              width: 300,
              child: StocialTextField(
                textFieldKey: const Key('wallet-search-text-field'),
                labelText: 'Search',
                controller: _searchController,
                onChanged: _search,
              ),
            ),
            Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 0),
                  width: MediaQuery.of(context).size.width - 20,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: -3)
                      ]
                  ),
                  child: _buildWalletList(wallet),
                )
            ),
            Container(
              width: double.infinity,
              color: colorPrimary,
              padding: EdgeInsets.only(right: 8, bottom: 5, top: 8, left: 8),
              margin: EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  _getUsdBrlWidget()
                ],
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        title: Container(
          alignment: Alignment.center,
          width: double.infinity,
          child: Text('Stocial'),
        ),
        leading: null,
        actions: [
          Builder(builder: (context) {
            return IconButton(
              icon: Icon(Icons.person),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            );
          })
        ],
      ),
      endDrawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor
              ),
              child: Container(
                width: double.infinity,
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  'Stocial',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Import from TD Ameritrade'),
              onTap: tdAmeritrade,
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Import from CEI'),
              onTap: () {
                refreshCEI();
                pop();
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }

  Future getWallet() async {
    List<QueryDocumentSnapshot> docs = (await firestore.collection('assets').where('user_id', isEqualTo: stocialUser.uid).orderBy('code').get()).docs;

    setState(() {
      assetsList = docs.map((snapshot) => Asset.fromJson(snapshot.data()!)).toList();
      if(assetsList != null) {
        wallet = Wallet(assetsList!);
      }
      loading = false;
    });

    updateCurrencies();
    updateQuotes();
  }

  void groupWallet(wallet) {

  }

  Widget _buildStockItem(Asset asset) {
    if(!(asset.visible)) return Container();
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            asset.code,
            style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 18,
                color: Colors.black
            ),
          ),
          Container(height: 13),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${asset.quantity}",
                style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 12,
                    color: Colors.black
                ),
              ),
              // if(asset.averagePrice != null) Container(
              //   child: Text('${(((((stock['price'] - stock['averagePrice']) / stock['averagePrice'])) * 100) as double).toStringAsFixed(2)} %'),
              // ),
              Text(
                "${asset.getCurrencySymbol()}${(asset.price * 1.0).toStringAsFixed(2)}",
                style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 12,
                    color: Colors.black
                ),
              ),
            ],
          ),
          Divider()
        ],
      ),
    );
  }


  void _search(String? value) {
   setState(() {
     _searchQuery = value;
   });
  }

  _buildCEIImport() {
    return Container(
      width: 700,
      child: Card(
        margin: EdgeInsets.all(50),
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                "Importar Portfolio do CEI",
                style: TextStyle(
                    fontSize: 16
                ),
              ),
              Divider(height: 40),
              StocialTextField(
                controller: _cpfCEIController,
                labelText: 'CPF CEI',
                keyboardType: TextInputType.number,
              ),
              StocialTextField(
                controller: _passwordCEIController,
                labelText: 'Senha CEI',
                obscureText: true,
              ),
              ElevatedButton(onPressed: () {
                importCEI();
              }, child: Text('Importar'))
            ],
          ),
        ),
      ),
    );
  }

  Future importCEI() async {
    stocialUser.cpfCEI = _cpfCEIController.text;
    stocialUser.passwordCEI = _passwordCEIController.text;

    FlutterSecureStorage storage = FlutterSecureStorage();
    storage.write(key: cei_user, value: stocialUser.cpfCEI);
    storage.write(key: cei_password, value: stocialUser.passwordCEI);

    setState(() {
      showCEIImport = false;
      loading = true;
    });

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
    setState(() {
      showCEIImport = true;
    });

    FlutterSecureStorage storage = FlutterSecureStorage();
    final user = await storage.read(key: cei_user);
    final pass = await storage.read(key: cei_password);

    if(user != null && pass != null) {
      _cpfCEIController.text = user;
      _passwordCEIController.text = pass;
    }

  }

  Future<void> updateCurrencies() async {
    List<QueryDocumentSnapshot> docs = (await firestore.collection('currencies').get()).docs;
    for(QueryDocumentSnapshot snapshot in docs) {
      if(snapshot.data() != null) {
        final ticker = CurrencyConversion.fromJson(snapshot.data()!);
        wallet?.addCurrencyConversion(ticker);
      }
    }
  }

  Future<void> updateQuotes() async {
    print("toUpdateQuotes");

    for(Asset asset in wallet!.getAssetsList()) {
      List<QueryDocumentSnapshot> docs = (await firestore.collection('tickers').where('symbol', isEqualTo: asset.code).get()).docs;
      for(QueryDocumentSnapshot snapshot in docs) {
        if(snapshot.data() != null) {
          final ticker = Ticker.fromJson(snapshot.data()!);
          wallet?.updateTicker(ticker);
        }
      }
    }

    setState(() {});
  }


  Future<void> tdAmeritrade() async {
    final imported =  await Navigator.of(context).pushNamed(Routes.tdAmeritradeKey) as bool;
    print("imported: $imported");
    if(imported is bool && imported) getWallet();
  }

  bool isMobile() {
    try {
      return (Platform.isAndroid || Platform.isIOS);
    }catch(ex) {
      return false;
    }
  }

  _buildWalletList(Wallet? wallet) {
    if(wallet == null) return Container();

    return StocialGroupedList(
        groupsNames: wallet.getGroupsNames() ?? [],
        groupsInfo: wallet.getGroupsTotals(),
        groupSize: (String groupIndex) => wallet.getGroupSize(groupIndex) ?? 0,
        color: colorPrimary,
        columns: ['Ticker', 'Price', 'Qtt', 'Total'],
        valueFor: ({required int columnIndex, required String groupKey, required int itemIndex}) {
          Asset? asset = wallet.getAsset(groupKey, itemIndex);
          if(asset != null) {
            switch(columnIndex) {
              case 0: return asset.code;
              case 1: return "${wallet.getCurrencySymbol(asset.currency)} ${(asset.price * 1.0).toStringAsFixed(2)}";
              case 2: return asset.quantity.toString();
              case 3: return "${wallet.getCurrencySymbol(asset.currency)} ${(asset.quantity * asset.price).toStringAsFixed(2)}";
            }
          }
          return "";
        },
        isVisible: ({required String groupKey, required int itemIndex}) {
          return wallet.getAsset(groupKey, itemIndex)?.contains(_searchQuery ?? '') ?? true;
        }
    );
  }

  _getUsdBrlWidget() {
    if(wallet?.usdBrlExchangeRate == null) return Container();
    return Container(
      decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.all(Radius.circular(4))
      ),
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: Text(
        'USD/BRL: ${wallet!.usdBrlExchangeRate}',
        style: TextStyle(
            fontSize: 12,
            color: Colors.white
        ),
      ),
    );
  }

  Future<void> _logout() async {
    if(auth != null) {
      await auth!.signOut();
      Navigator.of(context).pushReplacementNamed(Routes.login);
    }
  }
}