import 'package:nectracker/enums/api/endpoints/lote_endpoints_enum.dart';
import 'package:nectracker/models/api/entities/lote/lote_create.dart';
import 'package:nectracker/models/api/entities/lote/lote_read.dart';
import 'package:nectracker/repositories/base_repository.dart';

class LoteRepository extends BaseRepository {
  LoteRepository({super.api});

  Future<void> criar(LoteCreateApiModel lote) async {
    final response = await api.request(
      endpoint: LoteEndpointsEnum.criar,
      data: lote.toJson(),
    );

    if (!response.success) {
      final errorMessage = response.message ??
          response.errors?.toString() ??
          'Falha ao criar lote';
      throw Exception(errorMessage);
    }
  }

  Future<LoteReadApiModel> buscarPorId(String id) async {
    final response = await api.request(
      endpoint: LoteEndpointsEnum.buscarPorId,
      queryParameters: {'id': id},
    );

    if (response.success && response.data != null) {
      return LoteReadApiModel.fromJson(response.data);
    } else {
      throw Exception(response.message ?? 'Falha ao buscar lote');
    }
  }

  Future<List<LoteReadApiModel>> buscarTodos({String? colmeiaId}) async {
    final response = await api.request(
      endpoint: LoteEndpointsEnum.buscarTodos,
      queryParameters: colmeiaId != null ? {'colmeiaId': colmeiaId} : null,
    );

    if (response.success && response.data != null) {
      final List<dynamic> dataList = response.data;
      return dataList.map((e) => LoteReadApiModel.fromJson(e)).toList();
    } else {
      throw Exception(response.message ?? 'Falha ao listar lotes');
    }
  }
}
