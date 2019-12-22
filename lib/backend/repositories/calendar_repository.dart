import 'dart:async';

import 'package:device_calendar/device_calendar.dart';
import 'package:meta/meta.dart';
import 'package:smr_app/backend/api/api.dart';
import 'package:smr_app/backend/models/models.dart';
import 'package:smr_app/backend/repositories/repositories.dart';
import 'package:smr_app/backend/stores/store.dart';
import 'package:smr_app/utils.dart';

class CalendarRepository extends Repository {
  CalendarRepository._(Api api, this.appState) : super(api) {
    _eventQueue.add([]);
    if (hasCalendarSelected) {
      _resetTimer();
    }
  }

  static Future<CalendarRepository> init(Api api, AppStateStore appState) async {
    await api.ensureCalendarPermission();

    return CalendarRepository._(api, appState);
  }

  static const _eventCheckInterval = Duration(seconds: 10);

  static const eventTimespanLimit = Duration(minutes: 15);

  final AppStateStore appState;

  final _eventQueue = StreamController<List<Event>>.broadcast();

  Timer _eventCheckTimer;

  Stream<List<Event>> get eventQueue => _eventQueue.stream;

  List<HandledEvent> get handledEvents => appState.handledEvents;

  Calendar get selectedCalendar => appState.selectedCalendar;

  set selectedCalendar(Calendar calendar) {
    appState.selectedCalendar = calendar;
    _resetTimer();
  }

  Stream<Calendar> get selectedCalendarStream => appState.selectedCalendarStream;

  bool get hasCalendarSelected => appState.hasCalendarSelected;

  void _resetTimer() {
    _eventCheckTimer = Timer.periodic(_eventCheckInterval, (_) => _checkForNewEvents());
    _checkForNewEvents();
  }

  Future<void> _checkForNewEvents() async {
    print('${DateTime.now()} - _checkForNewEvents');
    assert(hasCalendarSelected, 'No calendar is selected yet. Cannot check for events if no calendar is selected.');

    final events = await api.getEventsForCalendar(
      selectedCalendar,
      start: DateTime.now(),
      end: DateTime.now().add(eventTimespanLimit),
    );
    print(
      '... original events - '
      '[${events.isEmpty ? 'NONE' : events.map((event) => '${event.title} (${event.eventId})').join(', ')}]',
    );

    final postponedEvents = safeWhere<HandledEvent>(handledEvents, (handledEvent) {
      final eventWasPostponed = handledEvent.decision == EventDecision.postpone;
      final eventIsTimedOut = DateTime.now().compareTo(handledEvent.remindDate) == 1;
      final eventIsTooOld = eventIsTimedOut && (DateTime.now().difference(handledEvent.event.start).inHours).abs() > 24;

      return eventWasPostponed && eventIsTimedOut && !eventIsTooOld;
    }).map((handledEvent) => handledEvent.event).toList();

    print(
      '... postponed events - '
      '[${postponedEvents.isEmpty ? 'NONE' : postponedEvents.map((event) => '${event.title} (${event.eventId})').join(', ')}]',
    );

    final queue = events
        .where((event) => !handledEvents.map((handledEvent) => handledEvent.event.eventId).contains(event.eventId))
        .toList()
          ..addAll(postponedEvents);
    // ..addAll()

    print(
      '${DateTime.now()} - pushing events: '
      '[${queue.isEmpty ? 'NONE' : queue.map((event) => '${event.title} (${event.eventId})').join(', ')}]',
    );
    _eventQueue.add(queue);
  }

  // Class functions
  void dispose() {
    _eventCheckTimer.cancel();
    _eventQueue.close();
  }

  Future<List<Calendar>> getCalendars() {
    return api.getCalendars();
  }

  Future<List<Event>> getEventsForCalendar(
    Calendar calendar, {
    @required DateTime start,
    @required DateTime end,
  }) {
    return api.getEventsForCalendar(calendar, start: start, end: end);
  }

  // Store functions

  /// Either checks off or postpones an event's reminder from the `eventQueue`.
  void handleEvent(HandledEvent handledEvent) {
    appState.addHandledEvent(handledEvent);
    _checkForNewEvents();
  }
}
