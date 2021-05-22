// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_state_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$BaseStateStore on _BaseStateStore, Store {
  final _$snackbarMessageAtom = Atom(name: '_BaseStateStore.snackbarMessage');

  @override
  String? get snackbarMessage {
    _$snackbarMessageAtom.reportRead();
    return super.snackbarMessage;
  }

  @override
  set snackbarMessage(String? value) {
    _$snackbarMessageAtom.reportWrite(value, super.snackbarMessage, () {
      super.snackbarMessage = value;
    });
  }

  final _$toPopAtom = Atom(name: '_BaseStateStore.toPop');

  @override
  bool get toPop {
    _$toPopAtom.reportRead();
    return super.toPop;
  }

  @override
  set toPop(bool value) {
    _$toPopAtom.reportWrite(value, super.toPop, () {
      super.toPop = value;
    });
  }

  final _$routeReplacementAtom = Atom(name: '_BaseStateStore.routeReplacement');

  @override
  String? get routeReplacement {
    _$routeReplacementAtom.reportRead();
    return super.routeReplacement;
  }

  @override
  set routeReplacement(String? value) {
    _$routeReplacementAtom.reportWrite(value, super.routeReplacement, () {
      super.routeReplacement = value;
    });
  }

  final _$routePushAtom = Atom(name: '_BaseStateStore.routePush');

  @override
  String? get routePush {
    _$routePushAtom.reportRead();
    return super.routePush;
  }

  @override
  set routePush(String? value) {
    _$routePushAtom.reportWrite(value, super.routePush, () {
      super.routePush = value;
    });
  }

  final _$_BaseStateStoreActionController =
      ActionController(name: '_BaseStateStore');

  @override
  void sendSnackBarMessage(String message) {
    final _$actionInfo = _$_BaseStateStoreActionController.startAction(
        name: '_BaseStateStore.sendSnackBarMessage');
    try {
      return super.sendSnackBarMessage(message);
    } finally {
      _$_BaseStateStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void goToRouteReplacement(String? routeReplacement) {
    final _$actionInfo = _$_BaseStateStoreActionController.startAction(
        name: '_BaseStateStore.goToRouteReplacement');
    try {
      return super.goToRouteReplacement(routeReplacement);
    } finally {
      _$_BaseStateStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void goToRouteNamed(String? routeReplacement,
      {dynamic Function(dynamic)? onReturn}) {
    final _$actionInfo = _$_BaseStateStoreActionController.startAction(
        name: '_BaseStateStore.goToRouteNamed');
    try {
      return super.goToRouteNamed(routeReplacement, onReturn: onReturn);
    } finally {
      _$_BaseStateStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void pop() {
    final _$actionInfo = _$_BaseStateStoreActionController.startAction(
        name: '_BaseStateStore.pop');
    try {
      return super.pop();
    } finally {
      _$_BaseStateStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
snackbarMessage: ${snackbarMessage},
toPop: ${toPop},
routeReplacement: ${routeReplacement},
routePush: ${routePush}
    ''';
  }
}
