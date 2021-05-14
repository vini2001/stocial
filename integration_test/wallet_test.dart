import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:stocial/main.dart' as app;
import 'package:stocial/widgets/grouped_list.dart';
import 'finders.dart';
import 'tests_common.dart';

void main() {
  doWalletTest();
}
late TestsCommon tests;
void doWalletTest(){
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('wallet', (tester) async {
    app.main();

    tests = TestsCommon(tester);

    // wait until the wallet screen is shown
    await tests.waitUntil(conditionMet: () => find.byType(StocialGroupedList).evaluate().isNotEmpty);

    // tap a button with the text 'Brazil Stocks' wait until the animation finished
    await tests.tap(Finders().brazilStocks);

    // finds exactly 2 widgets that contains the text 'Brazil Stocks'
    expect(Finders().brazilStocks, findsNWidgets(2));

    // find a widget by its type
    final parentWidget = find.byType(StocialGroupedList);

    // tap a child of the parentWidget that contains the text 'US Stocks'
    await tests.tap(
      find.descendant(of: parentWidget, matching: Finders().usStocks),
    );

    // search for 'AAPL' and wait until all scheduled frames have been triggered
    await tests.enterText(Finders().searchTextFieldFinder, 'AAPL');

    final listRowFinder = Finders().listRowFinder;

    // make sure there is only one stock being shown on the list
    expect(listRowFinder.evaluate().length, 1);

    // make sure the one being shown is 'AAPL', therefore the search worked
    expect(find.descendant(of: listRowFinder, matching: find.text('AAPL')), findsOneWidget);

    // get the values for all columns in the AAPL row
    final aaplTextValues = find.descendant(of: listRowFinder, matching: find.byType(Text));
    // get the text value for each of the Text elements
    final symbol = tests.getText(aaplTextValues.at(0));
    // make sure the first Text displays the stock symbol
    expect(symbol, 'AAPL');

    // make sure total = price * quantity (with a small rounding error margin)
    final price = double.parse(tests.getText(aaplTextValues.at(1)));
    final quantity = double.parse(tests.getText(aaplTextValues.at(2)));
    final total = double.parse(tests.getText(aaplTextValues.at(3)));
    expect(total - price * quantity < 0.1, true);
  });
}