import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:stocial/base_state.dart';
import 'package:stocial/constants/colors.dart';
import 'package:stocial/model/asset.dart';

import 'package:stocial/stores/wallet_store.dart';
import 'package:stocial/widgets/grouped_list.dart';
import 'package:stocial/widgets/stocial_text_field.dart';


class WalletScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WalletState();
  }

}

class WalletState extends BaseState<WalletScreen> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late WalletStore store;

  var _cpfCEIController = TextEditingController();
  var _passwordCEIController = TextEditingController();
  final stocialGroupedListController = StocialGroupedListController();

  @override
  void initState() {
    super.initState();
    store = WalletStore(baseStateStore);
    store.init();

    initReactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Observer(
          builder: (context) {
            return Column(
              children: [
                if(store.loading) Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: CircularProgressIndicator(),
                ),
                if(store.showCEIImport) _buildCEIImport(),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  width: 300,
                  child: StocialTextField(
                    textFieldKey: const Key('wallet-search-text-field'),
                    labelText: 'Search',
                    onChanged: store.onSearchQueryChanged,
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
                      child: _buildWalletList(),
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
            );
          },
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
            if(Platform.isAndroid || Platform.isIOS) ListTile(
              leading: Icon(Icons.add),
              title: Text('Import from TD Ameritrade'),
              onTap: store.tdAmeritrade,
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Import from CEI'),
              onTap: () {
                store.refreshCEI();
                pop();
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () => store.logout(),
            ),
          ],
        ),
      ),
    );
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
                onChanged: store.onCpfCeiChanged,
                labelText: 'CPF CEI',
                keyboardType: TextInputType.number,
              ),
              StocialTextField(
                controller: _passwordCEIController,
                onChanged: store.onPasswordCeiChanged,
                labelText: 'Senha CEI',
                obscureText: true,
              ),
              ElevatedButton(onPressed: () {
                store.importCEI();
              }, child: Text('Importar'))
            ],
          ),
        ),
      ),
    );
  }

  _buildWalletList() {
    final wallet = store.wallet;
    if(wallet == null) return Container();

    return StocialGroupedList(
        controller: stocialGroupedListController,
        groupsNames: wallet.getGroupsNames() ?? [],
        groupsInfo: wallet.getGroupsTotals(usdBrlExchangeRate: store.usdBrlExchangeRate),
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
        isVisible: store.isAssetVisible
    );
  }

  _getUsdBrlWidget() {
    if(store.usdBrlExchangeRate == null) return Container();
    return Container(
      decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.all(Radius.circular(4))
      ),
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: Text(
        'USD/BRL: ${store.usdBrlExchangeRate}',
        style: TextStyle(
            fontSize: 12,
            color: Colors.white
        ),
      ),
    );
  }

  @override
  void initReactions() {
    super.initReactions();

    addReaction('onCPFCeiChanged', reaction((r) => store.cpfCei, (String? cpf) {
      if(cpf != null && cpf != _cpfCEIController.text) {
        _cpfCEIController.text = cpf;
      }
    }));

    addReaction('onPassCeiChanged', reaction((r) => store.passwordCei, (String? pass) {
      if(pass != null && pass != _passwordCEIController.text) {
        _passwordCEIController.text = pass;
      }
    }));

    addReaction('walletChanged', reaction((r) => store.assetsList, (dynamic ignore) {
      stocialGroupedListController.notifyDataChanged();
    }));

    addReaction('searchQueryChanged', reaction((r) => store.searchQuery, (String? ignore) {
      stocialGroupedListController.notifyDataChanged();
    }));

    addReaction('usdBrlExchangeRate', reaction((r) => store.usdBrlExchangeRate, (double? ignore) {
      stocialGroupedListController.notifyDataChanged();
    }));

    addReaction('notifyWalletTable', reaction((r) => store.notifyWalletTable, (bool? notifyWalletTable) {
      if(notifyWalletTable ?? false) {
        stocialGroupedListController.notifyDataChanged();
        store.notifyWalletTable = false;
      }
    }));
  }
}