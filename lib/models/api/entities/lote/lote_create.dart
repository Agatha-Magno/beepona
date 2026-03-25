import 'package:nectracker/interfaces/json/i_json.dart';

class LoteCreateApiModel implements IJson {
  final String colmeiaId;
  final double qtdColeta;
  final String? armazenamentoColeta;
  final double? latitude;
  final double? longitude;
  final String? coletor;
  final String? tipoProcessamento;
  final String? localProcessamento;
  final DateTime? dataColeta;

  LoteCreateApiModel({
    required this.colmeiaId,
    required this.qtdColeta,
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
        colmeiaId: json['id_colmeia'],
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
        'id_colmeia': colmeiaId,
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
