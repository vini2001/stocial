import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../collections.dart';
import '../main.dart';
import '../user.dart';
import 'base_state_store.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore  with Store {

  _LoginStore(this.baseStateStore);
  BaseStateStore baseStateStore;

  String? email;
  String? password;

  @observable
  bool loading = false;

  @observable
  bool loginSuccess = false;

  @action
  void init() {
    isSignedIn();
  }

  Future isSignedIn() async {
    User? currentUser = auth!.currentUser;
    if(currentUser != null) {
      print(currentUser.uid);
      DocumentSnapshot docSn = await getUserByUid(currentUser.uid);
      if(docSn.exists && docSn.data() != null) {
        StocialUser().set(docSn);
        loginSuccess = true;
      }else{
        await auth!.signOut();
      }
    }
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
  Future<void> login() async {
    if((email?.isEmpty ?? true) || (password?.isEmpty ?? true)) return;

    loading = true;

    try {
      UserCredential credentials = await auth!.signInWithEmailAndPassword(email: email!, password: password!);

      String? uid = credentials.user?.uid;
      if(uid != null) {
        StocialUser user = StocialUser();
        DocumentSnapshot docSn = await getUserByUid(uid);

        if(docSn.exists) {
          user.set(docSn);
          loginSuccess = true;
        }else{
          throw Exception('Not signed up');
        }
      }else{
        loading = false;
      }
    } on FirebaseAuthException catch(ex) {
      print(ex);
      baseStateStore.sendSnackBarMessage(ex.message ?? 'Error signing in');
      loading = false;
    }
  }

  dynamic getUserByUid(String uid) async {
    final userDoc = await firestore!.collection(COL_USER).doc(uid).get();
    return userDoc;
  }
}
