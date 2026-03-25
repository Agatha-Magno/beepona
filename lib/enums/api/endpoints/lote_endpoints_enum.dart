import 'package:nectracker/enums/api/metodo_enum.dart';
import 'package:nectracker/interfaces/api/i_api_endpoints_enum.dart';

enum LoteEndpointsEnum implements IApiEndpointsEnum {
  criar("/criar-lote", ApiMetodoEnum.post),
  buscarPorId("/get-lote", ApiMetodoEnum.get),
  buscarTodos("/get-all-lotes", ApiMetodoEnum.get);

  static const String _prefixo = "/Lote";

  final String _path;

  @override
  String get path => "$_prefixo$_path";
  @override
  final ApiMetodoEnum metodo;

  const LoteEndpointsEnum(this._path, this.metodo);
}
