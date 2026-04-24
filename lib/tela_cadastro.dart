import 'package:flutter/material.dart';
import 'package:nectracker/controllers/auth_controller.dart';
import 'package:nectracker/models/api/entities/usuario/usuario_create.dart';
import 'package:nectracker/tela_solicita_email.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _formKey = GlobalKey<FormState>();
  String nome = '';
  String email = '';
  String senha = '';
  String confirmeSenha = '';
  bool _isLoading = false;

  Future<void> _fazerCadastro() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final usuario = UsuarioCreateApiModel(
          nome: nome,
          email: email,
          senha: senha,
          confirmarSenha: confirmeSenha);

      await AuthController.registrar(usuario);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TelaSolicitaEmail()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ...existing code...
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEC107),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFE49A),
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                height: 80,
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildLabel('Nome'),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Digite seu nome',
                        filled: true,
                        fillColor: Color(0xFFFFE49A),
                      ),
                      onChanged: (value) => nome = value,
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('E-mail'),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Digite seu e-mail',
                        filled: true,
                        fillColor: Color(0xFFFFE49A),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) => email = value,
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('Senha'),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Digite sua senha',
                        filled: true,
                        fillColor: Color(0xFFFFE49A),
                      ),
                      obscureText: true,
                      onChanged: (value) => senha = value,
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('Confirme sua senha'),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Confirme sua senha',
                        filled: true,
                        fillColor: Color(0xFFFFE49A),
                      ),
                      obscureText: true,
                      onChanged: (value) => confirmeSenha = value,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF9700),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _isLoading ? null : _fazerCadastro,
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text('Cadastrar',
                                style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
