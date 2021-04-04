
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stocial/stocial_scaffold.dart';
import 'package:stocial/constants/constants.dart';
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

  List<Map<String, dynamic>?>? wallet;

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  Container(
                    margin: EdgeInsets.only(top: 0),
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: -3)
                        ]
                    ),
                    child: wallet != null ? _buildWalletList(wallet) : Container(),
                  )
                ],
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
      ),
    );
  }

  Future getWallet() async {
    List<QueryDocumentSnapshot> docs = (await firestore.collection('assets').where('user_id', isEqualTo: stocialUser.uid).get()).docs;
    setState(() {
      wallet = docs.map((snapshot) => snapshot.data()).toList();
      wallet?.forEach((element) {
        element!['visible'] = true;
      });
      loading = false;
    });
  }
  
  Widget _buildStockItem(Map<String, dynamic> stock) {
    if(!(stock['visible'] ?? false)) return Container();
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stock['code'],
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
                "${stock['quantity']}",
                style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 12,
                    color: Colors.black
                ),
              ),
              if(stock['averagePrice'] != null) Container(
                child: Text('${(((((stock['price'] - stock['averagePrice']) / stock['averagePrice'])) * 100) as double).toStringAsFixed(2)} %'),
              ),
              Text(
                "${getCurrencySymbol(stock)}${(stock['price'] * 1.0).toStringAsFixed(2)}",
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
     wallet?.forEach((element) {
       String code = element!['code'];
       element['visible'] = code.toLowerCase().contains(value!.toLowerCase());
     });
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

  getCurrencySymbol(final stock) {
    if(stock['currency'] != null) {
      if(stock['currency'] == 'American Dollars') {
        return 'USD ';
      }
    }
    return 'R\$ ';
  }

  getTotalReais() {
    var totalReais = 0.0;
    var totalDolars = 0.0;
    if(wallet != null) {
      for(var stock in wallet!) {
        if(stock!['currency'] == null) {
          totalReais += (stock['quantity']) * (stock['price']);
        }else{
          totalDolars += (stock['quantity']) * (stock['price']);
        }
      }
    }
    return "Total Ações BR: R\$ $totalReais \nTotal Ações US: USD $totalDolars";
  }

  bool isMobile() {
    try {
      return (Platform.isAndroid || Platform.isIOS);
    }catch(ex) {
      return false;
    }
  }

  _buildWalletList(List<Map<String, dynamic>?>? wallet) {
    return ListView.builder(
        itemCount: wallet?.length ?? 0,
        itemBuilder: (context, index) {
          return _buildStockItem(wallet![index]!);
        }
    );
  }
}