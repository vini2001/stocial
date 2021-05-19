
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:stocial/widgets/stocial_text_field.dart';
import 'package:stocial/collections.dart';
import 'package:stocial/login_screen.dart';
import 'package:stocial/main.dart';
import 'package:stocial/user.dart';
import 'package:stocial/wallet_screen.dart';

import 'constants/routes.dart';
import 'signup_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashState();
  }

}

class SplashState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    initFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future initFirebase() async {
    await Firebase.initializeApp();

    firestore = FirebaseFirestore.instance;
    auth = FirebaseAuth.instance;
    Navigator.of(context).pushReplacementNamed(Routes.login);
  }



}