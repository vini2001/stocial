import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:stocial/stores/base_state_store.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {

  late BaseStateStore baseStateStore;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final Map<String, ReactionDisposer> _disposers = {};

  @override
  void initState() {
    super.initState();
    baseStateStore = BaseStateStore();
    initReactions();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void addReaction(String id, ReactionDisposer disposer) {
    if (_disposers.containsKey(id)) {
      final disposer = _disposers[id]!;
      disposer();
    }
    _disposers[id] = disposer;
  }

  SnackBar buildSnackBar(String message, {int seconds = 2, String? label, Function? onClose}) {
    return SnackBar(
      content: Text(message),
      duration: Duration(seconds: seconds),
      action: label == null ? null : SnackBarAction(
        label: label,
        onPressed: () {  onClose!(); },
      ),
    );
  }

  void showSnackBarMessage(String message, {int seconds = 2, String? label, Function? onClose}) {
    ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(message, seconds: seconds, label: label, onClose: onClose));
  }

  void pop([Object? response]) {
    print(response);
    Navigator.of(context).pop(response);
  }

  @override
  void dispose() {
    _disposers.forEach((key, value) {
      value();
    });
    super.dispose();
  }

  void initReactions() {
    addReaction('message', reaction((r) => baseStateStore.snackbarMessage, (String? snackBarMessage) {
      if(snackBarMessage != null) {
        showSnackBarMessage(snackBarMessage);
        baseStateStore.snackbarMessage = null;
      }
    }));

    addReaction('pop', reaction((r) => baseStateStore.toPop, (bool pop) {
      if(pop) {
        Navigator.of(context).pop();
      }
    }));

    addReaction('routeReplacement', reaction((r) => baseStateStore.routeReplacement, (String? routeReplacement) {
      if(routeReplacement != null) {
        Navigator.of(context).pushReplacementNamed(routeReplacement);
        baseStateStore.routeReplacement = null;
      }
    }));

    addReaction('routePush', reaction((r) => baseStateStore.routePush, (String? routeName) async {
      if(routeName != null) {
        final arguments = await Navigator.of(context).pushNamed(routeName);
        if(baseStateStore.onReturnRoutePushed != null) {
          baseStateStore.onReturnRoutePushed!(arguments);
        }
        baseStateStore.onReturnRoutePushed = null;
        baseStateStore.routePush = null;
      }
    }));


  }

}