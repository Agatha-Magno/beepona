import 'package:nectracker/interfaces/json/i_json.dart';

class UsuarioAuthApiModel implements IJson {
  final String email;
  final String senha;

  UsuarioAuthApiModel({
    required this.email,
    required this.senha,
  });

  factory UsuarioAuthApiModel.fromJson(Map<String, dynamic> json) =>
      UsuarioAuthApiModel(
        email: json['email'],
        senha: json['senha'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'email': email,
        'senha': senha,
      };
}
