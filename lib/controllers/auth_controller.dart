import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nectracker/models/api/entities/usuario/usuario_auth.dart';
import 'package:nectracker/models/api/entities/usuario/usuario_create.dart';
import 'package:nectracker/models/api/entities/usuario/usuario_info.dart';
import 'package:nectracker/repositories/auth_repository.dart';
import 'package:signals/signals.dart';

final token = signal<String?>(null);
final usuarioInfo = signal<UsuarioInfoApiModel?>(null);
final emailConfirmacao = signal<String?>(null);

const _storageTokenKey = 'user_token';

class AuthController {
  static const _storage = FlutterSecureStorage();
  static final AuthRepository _authRepository = AuthRepository();

  static Future<void> init() async {
    token.value = await _storage.read(key: _storageTokenKey);
  }

  static Future<void> login(UsuarioAuthApiModel usuario) async {
    final loginData = await _authRepository.login(usuario);

    token.value = loginData['token'] as String;
    usuarioInfo.value = loginData['usuario'] as UsuarioInfoApiModel;

    await _storage.write(key: _storageTokenKey, value: token.value!);
  }

  static Future<void> registrar(UsuarioCreateApiModel usuario) async {
    await _authRepository.registrar(usuario);

    emailConfirmacao.value = usuario.email;
  }

  static Future<void> reenviarConfirmacao() async {
    if (emailConfirmacao.value == null) {
      throw Exception('Falha ao reenviar confirmação.');
    }

    await _authRepository.reenviarConfirmacao(emailConfirmacao.value!);
  }
}
