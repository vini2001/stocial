
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stocial/stocial_scaffold.dart';
import 'package:stocial/base_state.dart';
import 'package:stocial/constants/constants.dart';
import 'package:stocial/widgets/stocial_text_field.dart';
import 'package:stocial/collections.dart';
import 'package:stocial/main.dart';
import 'package:stocial/user.dart';
import 'package:stocial/wallet_screen.dart';

import 'constants/routes.dart';
import 'constants/strings.dart';
import 'signup_screen.dart';

class TDAmeritradeConsumerKeyScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TDAmeritradeConsumerKeyState();
  }

}

class TDAmeritradeConsumerKeyState extends BaseState<TDAmeritradeConsumerKeyScreen> {


  final flutterStorage = FlutterSecureStorage();
  String? consumerKey;

  @override
  void initState() {
    super.initState();

    _fetchSavedKey();
  }
  TextEditingController consumerKeyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StocialScaffold(
      title: 'Stocial',
      body: Container(
        padding: EdgeInsets.all(30),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppStrings.td_ameritrade_consumer_key_explanation),
                Container(height: 40),
                StocialTextField(labelText: AppStrings.td_ameritrade_consumer_key, controller: consumerKeyController),
                TextButton(
                  onPressed: () async{
                    final String consumerKey = consumerKeyController.text;
                    if(consumerKey.isNotEmpty) {
                      flutterStorage.write(key: td_ameritrade_consumer_key, value: consumerKey);
                      // delete saved tokens if new key was entered
                      if(consumerKey != this.consumerKey) {
                        flutterStorage.delete(key: td_ameritrade_access_token);
                        flutterStorage.delete(key: td_ameritrade_refresh_token);
                      }
                      final imported = await Navigator.of(context).pushNamed(Routes.tdAmeritrade, arguments: consumerKey);
                      pop(imported);
                    }
                  },
                  child: Text(AppStrings.next),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _fetchSavedKey() async {
    consumerKey = await flutterStorage.read(key: td_ameritrade_consumer_key);
    if(consumerKey != null) {
      consumerKeyController.text = consumerKey!;
    }
  }

}