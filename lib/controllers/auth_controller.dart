import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nectracker/models/api/entities/usuario/usuario_auth.dart';
import 'package:nectracker/models/api/entities/usuario/usuario_confirmar_email.dart';
import 'package:nectracker/models/api/entities/usuario/usuario_create.dart';
import 'package:nectracker/models/api/entities/token/auth_tokens.dart';
import 'package:nectracker/models/api/entities/usuario/usuario_info.dart';
import 'package:nectracker/models/api/entities/usuario/usuario_reset_senha.dart';
import 'package:nectracker/repositories/auth_repository.dart';
import 'package:signals/signals.dart';

final tokens = signal<AuthTokensModel?>(null);
final usuarioInfo = signal<UsuarioInfoApiModel?>(null);
final emailConfirmacao = signal<String?>(null);
const _storageRefreshKey = 'user_refresh_token';

class AuthController {
  static const _storage = FlutterSecureStorage();
  static final AuthRepository _authRepository = AuthRepository();

  static Future<void> init() async {
    tokens.value = AuthTokensModel(
        refreshToken: await _storage.read(key: _storageRefreshKey));

    if (tokens.value != null && tokens.value!.refreshToken != null) {
      try {
        await refreshToken();
        await buscarInfoUsuario();
      } catch (e) {
        await logout();
      }
    }
  }

  static Future<void> login(UsuarioAuthApiModel usuario) async {
    final loginData = await _authRepository.login(usuario);

    tokens.value = AuthTokensModel(
      token: loginData['token'] as String,
      refreshToken: loginData['refreshToken'] as String,
    );
    usuarioInfo.value = loginData['usuario'] as UsuarioInfoApiModel;

    await _storage.write(
        key: _storageRefreshKey, value: tokens.value?.refreshToken);
  }

  static Future<void> refreshToken() async {
    final loginData = await _authRepository.refreshToken();

    tokens.value = AuthTokensModel.fromJson(loginData);

    await _storage.write(
        key: _storageRefreshKey, value: tokens.value?.refreshToken);
  }

  static Future<void> logout() async {
    tokens.value = null;
    usuarioInfo.value = null;
    emailConfirmacao.value = null;

    await _storage.delete(key: _storageRefreshKey);
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

  static Future<void> buscarInfoUsuario() async {
    await _authRepository.buscarInfoUsuario();
  }
}
