import 'package:nectracker/enums/api/endpoints/usuario_endpoints_enum.dart';
import 'package:nectracker/models/api/entities/usuario/usuario_auth.dart';
import 'package:nectracker/models/api/entities/usuario/usuario_create.dart';
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

  Future<void> registrar(UsuarioCreateApiModel usuario) async {
    final response = await api.request(
      endpoint: UsuarioEndpointsEnum.registrar,
      data: usuario.toJson(),
      requiresAuth: false,
    );

    if (response.success) {
      return;
    } else {
      if (response.errors != null) {
        final errors = response.errors as List<dynamic>;
        if (errors.any((error) => error["code"] == "DuplicateEmail")) {
          throw Exception(errors.firstWhere(
              (error) => error["code"] == "DuplicateEmail")["description"]);
        }

        throw Exception(errors.first["description"]);
      }

      throw Exception(response.message ?? 'Falha ao registrar usuário');
    }
  }

  Future<void> reenviarConfirmacao(String email) async {
    final response = await api.request(
      endpoint: UsuarioEndpointsEnum.reenviarAtivarEmail,
      data: {'email': email},
      requiresAuth: false,
    );

    if (response.success) {
      return;
    } else {
      throw Exception(response.message ?? 'Falha ao reenviar confirmação.');
    }
  }
}
