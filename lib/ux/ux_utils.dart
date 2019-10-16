import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smr_app/backend/models/handled_event.dart';

IconData getIconForEventDecision(EventDecision decision) {
  if (decision == EventDecision.checkOff) {
    return FontAwesomeIcons.check;
  }
  if (decision == EventDecision.postpone) {
    return FontAwesomeIcons.clock;
  }

  throw ArgumentError.value(decision, 'decision', 'Given EventDecision has no corresponding icon.');
}

Color getColorForEventDecision(EventDecision decision) {
  if (decision == EventDecision.checkOff) {
    return Colors.green;
  }
  if (decision == EventDecision.postpone) {
    return Colors.pink;
  }

  throw ArgumentError.value(decision, 'decision', 'Given EventDecision has no corresponding color.');
}
