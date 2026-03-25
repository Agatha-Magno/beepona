import 'package:nectracker/enums/api/endpoints/usuario_endpoints_enum.dart';
import 'package:nectracker/models/api/entities/usuario/usuario_auth.dart';
import 'package:nectracker/models/api/entities/usuario/usuario_info.dart';
import 'package:nectracker/repositories/base_repository.dart';

class AuthRepository extends BaseRepository {
  AuthRepository({super.api});

  Future<Map<String, dynamic>> login(UsuarioAuthApiModel usuario) async {
    final response = await api.request(
      endpoint: UsuarioEndpointsEnum.login,
      data: usuario.toJson(),
      requiresAuth: false,
    );

    if (response.success && response.data != null) {
      return {
        'token': response.data['token'],
        'usuario': UsuarioInfoApiModel.fromJson(response.data['usuario']),
      };
    } else {
      throw Exception(response.message ?? 'Falha ao fazer login');
    }
  }
}
