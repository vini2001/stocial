// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LoginStore on _LoginStore, Store {
  final _$loadingAtom = Atom(name: '_LoginStore.loading');

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

  final _$loginSuccessAtom = Atom(name: '_LoginStore.loginSuccess');

  @override
  bool get loginSuccess {
    _$loginSuccessAtom.reportRead();
    return super.loginSuccess;
  }

  @override
  set loginSuccess(bool value) {
    _$loginSuccessAtom.reportWrite(value, super.loginSuccess, () {
      super.loginSuccess = value;
    });
  }

  final _$loginAsyncAction = AsyncAction('_LoginStore.login');

  @override
  Future<void> login() {
    return _$loginAsyncAction.run(() => super.login());
  }

  final _$_LoginStoreActionController = ActionController(name: '_LoginStore');

  @override
  void init() {
    final _$actionInfo =
        _$_LoginStoreActionController.startAction(name: '_LoginStore.init');
    try {
      return super.init();
    } finally {
      _$_LoginStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onEmailChanged(String? email) {
    final _$actionInfo = _$_LoginStoreActionController.startAction(
        name: '_LoginStore.onEmailChanged');
    try {
      return super.onEmailChanged(email);
    } finally {
      _$_LoginStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onPasswordChanged(String? password) {
    final _$actionInfo = _$_LoginStoreActionController.startAction(
        name: '_LoginStore.onPasswordChanged');
    try {
      return super.onPasswordChanged(password);
    } finally {
      _$_LoginStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
loginSuccess: ${loginSuccess}
    ''';
  }
}
