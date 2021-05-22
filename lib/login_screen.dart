import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:stocial/constants/colors.dart';
import 'package:stocial/stores/login_store.dart';
import 'package:stocial/widgets/stocial_button.dart';
import 'package:stocial/widgets/stocial_text_field.dart';

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

  late LoginStore store;

  @override
  void initState() {
    super.initState();
    store = LoginStore(baseStateStore);
    store.init();

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
          Observer(builder: (BuildContext context) {
            return Container(
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
                      onChanged: store.onEmailChanged,
                    ),
                    StocialTextField(
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      labelText: 'Password',
                      onChanged: store.onPasswordChanged,
                    ),
                    Container(height: 10),
                    StocialButton(
                      text: 'Login',
                      onPressed: store.loading ? null : () => store.login(),
                    ),
                    Container(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(Routes.signUp);
                        },
                        child: Text('Sign Up'),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          )
        ],
      ),
    );
  }

  @override
  void initReactions() {
    super.initReactions();

    addReaction('successLogin', reaction((r) => store.loginSuccess, (bool success) {
      debugPrint('reaction: successLogin: $success');
      if(success) {
        Navigator.of(context).pushReplacementNamed(Routes.wallet);
      }
    }));
  }
}