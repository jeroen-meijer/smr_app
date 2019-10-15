import 'package:device_calendar/device_calendar.dart';
import 'package:smr_app/backend/models/models.dart';
import 'package:state_persistence/state_persistence.dart';
import 'package:smr_app/backend/stores/store.dart';

class AppStateStore extends Store {
  AppStateStore._(this._data) : super(_data);

  static const _kStorage = JsonFileStorage(filename: 'smr_app_state_store.json');
  static const _kSaveTimeout = Duration(milliseconds: 500);

  static const _kSelectedCalendarKey = 'selectedCalendar';
  static const _kHandledEventsKey = 'handledEvents';

  static Future<AppStateStore> init() async {
    final data = await PersistedData.load(_kStorage, _kSaveTimeout);

    return AppStateStore._(data);
  }

  final PersistedData _data;

  Calendar get selectedCalendar =>
      _data[_kSelectedCalendarKey] == null ? null : Calendar.fromJson(_data[_kSelectedCalendarKey]);
  set selectedCalendar(Calendar value) => _data[_kSelectedCalendarKey] = value.toJson();

  bool get hasCalendarSelected => selectedCalendar != null;

  List<HandledEvent> get handledEvents => _data[_kHandledEventsKey] == null
      ? []
      : (_data[_kHandledEventsKey] as List).map((json) => HandledEvent.fromJson(json)).toList();
  set handledEvents(List<HandledEvent> value) => _data[_kHandledEventsKey] = value.map((handledEvent) => handledEvent.toJson()).toList();

  void addHandledEvent(HandledEvent handledEvent) {
    final newHandledEvents = handledEvents;

    final existingIndex = newHandledEvents.map((e) => e.event.eventId).toList().indexOf(handledEvent.event.eventId);

    if (existingIndex == -1) {
      newHandledEvents.add(handledEvent);
    } else {
      newHandledEvents.replaceRange(existingIndex, existingIndex, [handledEvent]);
    }

    handledEvents = newHandledEvents;
  }
}
