// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'handled_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HandledEvent _$HandledEventFromJson(Map json) {
  return HandledEvent(
    const EventConverter().fromJson(json['event'] as Map<String, dynamic>),
    decision: json['decision'] == null
        ? null
        : EventDecision.fromJson(json['decision'] as String),
    remindDate: json['remind_date'] == null
        ? null
        : DateTime.parse(json['remind_date'] as String),
  );
}

Map<String, dynamic> _$HandledEventToJson(HandledEvent instance) =>
    <String, dynamic>{
      'event': const EventConverter().toJson(instance.event),
      'decision': instance.decision?.toJson(),
      'remind_date': instance.remindDate?.toIso8601String(),
    };
