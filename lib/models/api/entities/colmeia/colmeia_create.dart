import 'package:nectracker/enums/produto_enum.dart';
import 'package:nectracker/interfaces/json/i_json.dart';

class ColmeiaCreateApiModel implements IJson {
  final String apiarioId;
  final String nome;
  final ProdutoEnum produto;
  final double? peso;

  ColmeiaCreateApiModel({
    required this.apiarioId,
    required this.nome,
    required this.produto,
    required this.peso,
  });

  factory ColmeiaCreateApiModel.fromJson(Map<String, dynamic> json) =>
      ColmeiaCreateApiModel(
        apiarioId: json['apiarioId'],
        nome: json['nome'],
        produto: ProdutoEnum.toEnum(json['produto']),
        peso: json['peso'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'apiarioId': apiarioId,
        'nome': nome,
        'produto': ProdutoEnum.fromEnum(produto),
        'peso': peso,
      };
}
