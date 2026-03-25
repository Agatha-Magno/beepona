import 'package:nectracker/interfaces/json/i_json.dart';

class LoteReadApiModel implements IJson {
  final String id;
  final double qtdColeta;
  final String? armazenamentoColeta;
  final double? latitude;
  final double? longitude;
  final String? coletor;
  final String? tipoProcessamento;
  final String? localProcessamento;
  final DateTime dataColeta;

  LoteReadApiModel({
    required this.id,
    required this.qtdColeta,
    this.armazenamentoColeta,
    this.latitude,
    this.longitude,
    this.coletor,
    this.tipoProcessamento,
    this.localProcessamento,
    required this.dataColeta,
  });

  factory LoteReadApiModel.fromJson(Map<String, dynamic> json) =>
      LoteReadApiModel(
        id: json['id'],
        qtdColeta: json['qtd_coleta'],
        armazenamentoColeta: json['armazenamento_coleta'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        coletor: json['coletor'],
        tipoProcessamento: json['tipo_processamento'],
        localProcessamento: json['local_processamento'],
        dataColeta: json['data_coleta'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'qtd_coleta': qtdColeta,
        'armazenamento_coleta': armazenamentoColeta,
        'latitude': latitude,
        'longitude': longitude,
        'coletor': coletor,
        'tipo_processamento': tipoProcessamento,
        'local_processamento': localProcessamento,
        'data_coleta': dataColeta,
      };
}
