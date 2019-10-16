import 'package:meta/meta.dart';
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