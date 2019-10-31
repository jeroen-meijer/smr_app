import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';
import 'package:smr_app/backend/api/api.dart';
import 'package:smr_app/backend/repositories/repositories.dart';
import 'package:smr_app/backend/services/services.dart';
import 'package:smr_app/backend/stores/store.dart';

export 'api/api.dart';

class Backend {
  Backend._({
    @required this.appState,
    @required this.calendarRepository,
    @required this.faceService,
    @required this.ttsService,
    @required this.speechRecognitionService,
    @required this.animationService,
  });

  static Future<Backend> init(Api api) async {
    final appState = await AppStateStore.init();
    final calendarRepository = await CalendarRepository.init(api, appState);
    final faceService = FaceService();
    final ttsService = await TtsService.init(appState, faceService);
    final speechRecognitionService = await SpeechRecognitionService.init(appState, faceService);
    final animationService = await AnimationService.init(appState, faceService);

    return Backend._(
      appState: appState,
      calendarRepository: calendarRepository,
      faceService: faceService,
      ttsService: ttsService,
      speechRecognitionService: speechRecognitionService,
      animationService: animationService,
    );
  }

  static Backend of(BuildContext context) {
    return Provider.of<Backend>(context);
  }

  final AppStateStore appState;
  final CalendarRepository calendarRepository;
  final FaceService faceService;
  final TtsService ttsService;
  final SpeechRecognitionService speechRecognitionService;
  final AnimationService animationService;
}
