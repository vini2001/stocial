
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stocial/constants/colors.dart';
import 'package:stocial/widgets/stocial_button.dart';
import 'package:stocial/widgets/stocial_text_field.dart';
import 'package:stocial/collections.dart';
import 'package:stocial/main.dart';
import 'package:stocial/user.dart';
import 'package:stocial/wallet_screen.dart';

import 'base_state.dart';
import 'constants/routes.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }

}

class LoginState extends BaseState<LoginScreen> {

  bool loading = false;

  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  Future isSignedIn() async {
    User? currentUser = auth!.currentUser;
    if(currentUser != null) {
      print(currentUser.uid);
      DocumentSnapshot docSn = await getUserByUid(currentUser.uid);
      if(docSn.exists && docSn.data() != null) {
        StocialUser().set(docSn);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => WalletScreen()));
      }else{
        await auth!.signOut();
      }
    }
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: backgroundGradient,
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width > 600 ? 600 : MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: colorPrimary, spreadRadius: -2, blurRadius: 40, offset: Offset(0, 0))
                ]
              ),
              padding: EdgeInsets.only(left: 40, right: 40, bottom: 60, top: 60),
              margin: EdgeInsets.only(bottom: 40),
              // color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text('Welcome to Stocial!',
                        style: TextStyle(
                            color: colorPrimary,
                            decoration: TextDecoration.none,
                            fontSize: 24
                        )
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    alignment: Alignment.centerLeft,
                    child: Text('Your investment buddy',
                        style: TextStyle(
                            color: colorPrimary,
                            decoration: TextDecoration.none,
                            fontSize: 14
                        )
                    ),
                  ),
                  Container(height: 40),
                  StocialTextField(
                    labelText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                  ),
                  StocialTextField(
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    labelText: 'Senha',
                    controller: passwordController,
                  ),
                  Container(height: 10),
                  StocialButton(
                    text: 'Login',
                    onPressed: loading ? null : () =>login(),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUpScreen()));
                      }, child: Text('Sign Up'))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future login() async {

    final email = emailController.text;
    final password = passwordController.text;

    setState(() {
      loading = true;
    });

    UserCredential credentials = await auth!.signInWithEmailAndPassword(email: email, password: password);
    String? uid = credentials.user?.uid;
    if(uid != null) {
      StocialUser user = StocialUser();
      DocumentSnapshot docSn = await getUserByUid(uid);

      if(docSn.exists) {
        user.set(docSn);
        Navigator.of(context).pushReplacementNamed(Routes.wallet);
      }else{
        throw Exception('Not signed up');
      }
    }else{
      setState(() {
        loading = false;
      });
    }
  }

  dynamic getUserByUid(String uid) async {
    final userDoc = await firestore!.collection(COL_USER).doc(uid).get();
    print("data: ${userDoc.data()}");
    return userDoc;
  }

}