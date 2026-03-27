import 'package:nectracker/enums/api/metodo_enum.dart';
import 'package:nectracker/interfaces/api/i_api_endpoints_enum.dart';

enum UsuarioEndpointsEnum implements IApiEndpointsEnum {
  registrar("/registrar-usuario", ApiMetodoEnum.post),
  login("/login-usuario", ApiMetodoEnum.post),
  verificarEmail("/verificar-email", ApiMetodoEnum.get),
  reenviarAtivarEmail("/reenviar-ativacao-email", ApiMetodoEnum.post),
  solicitarResetSenha("/solicitar-reset-senha", ApiMetodoEnum.post),
  resetarSenha("/reset-senha", ApiMetodoEnum.post);

  static const String _prefixo = "/Usuario";

  final String _path;

  @override
  String get path => "$_prefixo$_path";
  @override
  final ApiMetodoEnum metodo;

  const UsuarioEndpointsEnum(this._path, this.metodo);
}
