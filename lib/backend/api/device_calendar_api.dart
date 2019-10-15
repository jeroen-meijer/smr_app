import 'package:device_calendar/device_calendar.dart';
import 'package:meta/meta.dart';
import 'package:smr_app/backend/backend.dart';

class DeviceCalendarApi extends Api {
  const DeviceCalendarApi(ApiEnv env) : super(env);

  @override
  Future<bool> ensureCalendarPermission() async {
    final hasPermission = (await DeviceCalendarPlugin().hasPermissions()).data;
    return hasPermission || (await DeviceCalendarPlugin().requestPermissions()).data;
  }

  @override
  Future<List<Calendar>> getCalendars() async {
    final result = await DeviceCalendarPlugin().retrieveCalendars();

    return result.data;
  }

  @override
  Future<List<Event>> getEventsForCalendar(
    Calendar calendar, {
    @required DateTime start,
    @required DateTime end,
  }) async {
    final result = await DeviceCalendarPlugin().retrieveEvents(
      calendar.id,
      RetrieveEventsParams(startDate: start, endDate: end),
    );

    return result.data;
  }
}
