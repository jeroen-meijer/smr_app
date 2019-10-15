import 'dart:async';

import 'package:device_calendar/device_calendar.dart';
import 'package:meta/meta.dart';

class ApiEnv {
  const ApiEnv._();

  static const live = ApiEnv._();
}

abstract class Api {
  const Api(this.env);

  final ApiEnv env;

  Future<bool> ensureCalendarPermission();
  Future<List<Calendar>> getCalendars();
  Future<List<Event>> getEventsForCalendar(
    Calendar calendar, {
    @required DateTime start,
    @required DateTime end,
  });
}
