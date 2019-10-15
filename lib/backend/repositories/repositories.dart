
import 'package:smr_app/backend/api/api.dart';

export 'calendar_repository.dart';

abstract class Repository {
  Repository(this.api);

  final Api api;
}
