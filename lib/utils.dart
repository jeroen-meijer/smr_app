import 'package:validators/sanitizers.dart' as sanitizers;

T selectRandom<T>(List<T> elements) {
  return (List.from(elements)..shuffle()).first;
}

String toAlphanumeric(String value) {
  return sanitizers.whitelist(value, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 &+-').trim();
}