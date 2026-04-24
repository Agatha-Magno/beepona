import 'package:nectracker/interfaces/json/i_json.dart';

class UsuarioInfoApiModel implements IJson {
  final String nome;
  final String email;

  UsuarioInfoApiModel({
    required this.nome,
    required this.email,
  });

  @override
  factory UsuarioInfoApiModel.fromJson(Map<String, dynamic> json) =>
      UsuarioInfoApiModel(
        nome: json['nome'],
        email: json['email'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'nome': nome,
        'email': email,
      };
}
