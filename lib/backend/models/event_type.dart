import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

part 'event_type_keywords.dart';

class EventType {
  const EventType._(
    this.value, {
    @required this.color,
    @required this.icon,
  });

  factory EventType.fromEvent(Event event) {
    for (final entry in _eventTypeKeywords.entries) {
      final eventWords = event.title.split(' ') + (event.description?.split(' ') ?? []);
      if (eventWords.any((word) => entry.value.contains(word.toLowerCase()))) {
        return entry.key;
      }
    }

    return EventType.other;
  }

  static const medication = EventType._(
    'Medication',
    color: Colors.green,
    icon: FontAwesomeIcons.pills,
  );
  static const people = EventType._(
    'People',
    color: Colors.blue,
    icon: FontAwesomeIcons.userFriends,
  );
  static const other = EventType._(
    'Other',
    color: Colors.blueGrey,
    icon: FontAwesomeIcons.calendarAlt,
  );

  static List<EventType> get values => [
        medication,
        people,
        other,
      ];

  final String value;
  final Color color;
  final IconData icon;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is EventType && runtimeType == other.runtimeType && value == other.value) {
      return true;
    }
    if (other is String) {
      return value == other;
    }
    return false;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return value;
  }
}
