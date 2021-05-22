import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:stocial/collections.dart';
import 'package:stocial/main.dart';
import 'package:stocial/user.dart';
import 'package:stocial/widgets/utils.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'base_state.dart';
import 'constants/constants.dart';
import 'constants/strings.dart';
import 'constants/urls.dart';


class TDAmeritradeScreen extends StatefulWidget {

  final consumerKey;
  TDAmeritradeScreen({required this.consumerKey});

  @override
  State<StatefulWidget> createState() {
    return TDAmeritradeState();
  }

}

class TDAmeritradeState extends BaseState<TDAmeritradeScreen> {

  String? code;
  bool showWebView = false;

  @override
  void initState() {
    super.initState();

    recoverAccessToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stocial'),),
      body: Container(
        child: !showWebView ? StocialLoading(label: AppStrings.loading) : WebView(
          initialUrl: Urls.tdAmeritrade.authenticate(consumerKey: widget.consumerKey),
          javascriptMode: JavascriptMode.unrestricted,
          onPageStarted: (page) {
            print("page started: $page");
          },
          onWebResourceError: (error) {
            print("page error: ${error.domain}");
            print(error.failingUrl);
          },
          onPageFinished: (page) {
            print("page finished: $page");
            int indexCode = page.indexOf('/?code=');
            if(indexCode > 0) {
              String code = page.substring(indexCode + '/?code='.length);

              setState(() {
                this.code = Uri.decodeFull(code);
                showWebView = false;
              });

              fetchToken();
            }
          },
          gestureNavigationEnabled: true,
          // navigationDelegate: NavigationDelegate(),
        ),
      ),
    );
  }

  Future fetchToken() async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Cookie': 'dv_data=2016815b5c5f11781ea5dc862b7615410716936a178e'
    };
    var request = http.Request('POST', Uri.parse(Urls.tdAmeritrade.tokenUrl));
    request.bodyFields = {
      'grant_type': 'authorization_code',
      'client_id': '${widget.consumerKey}@AMER.OAUTHAP',
      'access_type': 'offline',
      'code': this.code!,
      'redirect_uri': 'https://anjinhoseguros.com.br'
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final json = await response.stream.bytesToString();
      print(jsonEncode(jsonDecode(json)));

      final data = jsonDecode(json);
      final refreshToken = data['refresh_token'];
      final accessToken = data['access_token'];

      final storage = new FlutterSecureStorage();
      storage.write(key: td_ameritrade_refresh_token, value: refreshToken);
      storage.write(key: td_ameritrade_access_token, value: accessToken);

      debugPrint("Refresh token fetched");
      debugPrint("Access token fetched");

      importPositions(accessToken);
    }
    else {
      print(response.reasonPhrase);
    }

  }

  Future refreshAccessToken() async {

    final storage = new FlutterSecureStorage();
    final refreshToken = await storage.read(key: 'td_ameritrade_refresh_token');

    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Cookie': 'dv_data=2016815b5c5f11781ea5dc862b7615410716936a178e'
    };
    var request = http.Request('POST', Uri.parse(Urls.tdAmeritrade.tokenUrl));
    request.bodyFields = {
      'grant_type': 'refresh_token',
      'client_id': '${widget.consumerKey}@AMER.OAUTHAP',
      'refresh_token': '$refreshToken',
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final json = await response.stream.bytesToString();
      print(jsonEncode(jsonDecode(json)));

      final data = jsonDecode(json);
      final access_token = data['access_token'];


      storage.write(key: 'td_ameritrade_access_token', value: access_token);

      debugPrint(access_token);
      importPositions(access_token);
    }
    else {
      print(response.reasonPhrase);
      await storage.delete(key: 'td_ameritrade_access_token');
      Navigator.of(context).pop();
    }

  }

  void recoverAccessToken() async {
    final storage = new FlutterSecureStorage();
    final accessToken = await storage.read(key: 'td_ameritrade_access_token');
    if(accessToken != null) {
      debugPrint(accessToken);
      importPositions(accessToken);
    }else {
      setState(() {
        showWebView = true;
      });
    }
  }

  Future<void> importPositions(String accessToken) async {
    String? accountId = await getAccountId(accessToken);
    if(accountId != null) {
      final positionsData = await getPositionsData(accessToken, accountId);
      debugPrint(jsonEncode(positionsData));
      if(positionsData != null) {
        await saveToFirebase(positionsData);
        showSnackBarMessage(AppStrings.td_ameritrade_success);
        pop(true);
      }else{
        showSnackBarMessage(AppStrings.error_td_ameritrade, label: AppStrings.closeSnackbar, onClose: () {
          pop(false);
        });
      }
    }else{
      print("null account id");
      refreshAccessToken();
    }
  }

  getAccountId(String accessToken) async {
    var headers = {
      'Authorization': 'Bearer $accessToken'
    };
    var request = http.Request('GET', Uri.parse('https://api.tdameritrade.com/v1/accounts/'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = jsonDecode(await response.stream.bytesToString());
      String accountId = data[0]['securitiesAccount']['accountId'];
      return accountId;
    }
    else {
      print(response.reasonPhrase);
    }
    return null;
  }

  getPositionsData(String accessToken, String accountId) async {
    String urlString = "https://api.tdameritrade.com/v1/accounts/$accountId?fields=positions";
    var headers = {
      'Authorization': 'Bearer $accessToken'
    };
    var request = http.Request('GET', Uri.parse(urlString));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = jsonDecode(await response.stream.bytesToString());
      return data['securitiesAccount']['positions'];
    }
    else {
      print(response.reasonPhrase);
    }
    return null;
  }

  Future<void> saveToFirebase(positionsData) async {
    QuerySnapshot snapshot = await firestore!.collection(COL_INSTITUTIONS).where('name', isEqualTo: TD_AMERITRADE_INSTITUTION_NAME).get();

    var institutionId;
    if(snapshot.docs.length > 0) {
      institutionId = snapshot.docs[0].id;
    }else{
      showSnackBarMessage('Erro ao salvar os dados.');
      return;
    }

    positionsData = (positionsData as List<dynamic>);
    for(final position in positionsData) {
      final quantity = position['longQuantity'];
      final marketValue = position['marketValue'];
      final price = marketValue / quantity;
      final averagePrice = position['averagePrice'];
      final code = position['instrument']['symbol'];
      final cusip = position['instrument']['cusip'];

      final querySnapshots = await firestore!.collection(COL_ASSETS).where('user_id', isEqualTo: StocialUser().uid).where('cusip', isEqualTo: cusip).get();
      if(querySnapshots.docs.length > 0) {
        for(final doc in querySnapshots.docs) {
          await doc.reference.delete();
        }
      }

      final doc = firestore!.collection(COL_ASSETS).doc();
      final documentData = {
        'id': doc.id,
        'quantity': quantity,
        'price': price,
        'averagePrice': averagePrice,
        'code': code,
        'cusip': cusip,
        'institutionId': institutionId,
        'user_id': StocialUser().uid,
        'company': code,
        'currency': 'American Dollars'
      };
      await doc.set(documentData);
    }

  }
}