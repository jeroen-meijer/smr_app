import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:smr_app/backend/models/event_type.dart';
import 'package:smr_app/utils.dart';
import 'package:smr_app/ux/widgets/widget_utils.dart';

class EventCard extends StatelessWidget {
  EventCard({
    Key key,
    @required this.event,
  })  : eventType = EventType.fromEvent(event),
        super(key: key);

  final Event event;
  final EventType eventType;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        toAlphanumeric(event.title),
                        style: TextStyle(
                          fontSize: 24,
                          color: eventType.color,
                        ),
                      ),
                      const Divider(
                        endIndent: 32,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
                horizontalMargin4,
                Icon(
                  eventType.icon,
                  color: eventType.color,
                  size: 42,
                ),
                horizontalMargin12,
              ],
            ),
            verticalMargin12,
            if (event.description != null && event.description.isNotEmpty)
              Expanded(
                child: Text(
                  event.description,
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            else
              Text(
                'Deze afspraak heeft geen beschrijving.',
                style: TextStyle(color: Colors.grey.shade600),
              ),
          ],
        ),
      ),
    );
  }
}
