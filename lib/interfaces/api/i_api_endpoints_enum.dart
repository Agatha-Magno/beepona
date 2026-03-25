import 'package:nectracker/enums/api/metodo_enum.dart';

abstract interface class IApiEndpointsEnum {
  String get path;
  ApiMetodoEnum get metodo;
}
