import 'package:nectracker/interfaces/json/i_json.dart';

class UsuarioCreateApiModel implements IJson {
  final String nome;
  final String email;
  final String senha;
  final String confirmarSenha;

  UsuarioCreateApiModel({
    required this.nome,
    required this.email,
    required this.senha,
    required this.confirmarSenha,
  });

  factory UsuarioCreateApiModel.fromJson(Map<String, dynamic> json) =>
      UsuarioCreateApiModel(
        nome: json['nome'],
        email: json['email'],
        senha: json['senha'],
        confirmarSenha: json['confirmarSenha'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'nome': nome,
        'email': email,
        'senha': senha,
        'confirmarSenha': confirmarSenha,
      };
}
