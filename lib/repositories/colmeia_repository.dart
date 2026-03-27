import 'package:nectracker/enums/api/endpoints/colmeia_endpoints_enum.dart';
import 'package:nectracker/models/api/entities/colmeia/colmeia_create.dart';
import 'package:nectracker/models/api/entities/colmeia/colmeia_read_update.dart';
import 'package:nectracker/repositories/base_repository.dart';

class ColmeiaRepository extends BaseRepository {
  ColmeiaRepository({super.api});

  Future<void> criar(ColmeiaCreateApiModel colmeia) async {
    final response = await api.request(
      endpoint: ColmeiaEndpointsEnum.criar,
      data: colmeia.toJson(),
    );

    if (!response.success) {
      throw Exception(response.message ?? 'Falha ao criar colmeia');
    }
  }

  Future<void> atualizar(ColmeiaReadUpdateApiModel colmeia) async {
    final response = await api.request(
      endpoint: ColmeiaEndpointsEnum.atualizar,
      data: colmeia.toJson(),
    );

    if (!response.success) {
      throw Exception(response.message ?? 'Falha ao atualizar colmeia');
    }
  }

  Future<ColmeiaReadUpdateApiModel> buscarPorId(String id) async {
    final response = await api.request(
      endpoint: ColmeiaEndpointsEnum.buscarPorId,
      queryParameters: {'id': id},
    );

    if (response.success && response.data != null) {
      return ColmeiaReadUpdateApiModel.fromJson(response.data);
    } else {
      throw Exception(response.message ?? 'Falha ao buscar colmeia');
    }
  }

  Future<List<ColmeiaReadUpdateApiModel>> buscarTodos({String? apiarioId}) async {
    final response = await api.request(
      endpoint: ColmeiaEndpointsEnum.buscarTodos,
      queryParameters: apiarioId != null ? {'apiarioId': apiarioId} : null,
    );

    if (response.success && response.data != null) {
      final List<dynamic> dataList = response.data;
      return dataList.map((e) => ColmeiaReadUpdateApiModel.fromJson(e)).toList();
    } else {
      throw Exception(response.message ?? 'Falha ao listar colmeias');
    }
  }
}
