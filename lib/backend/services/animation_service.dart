import 'dart:async';

import 'package:smr_app/backend/services/face_service.dart';
import 'package:smr_app/backend/stores/store.dart';

class AnimationState {
  const AnimationState._(this._value);

  static const closed = AnimationState._('closed');
  static const awakened = AnimationState._('awakened');
  static const happy = AnimationState._('happy');
  static const sad = AnimationState._('sad');

  static List<AnimationState> get values => [
        closed,
        awakened,
        happy,
        sad,
      ];

  final String _value;

  factory AnimationState.fromJson(String json) => values.firstWhere((e) => e._value == json);

  String toJson() => toString();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is AnimationState && runtimeType == other.runtimeType && _value == other._value) {
      return true;
    }
    if (other is String) {
      return _value == other;
    }
    return false;
  }

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() {
    return _value;
  }
}

class AnimationService {
  AnimationService._(this.appState, this.faceService) {
    faceService.facesPresentStream.listen((facesPresent) {
      setAnimationState(facesPresent ? AnimationState.awakened : AnimationState.closed);
    });
  }

  static Future<AnimationService> init(AppStateStore appState, FaceService faceService) async {
    return AnimationService._(appState, faceService);
  }

  final AppStateStore appState;
  final FaceService faceService;

  final _animationStateStream = StreamController<AnimationState>.broadcast();

  AnimationState _currentAnimationState;

  AnimationState get currentAnimationState => _currentAnimationState;
  Stream<AnimationState> get animationStateStream => _animationStateStream.stream;

  void setAnimationState(AnimationState state) {
    _currentAnimationState = state;
    _animationStateStream.add(_currentAnimationState);
  }

  void dispose() {
    _animationStateStream.close();
  }
}
