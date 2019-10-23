import 'package:meta/meta.dart';
import 'package:smr_app/backend/models/models.dart';
import 'package:validators/sanitizers.dart' as sanitizers;

T selectRandom<T>(List<T> elements) {
  return (List.from(elements)..shuffle()).first;
}

String toAlphanumeric(String value) {
  return sanitizers.whitelist(value, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 &+-').trim();
}

Iterable<E> safeWhere<E>(Iterable<E> iterable, bool Function(E element) test) {
  try {
    return iterable.where(test);
  } on StateError {
    return <E>[];
  }
}

String padLeft(num value, {@required int amount, String paddingCharacter = '0'}) {
  final padAmount = amount - value.toString().length;
  return paddingCharacter * (padAmount < 0 ? 0 : padAmount) + value.toString();
}

String padRight(num value, {@required int amount, String paddingCharacter = '0'}) {
  final padAmount = amount - value.toString().length;
  return value.toString() + paddingCharacter * (padAmount < 0 ? 0 : padAmount);
}

EventDecision guessDecisionFromString(String text) {
  final words = text.split(' ').map((word) => word.toLowerCase());

  bool _has(String word) => words.contains(word);

  if ((_has('vink') && _has('af')) || _has('afvinken') || (_has('hoeft') && _has('niet') && _has('herinneren'))) {
    return EventDecision.checkOff;
  }

  return EventDecision.postpone;
}
