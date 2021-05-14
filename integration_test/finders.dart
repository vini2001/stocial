import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class Finders {
  factory Finders() => _finders;
  Finders._internal();
  static final Finders _finders = Finders._internal();

  // find a widget by its key
  final searchTextFieldFinder = find.byKey(const Key('wallet-search-text-field'));
  final listRowFinder = find.byKey(const Key('stocial-list-row'));
  final brazilStocks = find.text('Brazil Stocks');
  final usStocks = find.text('US Stocks');

}