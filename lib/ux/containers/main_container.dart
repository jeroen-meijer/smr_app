import 'package:device_calendar/device_calendar.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:smr_app/backend/backend.dart';
import 'package:smr_app/backend/models/handled_event.dart';
import 'package:smr_app/ux/widgets/face_detection_camera.dart';
import 'package:smr_app/ux/widgets/widget_utils.dart';

class MainContainer extends StatelessWidget {
  void _onFacesChanged(List<Face> faces) {
    print('Faces: ${faces.length}');
  }

  @override
  Widget build(BuildContext context) {
    final calendarRepository = Backend.of(context).calendarRepository;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: StreamBuilder<Calendar>(
              initialData: calendarRepository.selectedCalendar,
              stream: calendarRepository.selectedCalendarStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return loadingWidget;
                }

                if (!calendarRepository.hasCalendarSelected) {
                  return CalendarPicker();
                }

                return EventDisplay();
              },
            ),
          ),
          FaceDetectionCamera(
            onFacesChanged: _onFacesChanged,
          ),
        ],
      ),
    );
  }
}

class CalendarPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Text(
            'Select a calendar.',
            style: Theme.of(context).textTheme.display1,
          ),
          const Divider(),
          FutureBuilder<List<Calendar>>(
            future: Backend.of(context).calendarRepository.getCalendars(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done || !snapshot.hasData) {
                return loadingWidget;
              }

              return Column(
                children: <Widget>[
                  for (final calendar in snapshot.data)
                    ListTile(
                      title: Text(calendar.name),
                      onTap: () => Backend.of(context).calendarRepository.selectedCalendar = calendar,
                    )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class EventDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<List<Event>>(
        stream: Backend.of(context).calendarRepository.eventQueue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
            return loadingWidget;
          }

          return Column(
            children: <Widget>[
              Text(
                'Upcoming events for ${Backend.of(context).calendarRepository.selectedCalendar.name}:',
                style: Theme.of(context).textTheme.display1,
              ),
              const Divider(),
              if (snapshot.data.isEmpty) const Text('No events to display.'),
              for (final event in snapshot.data)
                ListTile(
                  title: Text(event.title),
                  subtitle: Text(event.start.toString()),
                  onTap: () => Backend.of(context).calendarRepository.handleEvent(
                        HandledEvent(
                          event: event,
                          decision: EventDecision.checkOff,
                        ),
                      ),
                ),
            ],
          );
        },
      ),
    );
  }
}
