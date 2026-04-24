import 'package:flutter/material.dart';
import 'package:nectracker/controllers/auth_controller.dart';
import 'package:nectracker/tela_inicial.dart';

class TelaPerfil extends StatelessWidget {
  const TelaPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    final info = usuarioInfo.value;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: AppBar(
          backgroundColor: const Color(0xFFFEC107),
          elevation: 0,
          titleSpacing: 0,
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 16.0),
                child: Image.asset(
                  'assets/logo.png',
                  height: 40,
                ),
              ),
              const Text(
                'Perfil',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Meu Perfil',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            _buildProfileItem(
              label: 'Nome',
              value: info?.nome ?? 'Usuário',
              icon: 'assets/Profile_Icon.png',
            ),
            const SizedBox(height: 16),
            _buildProfileItem(
              label: 'E-mail',
              value: info?.email ?? 'email@email.com',
              icon: Icons.email,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9700),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text('Trocar Senha'),
                      content: const Text(
                          'Deseja receber um e-mail com instruções para redefinir sua senha?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          child: const Text('Cancelar',
                              style: TextStyle(color: Colors.black54)),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.of(dialogContext).pop();

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (loadingContext) => const Center(
                                child: CircularProgressIndicator(
                                    color: Color(0xFFFEC107)),
                              ),
                            );

                            try {
                              await AuthController.solicitarResetSenha(
                                  info?.email ?? '');
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Um e-mail de redefinição de senha foi enviado para sua conta!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              await AuthController.logout();
                              if (!context.mounted) return;
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const TelaInicial()),
                                (route) => false,
                              );
                            } catch (e) {
                              if (!context.mounted) return;
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e
                                      .toString()
                                      .replaceAll('Exception: ', '')),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          child: const Text('Sim, enviar e-mail',
                              style: TextStyle(color: Color(0xFF4CB050))),
                        ),
                      ],
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock, size: 24),
                    const SizedBox(width: 8),
                    const Text(
                      'Trocar senha',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text('Sair da Conta'),
                      content: const Text(
                          'Tem certeza que deseja sair do aplicativo?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          child: const Text('Cancelar',
                              style: TextStyle(color: Colors.black54)),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.of(dialogContext).pop();

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (loadingContext) => const Center(
                                child: CircularProgressIndicator(
                                    color: Color(0xFFFEC107)),
                              ),
                            );

                            await AuthController.logout();
                            if (!context.mounted) return;
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const TelaInicial()),
                              (route) => false,
                            );
                          },
                          child: const Text('Sim, sair',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout, size: 24),
                    const SizedBox(width: 8),
                    const Text(
                      'Sair (Logout)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(
      {required String label, required String value, required dynamic icon}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE49A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildIcon(icon),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(dynamic icon) {
    if (icon is IconData) {
      return Icon(icon, size: 28);
    } else if (icon is String) {
      return Image.asset(
        icon,
        height: 28,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.person),
      );
    }
    return const Icon(Icons.info);
  }
}
