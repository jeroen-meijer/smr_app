import 'package:device_calendar/device_calendar.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:smr_app/backend/backend.dart';
import 'package:smr_app/ux/screens/home_screen.dart';
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

                return HomePage();
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
