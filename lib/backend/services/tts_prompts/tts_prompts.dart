import 'package:device_calendar/device_calendar.dart';
import 'package:smr_app/backend/models/models.dart';
import 'package:smr_app/backend/services/tts_prompts/decision_response.dart';
import 'package:smr_app/backend/services/tts_prompts/event_announcement.dart';
import 'package:smr_app/backend/services/tts_prompts/greeting.dart';
import 'package:smr_app/backend/stores/store.dart';
import 'package:smr_app/utils.dart';

class TtsPrompts {
  const TtsPrompts(this.appState);

  final AppStateStore appState;

  String getGreeting() {
    if (appState.hasUsername) {
      return selectRandom(getGreetingsWithName(appState.username));
    }

    return selectRandom(getGreetings());
  }

  String getEventAnnouncement(Event event) {
    return 'Hey${appState.hasUsername ? ' ${appState.username}' : ''}. ${selectRandom(getEventAnnouncements(event))} Wat wil je met deze afspraak doen?';
  }

  String getDecisionResponse(EventDecision decision) {
    if (decision == EventDecision.checkOff) {
      return selectRandom(getCheckOffDecisionResponse());
    }
    if (decision == EventDecision.postpone) {
      return selectRandom(getPostponeDecisionResponse());
    }

    throw ArgumentError.value(decision, 'decision', 'Given EventDecision has no corresponding response.');
  }
}
