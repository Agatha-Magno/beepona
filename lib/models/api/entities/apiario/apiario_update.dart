import 'package:nectracker/interfaces/json/i_json.dart';

class ApiarioUpdateApiModel implements IJson {
  final String id;
  final String nome;
  final double? latitude;
  final double? longitude;
  final bool ativo;

  ApiarioUpdateApiModel({
    required this.id,
    required this.nome,
    this.latitude,
    this.longitude,
    required this.ativo,
  });

  factory ApiarioUpdateApiModel.fromJson(Map<String, dynamic> json) =>
      ApiarioUpdateApiModel(
        id: json['id'],
        nome: json['nome'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        ativo: json['ativo'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'latitude': latitude,
        'longitude': longitude,
        'ativo': ativo,
      };
}
