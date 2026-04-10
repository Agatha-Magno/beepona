import 'package:nectracker/interfaces/json/i_json.dart';

class LoteCreateApiModel implements IJson {
  final String id_colmeia;
  final double qtd_coleta;
  final String? armazenamentoColeta;
  final double? latitude;
  final double? longitude;
  final String? coletor;
  final String? tipoProcessamento;
  final String? localProcessamento;
  final DateTime? dataColeta;

  LoteCreateApiModel({
    required this.id_colmeia,
    required this.qtd_coleta,
    this.armazenamentoColeta,
    this.latitude,
    this.longitude,
    this.coletor,
    this.tipoProcessamento,
    this.localProcessamento,
    this.dataColeta,
  });

  factory LoteCreateApiModel.fromJson(Map<String, dynamic> json) =>
      LoteCreateApiModel(
        id_colmeia: json['id_colmeia'],
        qtd_coleta: json['qtd_coleta'],
        armazenamentoColeta: json['armazenamento_coleta'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        coletor: json['coletor'],
        tipoProcessamento: json['tipo_processamento'],
        localProcessamento: json['local_processamento'],
        dataColeta: json['data_coleta'] != null
            ? DateTime.parse(json['data_coleta'])
            : null,
      );

  @override
  Map<String, dynamic> toJson() => {
        'id_colmeia': id_colmeia,
        'qtd_coleta': qtd_coleta,
        'armazenamento_coleta': armazenamentoColeta,
        'latitude': latitude,
        'longitude': longitude,
        'coletor': coletor,
        'tipo_processamento': tipoProcessamento,
        'local_processamento': localProcessamento,
        'data_coleta': dataColeta?.toIso8601String(),
      };
}
