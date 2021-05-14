import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TestsCommon {
  TestsCommon(this.tester);
  final WidgetTester tester;

  Future waitUntil({
    required bool Function() conditionMet,
    Duration? timeout,
  }) async {
    final binding = tester.binding;
    return TestAsyncUtils.guard<int>(() async {
      final endTime = binding.clock.fromNowBy(timeout ?? Duration(seconds: 60));
      var count = 0;
      while (true) {
        // stop loop if it has timed out or if condition is reached
        if ((binding.clock.now().isAfter(endTime) && !binding.hasScheduledFrame) || conditionMet()) {
          break;
        }
        // triggers ui frames
        await binding.pump(const Duration(milliseconds: 100),);
        count += 1;
      }
      return count;
    });
  }

  // tap and wait
  Future<void> tap(Finder finder) async {
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  // tap, enter text and wait
  Future<void> enterText(Finder finder, String text) async {
    await tap(finder);
    await tester.enterText(finder, text);
    await tester.pumpAndSettle();
  }

  // get the actual text for a Text widget
  String getText(Finder finder) {
    return (finder.evaluate().single.widget as Text).data!;
  }
}