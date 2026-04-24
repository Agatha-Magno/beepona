import 'package:nectracker/interfaces/json/i_json.dart';

class UsuarioConfirmarEmailModel implements IJson {
  final String userId;
  final String token;

  UsuarioConfirmarEmailModel({required this.userId, required this.token});

  @override
  factory UsuarioConfirmarEmailModel.fromJson(Map<String, dynamic> json) =>
      UsuarioConfirmarEmailModel(userId: json['userId'], token: json['token']);

  @override
  Map<String, dynamic> toJson() => {'userId': userId, 'token': token};
}
