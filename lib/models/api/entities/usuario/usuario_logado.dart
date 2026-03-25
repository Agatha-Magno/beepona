import 'package:nectracker/models/api/entities/usuario/usuario_info.dart';

class UsuarioLogadoApiModel {
  final String token;
  final UsuarioInfoApiModel usuario;

  UsuarioLogadoApiModel({
    required this.token,
    required this.usuario,
  });

  factory UsuarioLogadoApiModel.fromJson(Map<String, dynamic> json) =>
      UsuarioLogadoApiModel(
        token: json['token'],
        usuario: UsuarioInfoApiModel.fromJson(json['usuario']),
      );

  Map<String, dynamic> toJson() => {
        'token': token,
        'usuario': usuario.toJson(),
      };
}
