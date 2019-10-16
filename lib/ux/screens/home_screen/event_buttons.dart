import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smr_app/backend/models/handled_event.dart';
import 'package:smr_app/ux/ux_utils.dart';
import 'package:smr_app/ux/widgets/widget_utils.dart';

class EventButtons extends StatelessWidget {
  const EventButtons({
    Key key,
    @required this.enabled,
    @required this.onDecide,
  }) : super(key: key);

  final bool enabled;
  final ValueChanged<EventDecision> onDecide;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        horizontalMargin24,
        Flexible(
          child: _EventButton(
            caption: 'Herinner',
            color: getColorForEventDecision(EventDecision.postpone),
            icon: getIconForEventDecision(EventDecision.postpone),
            enabled: enabled,
            onPressed: () => onDecide(EventDecision.postpone),
          ),
        ),
        horizontalMargin16,
        Flexible(
          child: _EventButton(
            caption: 'Vink af',
            color: getColorForEventDecision(EventDecision.checkOff),
            icon: getIconForEventDecision(EventDecision.checkOff),
            enabled: enabled,
            onPressed: () => onDecide(EventDecision.checkOff),
          ),
        ),
        horizontalMargin24,
      ],
    );
  }
}

class _EventButton extends StatelessWidget {
  const _EventButton({
    Key key,
    @required this.caption,
    @required this.icon,
    @required this.color,
    this.enabled = true,
    @required this.onPressed,
  }) : super(key: key);

  static const _buttonTextColor = Colors.white;

  final String caption;
  final IconData icon;
  final Color color;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: color,
      disabledColor: Colors.grey.shade300,
      onPressed: enabled ? onPressed : null,
      child: SizedBox(
        height: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: _buttonTextColor,
            ),
            horizontalMargin4,
            Text(
              caption,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                color: _buttonTextColor,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
