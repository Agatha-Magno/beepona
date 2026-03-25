import 'package:nectracker/enums/produto_enum.dart';
import 'package:nectracker/interfaces/json/i_json.dart';

class ColmeiaReadUpdateApiModel implements IJson {
  final String id;
  final String nome;
  final ProdutoEnum produto;
  final double peso;
  final bool ativa;

  ColmeiaReadUpdateApiModel({
    required this.id,
    required this.nome,
    required this.produto,
    required this.peso,
    required this.ativa,
  });

  factory ColmeiaReadUpdateApiModel.fromJson(Map<String, dynamic> json) =>
      ColmeiaReadUpdateApiModel(
        id: json['id'],
        nome: json['nome'],
        produto: ProdutoEnum.toEnum(json['produto']),
        peso: json['peso'],
        ativa: json['ativa'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'produto': ProdutoEnum.fromEnum(produto),
        'peso': peso,
        'ativa': ativa,
      };
}
