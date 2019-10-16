import 'package:device_calendar/device_calendar.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:smr_app/backend/backend.dart';
import 'package:smr_app/ux/screens/home_screen.dart';
import 'package:smr_app/ux/widgets/face_detection_camera.dart';
import 'package:smr_app/ux/widgets/widget_utils.dart';

class MainContainer extends StatelessWidget {
  void _onFacesChanged(
    BuildContext context,
    List<Face> faces,
  ) {
    Backend.of(context).faceService.registerFacesPresent(faces.isNotEmpty);
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
                if (!calendarRepository.hasCalendarSelected) {
                  return CalendarPicker();
                }

                return HomePage();
              },
            ),
          ),
          Offstage(
            offstage: false,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Opacity(
                opacity: 0.9,
                child: FaceDetectionCamera(
                  onFacesChanged: (faces) {
                    _onFacesChanged(context, faces);
                  },
                ),
              ),
            ),
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
