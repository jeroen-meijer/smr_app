import 'package:flutter/material.dart';
import 'package:smr_app/ux/screens/home_screen/event_list.dart';

enum AnimationState {
  closed,
  awakened,
  darting,
  happy,
  sad,
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var animationState = AnimationState.closed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Placeholder(color: Colors.black.withOpacity(0.2)),
              Text(
                '$animationState',
                style: const TextStyle(fontSize: 24, fontFamily: 'Monospace'),
              ),
            ],
          ),
        ),
        Expanded(
          child: EventList(),
        ),
      ],
    );
  }
}
