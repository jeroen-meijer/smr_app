import 'package:device_calendar/device_calendar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:smr_app/backend/models/event_converter.dart';

part 'handled_event.g.dart';

@JsonSerializable()
class HandledEvent {
  HandledEvent({
    @required this.event,
    @required this.decision,
  });

  @EventConverter()
  final Event event;
  final EventDecision decision;

  factory HandledEvent.fromJson(Map<String, dynamic> json) => _$HandledEventFromJson(json);

  Map<String, dynamic> toJson() => _$HandledEventToJson(this);
}

class EventDecision {
  const EventDecision._(this._value);

  static const checkOff = EventDecision._('checkOff');
  static const postpone = EventDecision._('postpone');

  static List<EventDecision> get values => [
        checkOff,
        postpone,
      ];

  final String _value;

  factory EventDecision.fromJson(String json) => values.firstWhere((e) => e._value == json);

  String toJson() => toString();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is EventDecision && runtimeType == other.runtimeType && _value == other._value) {
      return true;
    }
    if (other is String) {
      return _value == other;
    }
    return false;
  }

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() {
    return _value;
  }
}
