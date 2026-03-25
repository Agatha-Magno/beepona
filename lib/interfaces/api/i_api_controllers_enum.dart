import 'package:nectracker/interfaces/api/i_api_endpoints_enum.dart';

abstract interface class IApiControllersEnum {
  String get path;
  List<IApiEndpointsEnum> get endpoints;
}
