import 'package:device_calendar/device_calendar.dart';
import 'package:meta/meta.dart';
import 'package:smr_app/backend/api/mock/mock_calendars.dart';
import 'package:smr_app/backend/api/mock/mock_events.dart';
import 'package:smr_app/backend/backend.dart';

class MockApi extends Api {
  const MockApi(ApiEnv env) : super(env);

  @override
  Future<bool> ensureCalendarPermission() async {
    return true;
  }

  @override
  Future<List<Calendar>> getCalendars() async {
    return mockCalendars;
  }

  @override
  Future<List<Event>> getEventsForCalendar(
    Calendar calendar, {
    @required DateTime start,
    @required DateTime end,
  }) async {
    return generateMockEvents(calendar: calendar, start: start)
        .where((event) => event.calendarId == calendar.id)
        .toList();
  }
}
