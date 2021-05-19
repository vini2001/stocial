
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
              gradient: LinearGradient(
                stops: [
                  0, 0.15, 0.70, 1
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color(0xFF2891E5),
                  Colors.white,
                  Colors.white,
                  Color(0xFF2891E5),
                ], // red to yellow
                tileMode: TileMode.clamp, // repeats the gradient over the canvas
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.only(left: 40, right: 40, bottom: 90),
              // color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text('Welcome to Stocial!',
                        style: TextStyle(
                            color: Colors.blueAccent,
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
                            color: Colors.blueAccent,
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
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          login();
                        },
                        child: Text("Login")
                    ),
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
    }
  }

  dynamic getUserByUid(String uid) async {
    final userDoc = await firestore!.collection(COL_USER).doc(uid).get();
    print("data: ${userDoc.data()}");
    return userDoc;
  }

}