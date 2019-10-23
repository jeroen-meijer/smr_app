import 'dart:async';

import 'package:smr_app/backend/services/services.dart';
import 'package:smr_app/backend/stores/store.dart';
import 'package:speech_recognition/speech_recognition.dart';

class SpeechRecognitionResult {
  const SpeechRecognitionResult.withResponse(this.text) : hasResponse = true;
  const SpeechRecognitionResult.empty()
      : hasResponse = false,
        text = null;

  final bool hasResponse;
  final String text;
}

class SpeechRecognitionService {
  SpeechRecognitionService._(this.appState, this.faceService) {
    _speech.setRecognitionResultHandler((text) => _speechBuffer = text);
  }

  static Future<SpeechRecognitionService> init(AppStateStore appState, FaceService faceService) async {
    await _speech.activate();

    return SpeechRecognitionService._(appState, faceService);
  }

  static SpeechRecognition get _speech => SpeechRecognition();

  final AppStateStore appState;
  final FaceService faceService;

  String _speechBuffer;

  Future<SpeechRecognitionResult> recognizeIfPresent() async {
    while (true) {
      if (!faceService.facesPresent) {
        return const SpeechRecognitionResult.empty();
      }

      final onRecognitionCompleted = Completer();

      _speech.setRecognitionCompleteHandler(onRecognitionCompleted.complete);
      await _speech.listen(locale: TtsService.locale);

      await onRecognitionCompleted.future;

      if (_speechBuffer != null && _speechBuffer.isNotEmpty) {
        final result = SpeechRecognitionResult.withResponse(_speechBuffer);
        _speechBuffer = null;
        return result;
      }
    }
  }

  Future<void> cancel() {
    return _speech.cancel();
  }
}
