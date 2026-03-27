import 'package:nectracker/enums/api/endpoints/apiario_endpoints_enum.dart';
import 'package:nectracker/models/api/entities/apiario/apiario_create.dart';
import 'package:nectracker/models/api/entities/apiario/apiario_read.dart';
import 'package:nectracker/models/api/entities/apiario/apiario_update.dart';
import 'package:nectracker/repositories/base_repository.dart';

class ApiarioRepository extends BaseRepository {
  ApiarioRepository({super.api});

  Future<void> criar(ApiarioCreateApiModel apiario) async {
    final response = await api.request(
      endpoint: ApiarioEndpointsEnum.criar,
      data: apiario.toJson(),
    );

    if (!response.success) {
      throw Exception(response.message ?? 'Falha ao criar apiário');
    }
  }

  Future<void> atualizar(ApiarioUpdateApiModel apiario) async {
    final response = await api.request(
      endpoint: ApiarioEndpointsEnum.atualizar,
      data: apiario.toJson(),
    );

    if (!response.success) {
      throw Exception(response.message ?? 'Falha ao atualizar apiário');
    }
  }

  Future<ApiarioReadApiModel> buscarPorId(String id) async {
    final response = await api.request(
      endpoint: ApiarioEndpointsEnum.buscarPorId,
      queryParameters: {'id': id},
    );

    if (response.success && response.data != null) {
      return ApiarioReadApiModel.fromJson(response.data);
    } else {
      throw Exception(response.message ?? 'Falha ao buscar apiário');
    }
  }

  Future<List<ApiarioReadApiModel>> buscarTodos() async {
    final response = await api.request(
      endpoint: ApiarioEndpointsEnum.buscarTodos,
    );

    if (response.success && response.data != null) {
      final List<dynamic> dataList = response.data;
      return dataList.map((e) => ApiarioReadApiModel.fromJson(e)).toList();
    } else {
      throw Exception(response.message ?? 'Falha ao listar apiários');
    }
  }
}
