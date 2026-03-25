import 'package:nectracker/enums/api/metodo_enum.dart';
import 'package:nectracker/interfaces/api/i_api_endpoints_enum.dart';

enum ApiarioEndpointsEnum implements IApiEndpointsEnum {
  criar("/criar-apiario", ApiMetodoEnum.post),
  atualizar("/atualizar-apiario", ApiMetodoEnum.put),
  buscarPorId("/get-apiario", ApiMetodoEnum.get),
  buscarTodos("/get-all-apiarios", ApiMetodoEnum.get);

  static const String _prefixo = "/Apiario";

  final String _path;

  @override
  String get path => "$_prefixo$_path";
  @override
  final ApiMetodoEnum metodo;

  const ApiarioEndpointsEnum(this._path, this.metodo);
}
