// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SignUpStore on _SignUpStore, Store {
  final _$loadingAtom = Atom(name: '_SignUpStore.loading');

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  final _$signedUpAtom = Atom(name: '_SignUpStore.signedUp');

  @override
  bool get signedUp {
    _$signedUpAtom.reportRead();
    return super.signedUp;
  }

  @override
  set signedUp(bool value) {
    _$signedUpAtom.reportWrite(value, super.signedUp, () {
      super.signedUp = value;
    });
  }

  final _$signUpAsyncAction = AsyncAction('_SignUpStore.signUp');

  @override
  Future<void> signUp() {
    return _$signUpAsyncAction.run(() => super.signUp());
  }

  final _$_SignUpStoreActionController = ActionController(name: '_SignUpStore');

  @override
  void init() {
    final _$actionInfo =
        _$_SignUpStoreActionController.startAction(name: '_SignUpStore.init');
    try {
      return super.init();
    } finally {
      _$_SignUpStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onEmailChanged(String? email) {
    final _$actionInfo = _$_SignUpStoreActionController.startAction(
        name: '_SignUpStore.onEmailChanged');
    try {
      return super.onEmailChanged(email);
    } finally {
      _$_SignUpStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onPasswordChanged(String? password) {
    final _$actionInfo = _$_SignUpStoreActionController.startAction(
        name: '_SignUpStore.onPasswordChanged');
    try {
      return super.onPasswordChanged(password);
    } finally {
      _$_SignUpStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onNameChanged(String? name) {
    final _$actionInfo = _$_SignUpStoreActionController.startAction(
        name: '_SignUpStore.onNameChanged');
    try {
      return super.onNameChanged(name);
    } finally {
      _$_SignUpStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
signedUp: ${signedUp}
    ''';
  }
}
