import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:stocial/collections.dart';
import 'package:stocial/main.dart';
import 'package:stocial/stores/signup_store.dart';
import 'package:stocial/widgets/stocial_button.dart';

import 'base_state.dart';
import 'constants/colors.dart';
import 'widgets/stocial_text_field.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignUpState();
  }

}

class SignUpState extends BaseState<SignUpScreen> {


  late SignUpStore store;

  @override
  void initState() {
    super.initState();
    store = SignUpStore(baseStateStore);
    initReactions();
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text('Sign up',
                        style: TextStyle(
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
                            decoration: TextDecoration.none,
                            fontSize: 14
                        )
                    ),
                  ),
                  Container(height: 40),
                  StocialTextField(
                    labelText: 'Name',
                    keyboardType: TextInputType.text,
                    onChanged: store.onNameChanged,
                  ),
                  StocialTextField(
                    labelText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    onChanged: store.onEmailChanged,
                  ),
                  StocialTextField(
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    labelText: 'Password',
                    onChanged: store.onPasswordChanged,
                  ),
                  Container(height: 40),
                  Container(height: 10),
                  Observer(
                    builder: (context) {
                      return StocialButton(
                        text: 'Submit',
                        onPressed: store.loading ? null : () => store.signUp(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 55,
            child: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Container(
                alignment: Alignment.centerLeft,
                child: Text('Stocial'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}