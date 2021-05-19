import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:stocial/collections.dart';
import 'package:stocial/main.dart';

import 'base_state.dart';
import 'widgets/stocial_text_field.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignUpState();
  }

}

class SignUpState extends BaseState<SignUpScreen> {


  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

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
                  0, 0.3, 0.70, 1
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
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.only(left: 40, right: 40, top: 200),
              // color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text('Sign up',
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
                    child: Text('And start making your life easier',
                        style: TextStyle(
                            color: Colors.blueAccent,
                            decoration: TextDecoration.none,
                            fontSize: 14
                        )
                    ),
                  ),
                  Container(height: 40),
                  StocialTextField(
                    labelText: 'Name',
                    keyboardType: TextInputType.text,
                    controller: nameController,
                  ),
                  StocialTextField(
                    labelText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                  ),
                  StocialTextField(
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    labelText: 'Password',
                    controller: passwordController,
                  ),
                  Container(height: 40),
                  Container(height: 10),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          cadastrar();
                        }, child: Text("Submit")),
                  ),
                ],
              ),
            ),
          ),
          AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Container(
              alignment: Alignment.centerLeft,
              child: Text('Stocial'),
            ),
          ),
        ],
      ),
    );
  }

  Future cadastrar() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    final email = emailController.text;
    final password = passwordController.text;
    final name = nameController.text;

    UserCredential credentials = await auth.createUserWithEmailAndPassword(email: email, password: password);
    if(credentials.user?.uid != null) {
      String? uid = credentials.user!.uid;
      DocumentReference userDoc = firestore!.collection(COL_USER).doc(uid);
      await userDoc.set({
        'uid': uid,
        'email': email,
        'name': name
      });

      Navigator.of(context).pop();
    }else {
      debugPrint(credentials.toString());
    }
  }

}