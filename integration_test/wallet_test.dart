import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:stocial/main.dart' as app;
import 'package:stocial/widgets/grouped_list.dart';
import 'tests_common.dart';

void main() {
  doWalletTest();
}

void doWalletTest(){
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('wallet', (tester) async {
    app.main();

    // wait until the wallet screen is shown
    await waitUntil(tester: tester, conditionMet: () => find.byType(StocialGroupedList).evaluate().isNotEmpty);

    // tap a button with the text 'Brazil Stocks'
    await tester.tap(find.text('Brazil Stocks'));
    // wait until the animation finished
    await tester.pumpAndSettle();

    // finds exactly 2 widgets that contains the text 'Brazil Stocks'
    expect(find.text('Brazil Stocks'), findsNWidgets(2));

    // find a widget by its type
    final parentWidget = find.byType(StocialGroupedList);

    // tap a child of the parentWidget that contains the text 'US Stocks'
    await tester.tap(
        find.descendant(of: parentWidget, matching: find.text('US Stocks')),
    );

    // find a widget by its key
    final _searchTextFieldFinder = find.byKey(const Key('wallet-search-text-field'));
    await tester.tap(_searchTextFieldFinder);

    // search for 'AAPL' and wait until all scheduled frames have been triggered
    await tester.enterText(_searchTextFieldFinder, 'AAPL');
    await tester.pumpAndSettle();

    // make sure there is only one stock being shown on the list
    final _listRowFinder = find.byKey(const Key('stocial-list-row'));
    expect(_listRowFinder.evaluate().length, 1);

    // make sure the one being shown is 'AAPL', therefore the search worked
    expect(find.descendant(of: _listRowFinder, matching: find.text('AAPL')), findsOneWidget);

    // get the values for all columns in the AAPL row
    final aaplTextValues = find.descendant(of: _listRowFinder, matching: find.byType(Text));
    // get the text value for each of the Text elements
    final symbol = _getText(aaplTextValues.at(0));
    // make sure the first Text displays the stock symbol
    expect(symbol, 'AAPL');

    // make sure total = price * quantity (with a small rounding error margin)
    final price = double.parse(_getText(aaplTextValues.at(1)));
    final quantity = double.parse(_getText(aaplTextValues.at(2)));
    final total = double.parse(_getText(aaplTextValues.at(3)));
    expect(total - price * quantity < 0.1, true);
  });
}

// get the actual text for a Text widget
String _getText(Finder finder) {
  return (finder.evaluate().single.widget as Text).data!;
}