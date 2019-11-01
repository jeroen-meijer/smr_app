import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:smr_app/backend/backend.dart';
import 'package:smr_app/backend/services/services.dart';
import 'package:smr_app/ux/screens/home_screen/event_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          child: Container(
            color: Colors.grey,
            alignment: Alignment.topCenter,
            child: StreamBuilder<AnimationState>(
              stream: Backend.of(context).animationService.animationStateStream,
              initialData: Backend.of(context).animationService.currentAnimationState,
              builder: (context, snapshot) {
                final facesPresent = Backend.of(context).faceService.facesPresent;
                final animationState =
                    snapshot.hasData ? snapshot.data : facesPresent ? AnimationState.awakened : AnimationState.closed;
                return SizedBox(
                  height: 300,
                  child: FlareActor(
                    'assets/flare/eyes.flr',
                    animation: animationState.toString(),
                    alignment: Alignment.topCenter,
                    fit: BoxFit.fitHeight,
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(
          child: EventList(),
        ),
      ],
    );
  }
}
