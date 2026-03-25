import 'package:nectracker/enums/api/metodo_enum.dart';
import 'package:nectracker/interfaces/api/i_api_endpoints_enum.dart';

enum ColmeiaEndpointsEnum implements IApiEndpointsEnum {
  criar("/criar-colmeia", ApiMetodoEnum.post),
  atualizar("/atualizar-colmeia", ApiMetodoEnum.put),
  buscarPorId("/get-colmeia", ApiMetodoEnum.get),
  buscarTodos("/get-all-colmeias", ApiMetodoEnum.get),
  buscarLogs("/get-colmeia-logs", ApiMetodoEnum.get);

  static const String _prefixo = "/Colmeia";

  final String _path;

  @override
  String get path => "$_prefixo$_path";
  @override
  final ApiMetodoEnum metodo;

  const ColmeiaEndpointsEnum(this._path, this.metodo);
}
