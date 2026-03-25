class UsuarioInfoApiModel {
  final String nome;
  final String email;

  UsuarioInfoApiModel({
    required this.nome,
    required this.email,
  });

  factory UsuarioInfoApiModel.fromJson(Map<String, dynamic> json) =>
      UsuarioInfoApiModel(
        nome: json['nome'],
        email: json['email'],
      );

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'email': email,
      };
}
