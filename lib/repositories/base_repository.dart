import 'package:nectracker/clients/api/beepona_api.dart';

abstract class BaseRepository {
  final BeeponaApi api;

  BaseRepository({BeeponaApi? api}) : api = api ?? BeeponaApi();
}
