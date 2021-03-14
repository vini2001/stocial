
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stocial/StocialScaffold.dart';
import 'package:stocial/StocialTextField.dart';
import 'package:stocial/collections.dart';
import 'package:stocial/main.dart';
import 'package:stocial/user.dart';
import 'package:stocial/wallet_screen.dart';

import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }

}

class LoginState extends State<LoginScreen> {

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
    return StocialScaffold(
      title: 'Stocial',
      body: Container(
        color: Colors.white,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(30),
              margin: EdgeInsets.only(top: 20),
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: -3)
                  ]
              ),
              child: Column(
                children: [
                  Text('Login',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        decoration: TextDecoration.none,
                        fontSize: 20
                      )
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
                  Container(height: 40),
                  ElevatedButton(
                      onPressed: () {
                        login();
                      }, child: Text("Login")),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUpScreen()));
                  }, child: Text('Cadastrar'))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future login() async {

    final email = emailController.text;
    final password = passwordController.text;

    UserCredential credentials = await auth!.signInWithEmailAndPassword(email: email, password: password);
    String? uid = credentials.user?.uid;
    if(uid != null) {
      StocialUser user = StocialUser();
      DocumentSnapshot docSn = await getUserByUid(uid);
      if(docSn.exists) {
        user.set(docSn);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => WalletScreen()));
      }else{
        throw Exception('Not signed up');
      }
    }
  }

  dynamic getUserByUid(String uid) async {
    final userDoc = await firestore!.collection(COL_USER).doc(uid).get();
    print("data: ${userDoc.data()}");
    return userDoc;
  }

}