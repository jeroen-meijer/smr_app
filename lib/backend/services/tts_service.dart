import 'package:device_calendar/device_calendar.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:smr_app/backend/models/handled_event.dart';
import 'package:smr_app/backend/services/services.dart';
import 'package:smr_app/backend/services/tts_prompts/tts_prompts.dart';
import 'package:smr_app/backend/stores/store.dart';

class TtsService {
  TtsService._(this.appState, FaceService faceService) : _prompts = TtsPrompts(appState) {
    faceService.facesPresentStream.listen((present) {
      if (present) {
        greet();
      }
    });
  }

  static Future<TtsService> init(AppStateStore appState, FaceService faceService) async {
    await _tts.setLanguage(locale);

    return TtsService._(appState, faceService);
  }

  static FlutterTts get _tts => FlutterTts();

  static const locale = 'nl_NL';

  final AppStateStore appState;

  final TtsPrompts _prompts;

  String get username => appState.username;
  set username(String value) => appState.username = value;

  bool get hasUsername => appState.hasUsername;

  Future<void> speak(String message) {
    return _tts.speak(message);
  }

  Future<void> greet() {
    return speak(_prompts.getGreeting());
  }

  Future<void> announceEvent(Event event) {
    return speak(_prompts.getEventAnnouncement(event));
  }

  Future<void> respondToDecision(EventDecision decision) {
    return speak(_prompts.getDecisionResponse(decision));
  }

  Future<void> stop() {
    return _tts.stop();
  }
}
