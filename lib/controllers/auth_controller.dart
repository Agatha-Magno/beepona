import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nectracker/models/api/entities/usuario/usuario_auth.dart';
import 'package:nectracker/models/api/entities/usuario/usuario_confirmar_email.dart';
import 'package:nectracker/models/api/entities/usuario/usuario_create.dart';
import 'package:nectracker/models/api/entities/usuario/usuario_info.dart';
import 'package:nectracker/models/api/entities/usuario/usuario_reset_senha.dart';
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

  static Future<void> logout() async {
    token.value = null;
    usuarioInfo.value = null;
    emailConfirmacao.value = null;

    await _storage.delete(key: _storageTokenKey);
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

  static Future<void> confirmarEmail(UsuarioConfirmarEmailModel usuario) async {
    await _authRepository.confirmarEmail(usuario);
  }

  static Future<void> solicitarResetSenha(String email) async {
    await _authRepository.solicitarResetSenha(email);
  }

  static Future<void> resetarSenha(
      UsuarioResetSenhaApiModel usuarioResetSenha) async {
    await _authRepository.resetarSenha(usuarioResetSenha);
  }
}
