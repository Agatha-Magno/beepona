import 'package:nectracker/interfaces/json/i_json.dart';
import 'package:nectracker/models/api/entities/usuario/usuario_info.dart';

class UsuarioLogadoApiModel implements IJson {
  final String token;
  final UsuarioInfoApiModel usuario;

  UsuarioLogadoApiModel({
    required this.token,
    required this.usuario,
  });

  @override
  factory UsuarioLogadoApiModel.fromJson(Map<String, dynamic> json) =>
      UsuarioLogadoApiModel(
        token: json['token'],
        usuario: UsuarioInfoApiModel.fromJson(json['usuario']),
      );

  @override
  Map<String, dynamic> toJson() => {
        'token': token,
        'usuario': usuario.toJson(),
      };
}
