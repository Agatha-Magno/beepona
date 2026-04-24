import 'package:nectracker/interfaces/json/i_json.dart';

class UsuarioResetSenhaApiModel implements IJson {
  final String token;
  final String userId;
  final String senha;
  final String confirmarSenha;

  UsuarioResetSenhaApiModel({
    required this.token,
    required this.userId,
    required this.senha,
    required this.confirmarSenha,
  });

  @override
  factory UsuarioResetSenhaApiModel.fromJson(Map<String, dynamic> json) =>
      UsuarioResetSenhaApiModel(
        token: json['token'],
        userId: json['userId'],
        senha: json['senha'],
        confirmarSenha: json['confirmarSenha'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'token': token,
        'userId': userId,
        'senha': senha,
        'confirmarSenha': confirmarSenha,
      };
}
