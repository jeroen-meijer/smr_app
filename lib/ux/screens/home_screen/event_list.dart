import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:smr_app/backend/api/mock/mock_events.dart';
import 'package:smr_app/backend/backend.dart';
import 'package:smr_app/backend/models/handled_event.dart';
import 'package:smr_app/backend/repositories/repositories.dart';
import 'package:smr_app/ux/screens/home_screen/event_buttons.dart';
import 'package:smr_app/ux/screens/home_screen/event_card.dart';

class EventList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final calendarRepository = Backend.of(context).calendarRepository;
    return Column(
      children: <Widget>[
        Text(
          'Volgende afspraken',
          style: Theme.of(context).textTheme.display1.copyWith(color: Theme.of(context).primaryColor),
        ),
        const Divider(),
        Expanded(
          child: StreamBuilder<List<Event>>(
            stream: calendarRepository.eventQueue,
            initialData: const [],
            builder: (context, snapshot) {
              // final events = snapshot.data;
              final events = mockEvents.skip(2);

              Widget calendarWidget;

              if (events.isEmpty) {
                calendarWidget = Center(
                  child: Text(
                    'Geen afspraken binnen '
                    '${CalendarRepository.eventTimespanLimit.inMinutes} minuten.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                );
              } else {
                calendarWidget = EventCard(event: events.first);
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
                      enabled: events.isNotEmpty,
                      onDecide: (decision) {
                        print('decision');
                      },
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
