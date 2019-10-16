import 'dart:async';

class FaceService {
  FaceService() {
    _facesPresentStream.add(_facesPresent);
  }

  static const _facesPresentTimeoutDuration = Duration(minutes: 2);

  final _facesPresentStream = StreamController<bool>.broadcast();

  bool _facesPresent = false;
  Timer _facesPresentTimeoutTimer;

  bool get facesPresent => _facesPresent;
  Stream<bool> get facesPresentStream => _facesPresentStream.stream;

  void _setFacesPresent(bool value) {
    if (_facesPresent != value) {
      _facesPresent = value;
      _facesPresentStream.add(value);
    }
  }

  void _startFacesPresentTimeoutCountdown() {
    _facesPresentTimeoutTimer = Timer(_facesPresentTimeoutDuration, () {
      _setFacesPresent(false);
    });
  }

  void dispose() {
    _facesPresentTimeoutTimer?.cancel();
    _facesPresentStream.close();
  }

  void registerFacesPresent(bool present) {
    if (present) {
      _facesPresentTimeoutTimer?.cancel();
      _setFacesPresent(true);
    } else {
      _startFacesPresentTimeoutCountdown();
    }
  }
}
