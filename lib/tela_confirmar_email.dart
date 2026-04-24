import 'package:flutter/material.dart';
import 'package:nectracker/controllers/auth_controller.dart';
import 'package:nectracker/models/api/entities/usuario/usuario_confirmar_email.dart';
import 'package:nectracker/tela_login.dart';

class TelaConfirmarEmail extends StatefulWidget {
  final String? token;
  final String? userId;

  const TelaConfirmarEmail({super.key, this.token, this.userId});

  @override
  State<TelaConfirmarEmail> createState() => _TelaConfirmarEmailState();
}

class _TelaConfirmarEmailState extends State<TelaConfirmarEmail> {
  bool _isLoading = true;
  String _message = 'Confirmando e-mail...';
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _confirmEmail();
  }

  Future<void> _confirmEmail() async {
    if (widget.token == null || widget.userId == null) {
      setState(() {
        _isLoading = false;
        _message = 'Link de confirmação inválido.';
        _isSuccess = false;
      });
      return;
    }

    try {
      final model = UsuarioConfirmarEmailModel(
        userId: widget.userId!,
        token: widget.token!,
      );
      await AuthController.confirmarEmail(model);
      
      setState(() {
        _isLoading = false;
        _message = 'E-mail confirmado com sucesso!';
        _isSuccess = true;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _message = e.toString().replaceAll('Exception: ', '');
        _isSuccess = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEC107),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFE49A),
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text('Confirmação de E-mail', style: TextStyle(color: Colors.black87)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading)
                const CircularProgressIndicator(color: Colors.black87)
              else
                Icon(
                  _isSuccess ? Icons.check_circle_outline : Icons.error_outline,
                  size: 100,
                  color: _isSuccess ? Colors.green : Colors.red,
                ),
              const SizedBox(height: 32),
              Text(
                _message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 48),
              if (!_isLoading)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const TelaLogin()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Ir para o Login',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
