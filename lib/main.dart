import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stocial/constants/colors.dart';
import 'package:stocial/login_screen.dart';
import 'package:stocial/splash_screen.dart';
import 'package:stocial/td_ameritrade_consumer_key_screen.dart';
import 'package:stocial/td_ameritrade_screen.dart';
import 'package:stocial/wallet_screen.dart';

import 'constants/routes.dart';

bool useFirestoreEmulator = false;
FirebaseFirestore? firestore;
FirebaseAuth? auth;

void main() {
  runApp(MyApp());

  if (useFirestoreEmulator) {
    FirebaseFirestore.instance.settings = const Settings(
        host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);
  }
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stocial',
      theme: ThemeData(
        primarySwatch: appColorSwatch
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splash,
      onGenerateRoute: (settings) {

        final args = settings.arguments;

        switch (settings.name) {
          case Routes.splash: return _buildRoute(SplashScreen());
          case Routes.wallet: return _buildRoute(WalletScreen());
          case Routes.tdAmeritrade: return _buildRoute(TDAmeritradeScreen(consumerKey: args));
          case Routes.login: return _buildRoute(LoginScreen());
          case Routes.tdAmeritradeKey: return _buildRoute(TDAmeritradeConsumerKeyScreen());
        }
      },
    );
  }

  MaterialPageRoute _buildRoute(StatefulWidget screen) {
    return MaterialPageRoute(
      builder: (context) {
        return screen;
      },
    );
  }
}