import 'package:nectracker/interfaces/json/i_json.dart';

class ApiarioCreateApiModel implements IJson {
  final String nome;
  final double? latitude;
  final double? longitude;

  ApiarioCreateApiModel({
    required this.nome,
    this.latitude,
    this.longitude,
  });

  factory ApiarioCreateApiModel.fromJson(Map<String, dynamic> json) =>
      ApiarioCreateApiModel(
        nome: json['nome'],
        latitude: json['latitude'],
        longitude: json['longitude'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'nome': nome,
        'latitude': latitude,
        'longitude': longitude,
      };
}
