import 'package:nectracker/interfaces/json/i_json.dart';

class ApiarioReadApiModel implements IJson {
  final String id;
  final String nome;
  final double? latitude;
  final double? longitude;
  final int qtdColmeias;
  final bool ativo;

  ApiarioReadApiModel({
    required this.id,
    required this.nome,
    this.latitude,
    this.longitude,
    required this.qtdColmeias,
    required this.ativo,
  });

  factory ApiarioReadApiModel.fromJson(Map<String, dynamic> json) =>
      ApiarioReadApiModel(
        id: json['id'],
        nome: json['nome'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        qtdColmeias: json['qtdColmeias'],
        ativo: json['ativo'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'latitude': latitude,
        'longitude': longitude,
        'qtdColmeias': qtdColmeias,
        'ativo': ativo,
      };
}
