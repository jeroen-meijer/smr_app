import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:smr_app/backend/models/handled_event.dart';
import 'package:smr_app/backend/repositories/repositories.dart';
import 'package:smr_app/ux/context.dart';
import 'package:smr_app/ux/screens/home_screen/event_buttons.dart';
import 'package:smr_app/ux/screens/home_screen/event_card.dart';
import 'package:smr_app/ux/ux_utils.dart';

class EventList extends StatefulWidget {
  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> with WidgetContext {
  String _lastShownEventId;
  EventDecision _lastShownEventDecision;

  bool get _shouldShowConfirmation => _lastShownEventDecision != null;

  void _announceEventOnce(Event event) {
    if (_lastShownEventId == event.eventId) {
      return;
    }

    _lastShownEventId = event.eventId;
    backend.ttsService.announceEvent(event);
  }

  Future<void> _onDecide(Event event, EventDecision decision) async {
    setState(() {
      _lastShownEventDecision = decision;
    });

    await backend.ttsService.respondToDecision(decision);
    await Future.delayed(const Duration(seconds: 5));

    setState(() {
      _lastShownEventDecision = null;
    });

    final handledEvent = HandledEvent(event: event, decision: decision);
    backend.calendarRepository.handleEvent(handledEvent);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'Volgende afspraak',
          style: Theme.of(context).textTheme.display1.copyWith(color: Theme.of(context).primaryColor),
        ),
        const Divider(),
        Expanded(
          child: StreamBuilder<List<Event>>(
            stream: backend.calendarRepository.eventQueue,
            initialData: const [],
            builder: (context, snapshot) {
              final events = snapshot.data;

              Widget calendarWidget;

              if (events.isEmpty) {
                calendarWidget = Center(
                  child: Text(
                    'Geen afspraken binnen '
                    '${CalendarRepository.eventTimespanLimit.inMinutes} minuten.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                );
              } else {
                final currentEvent = events.first;
                calendarWidget = Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: _shouldShowConfirmation ? 0.5 : 1.0,
                      child: EventCard(event: currentEvent),
                    ),
                    if (_shouldShowConfirmation)
                      Center(
                        child: Icon(
                          getIconForEventDecision(_lastShownEventDecision),
                          color: getColorForEventDecision(_lastShownEventDecision),
                          size: 48,
                        ),
                      )
                  ],
                );

                _announceEventOnce(currentEvent);
              }

              assert(calendarWidget != null, 'calendarWidget must be set and not null.');

              return Column(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: calendarWidget,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                    child: EventButtons(
                      enabled: !_shouldShowConfirmation && events.isNotEmpty,
                      onDecide: (decision) => _onDecide(events.first, decision),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
