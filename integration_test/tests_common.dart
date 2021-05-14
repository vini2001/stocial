import 'package:flutter_test/flutter_test.dart';

Future waitUntil({
  required WidgetTester tester,
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