
import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stocial/model/asset.dart';
import 'package:stocial/stocial_scaffold.dart';
import 'package:stocial/constants/constants.dart';
import 'package:stocial/widgets/grouped_list.dart';
import 'package:stocial/widgets/stocial_text_field.dart';
import 'package:stocial/user.dart';

import 'constants/routes.dart';

class WalletScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WalletState();
  }

}

class WalletState extends State<WalletScreen> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Map<String, List<Asset>?>? wallet;
  List<Asset>? assetsList;

  var _searchController = TextEditingController();
  StocialUser stocialUser = StocialUser();

  var _cpfCEIController = TextEditingController();
  var _passwordCEIController = TextEditingController();

  StreamSubscription<DocumentSnapshot>? userStream;

  bool showCEIImport = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();

    getWallet();
  }

  @override
  Widget build(BuildContext context) {
    return StocialScaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            if(loading) CircularProgressIndicator(),
            if(showCEIImport) _buildCEIImport(),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Text(
                "${getTotalReais()}",
                style: TextStyle(
                    fontSize: 16
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              width: 300,
              child: StocialTextField(
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
              height: 100,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: () {
                    refreshCEI();
                  }, child: Text('Importar do CEI')),
                  if(isMobile()) TextButton(onPressed: () {
                    tdAmeritrade();
                  }, child: Text('Importar TD Ameritrade'))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future getWallet() async {
    List<QueryDocumentSnapshot> docs = (await firestore.collection('assets').where('user_id', isEqualTo: stocialUser.uid).get()).docs;

    setState(() {
      assetsList = docs.map((snapshot) => Asset.fromJson(snapshot.data()!)).toList();
      assetsList!.sort((a1, a2) {
        return a1.code.compareTo(a2.code);
      });
    });

    Map<String, List<Asset>> walletGrouped = Map();
    for(Asset asset in assetsList!) {
      String type = asset.getAssetType();
      if(!walletGrouped.containsKey(type)) {
        walletGrouped[type] = [asset];
      }else{
        walletGrouped[type]!.add(asset);
      }
    }

    setState(() {
        wallet = walletGrouped;
    });
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
     // wallet?.forEach((asset) {
     //   String code = asset.code;
     //   asset.visible = code.toLowerCase().contains(value!.toLowerCase());
     // });
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


  Future<void> tdAmeritrade() async {
    final imported =  await Navigator.of(context).pushNamed(Routes.tdAmeritradeKey) as bool;
    print("imported: $imported");
    if(imported is bool && imported) getWallet();
  }

  getTotalReais() {
    var totalReais = 0.0;
    var totalDolars = 0.0;
    
    if(assetsList != null) {
      for(Asset asset in assetsList!) {
        if(asset.currency == 'BRL') {
          totalReais += (asset.quantity) * (asset.price);
        }else{
          totalDolars += (asset.quantity) * (asset.price);
        }
      }
    }
    return "Total Ações BR: R\$ ${totalReais.toStringAsFixed(2)} \nTotal Ações US: USD ${totalDolars.toStringAsFixed(2)}";
  }

  bool isMobile() {
    try {
      return (Platform.isAndroid || Platform.isIOS);
    }catch(ex) {
      return false;
    }
  }

  _buildWalletList(Map<String, List<Asset>?>? wallet) {
    if(wallet == null) return Container();

    return StocialGroupedList(
        groupsNames: wallet.entries.map((e) => e.key).toList(),
        groupSize: (String groupIndex) => wallet[groupIndex]?.length ?? 0,
        columns: ['Ticker', 'Quantidade'],
        valueFor: ({required int columnIndex, required String groupKey, required int itemIndex}) {
          Asset? asset = wallet[groupKey]?[itemIndex];
          if(asset != null) {
            switch(columnIndex) {
              case 0: return asset.code;
              case 1: return asset.quantity.toString();
            }
          }
          return "";
        },
    );
    return Container();
    // return ListView.builder(
    //     itemCount: wallet?.length ?? 0,
    //     itemBuilder: (context, index) {
    //       return _buildStockItem(wallet![index]!);
    //     }
    // );
  }
}