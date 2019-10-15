import 'package:device_calendar/device_calendar.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:meta/meta.dart';
import 'package:smr_app/backend/api/mock/mock_calendars.dart';

final mockEvents = <Event>[
  Event(
    mockCalendars[0].id,
    eventId: 'mockEvent1',
    title: 'Medicatie innemen',
    description: lorem(paragraphs: 1, words: 300),
  ),
  Event(
    mockCalendars[0].id,
    eventId: 'mockEvent2',
    title: 'Bezoek familie Huisbrechts',
    // description: lorem(),
  ),
  Event(
    mockCalendars[0].id,
    eventId: 'mockEvent3',
    title: 'Ander soort evenement',
    description: lorem(),
  ),
  Event(
    mockCalendars[1].id,
    eventId: 'mockEvent4',
    title: 'Mock Event 4',
    description: lorem(),
  ),
  Event(
    mockCalendars[1].id,
    eventId: 'mockEvent5',
    title: 'Mock Event 5',
    description: lorem(),
  ),
  Event(
    mockCalendars[2].id,
    eventId: 'mockEvent6',
    title: 'Mock Event 6',
    description: lorem(),
  ),
];

List<Event> generateMockEvents({
  @required Calendar calendar,
  DateTime start,
}) {
  final startDate = start ?? DateTime.now();
  return List.generate(4, (i) {
    final eventIndex = '${calendar.id}.$i';
    return Event(
      calendar.id,
      eventId: 'generatedMockEvent$eventIndex',
      title: 'Generated Mock Event $eventIndex',
      description: lorem(),
      start: startDate,
      end: startDate.add(Duration(minutes: 5 + (i * 5))),
    );
  });
}
