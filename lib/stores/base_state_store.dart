import 'package:mobx/mobx.dart';

part 'base_state_store.g.dart';

class BaseStateStore = _BaseStateStore with _$BaseStateStore;

abstract class _BaseStateStore  with Store {

  @observable
  String? snackbarMessage;

  @observable
  bool toPop = false;

  @observable
  String? routeReplacement;

  @observable
  String? routePush;

  Function(dynamic argument)? onReturnRoutePushed;
  
  @action
  void sendSnackBarMessage(String message) {
    snackbarMessage = message;
  }

  @action
  void goToRouteReplacement(String? routeReplacement) {
    this.routeReplacement = routeReplacement;
  }

  @action
  void goToRouteNamed(String? route, {Function(dynamic arguments)? onReturn}) {
    this.routePush = route;
    this.onReturnRoutePushed = onReturn;
  }

  @action
  void pop() {
    toPop = true;
  }
}