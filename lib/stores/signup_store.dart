import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../collections.dart';
import '../main.dart';
import '../user.dart';
import 'base_state_store.dart';

part 'signup_store.g.dart';

class SignUpStore = _SignUpStore with _$SignUpStore;

abstract class _SignUpStore  with Store {

  _SignUpStore(this.baseStateStore);

  BaseStateStore baseStateStore;

  String? name;
  String? email;
  String? password;

  @observable
  bool loading = false;

  @observable
  bool signedUp = false;

  @action
  void init() {
  }

  @action
  void onEmailChanged(String? email) {
    this.email = email;
  }

  @action
  void onPasswordChanged(String? password) {
    this.password = password;
  }

  @action
  void onNameChanged(String? name) {
    this.name = name;
  }

  @action
  Future<void> signUp() async {

    if((name?.isEmpty ?? true) || (email?.isEmpty ?? true) || (password?.isEmpty ?? true)) {
      baseStateStore.sendSnackBarMessage('Fill all the fields');
      return;
    }

    loading = true;
    try {
      UserCredential? credentials = await auth?.createUserWithEmailAndPassword(email: email!, password: password!);
      if(credentials?.user?.uid != null) {
        String? uid = credentials!.user!.uid;
        DocumentReference userDoc = firestore!.collection(COL_USER).doc(uid);
        await userDoc.set({
          'uid': uid,
          'email': email,
          'name': name
        });

        baseStateStore.sendSnackBarMessage('Successfully signed up!');
        baseStateStore.pop();
      }else {
        debugPrint(credentials.toString());
      }
    } on FirebaseAuthException catch(ex) {
      baseStateStore.sendSnackBarMessage(ex.message ?? 'Error when signing up');
    }
    loading = false;
  }

}
