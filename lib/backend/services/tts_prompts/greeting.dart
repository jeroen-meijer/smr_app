import 'package:smr_app/utils.dart';

List<String> getGreetings() {
  final now = DateTime.now();
  return [
    'Hallo daar!',
    'Welkom terug.',
    'Hi. Leuk je weer te zien!',
    if (now.hour >= 6 && now.hour < 12)
      'Goeiemorgen.'
    else if (now.hour >= 12 && now.hour < 18)
      'Goeiemiddag.'
    else if (now.hour >= 18)
      'Goeienavond.'
    else
      'Goeienacht.',
  ];
}

List<String> getGreetingsWithName(String name) {
  final now = DateTime.now();
  return [
    'Hallo daar, $name!',
    'Welkom terug, $name.',
    'Hi, $name. Leuk je weer te zien!',
    if (now.hour >= 6 && now.hour < 12)
      'Goeiemorgen, $name.'
    else if (now.hour >= 12 && now.hour < 18)
      'Goeiemiddag, $name.'
    else if (now.hour >= 18)
      'Goeienavond, $name.'
    else
      'Goeienacht, $name.',
  ];
}
