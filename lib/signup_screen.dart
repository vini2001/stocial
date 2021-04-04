import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stocial/stocial_scaffold.dart';
import 'package:stocial/collections.dart';
import 'package:stocial/main.dart';

import 'widgets/stocial_text_field.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignUpState();
  }

}

class SignUpState extends State<SignUpScreen> {


  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

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
                  Text('Cadastrar',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        decoration: TextDecoration.none,
                        fontSize: 20
                      )
                  ),
                  Container(height: 40),
                  StocialTextField(
                    labelText: 'Nome',
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
                    labelText: 'Senha',
                    controller: passwordController,
                  ),
                  Container(height: 40),
                  ElevatedButton(
                      onPressed: () {
                        cadastrar();
                      }, child: Text("Cadastrar")),
                ],
              ),
            )
          ],
        ),
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