import 'dart:math' as math;

import 'package:device_calendar/device_calendar.dart';
import 'package:smr_app/utils.dart';

// String _getTimePrompt(DateTime dateTime) {
//   final minutesAreAlreadyRounded = (dateTime.minute % 5) == 0;
//   final roundedMinutes = ((dateTime.minute.toDouble() / 5.0).round()) * 5;

//   String prompt = minutesAreAlreadyRounded ? 'om' : 'rond';

// }

List<String> getEventAnnouncements(Event event) {
  final eventTitle = toAlphanumeric(event.title);

  final eventIsInFuture = event.start.compareTo(DateTime.now()) == 1;

  // final timePrompt = _getTimePrompt(event.start);
  final timePrompt = '${padLeft(event.start.hour, amount: 2)}:${padLeft(event.start.minute, amount: 2)}';

  final minutesRemaining = (DateTime.now().difference(event.start).inMinutes).abs();
  final minutesRemainingPrompt = '$minutesRemaining ${minutesRemaining == 1 ? 'minuut' : 'minuten'}';

  if (eventIsInFuture) {
    return [
      'Om $timePrompt heb je de afspraak $eventTitle.',
      'Over $minutesRemainingPrompt start je afspraak $eventTitle.',
      'Zometeen begint je afspraak $eventTitle.',
    ];
  } else {
    return [
      'Je afspraak $eventTitle is $minutesRemainingPrompt geleden begonnen.',
      'Om $timePrompt begon je afspraak $eventTitle.',
      '$minutesRemainingPrompt geleden is je afspraak $eventTitle begonnen.'
    ];
  }
}
