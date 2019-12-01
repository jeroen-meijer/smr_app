import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:smr_app/backend/backend.dart';
import 'package:smr_app/backend/services/services.dart';
import 'package:smr_app/ux/screens/home_screen/event_list.dart';
import 'package:smr_app/ux/widgets/widget_utils.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final backend = Backend.of(context);

    return Row(
      children: <Widget>[
        Flexible(
          child: Container(
            color: Colors.grey,
            alignment: Alignment.topCenter,
            child: StreamBuilder<AnimationState>(
              stream: backend.animationService.animationStateStream,
              initialData: backend.animationService.currentAnimationState,
              builder: (context, snapshot) {
                final facesPresent = backend.faceService.facesPresent;
                final animationState =
                    snapshot.hasData ? snapshot.data : facesPresent ? AnimationState.awakened : AnimationState.closed;
                return SizedBox(
                  height: 200,
                  child: FlareActor(
                    'assets/flare/eyes.flr',
                    animation: animationState.toString(),
                    alignment: Alignment.topCenter,
                  ),
                );
              },
            ),
          ),
        ),
        Flexible(
          child: StreamBuilder<bool>(
              stream: backend.faceService.facesPresentStream,
              builder: (context, snapshot) {
                final hasFaces = snapshot.hasData ? snapshot.data : backend.faceService.facesPresent;
                if (!hasFaces) {
                  return emptyWidget;
                }

                return EventList();
              }),
        ),
      ],
    );
  }
}
