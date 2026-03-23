import 'package:flutter/material.dart';
import 'widgets/colmeia.dart';
import 'dart:math';

class TelaCadastroApiario extends StatefulWidget {
  final void Function(String nome, double latitude, double longitude)? onSalvar;

  const TelaCadastroApiario({super.key, this.onSalvar});

  @override
  State<TelaCadastroApiario> createState() => _TelaCadastroApiarioState();
}

class _TelaCadastroApiarioState extends State<TelaCadastroApiario> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  List<Map<String, dynamic>> colmeias = [];

  void _gerarLocalizacaoAleatoria() {
    final random = Random();
    latitudeController.text = (-23.0 + random.nextDouble()).toStringAsFixed(5);
    longitudeController.text = (-46.0 + random.nextDouble()).toStringAsFixed(5);
  }

  void _salvarApiario() {
    if (widget.onSalvar != null) {
      final nome = nomeController.text;
      final latitude = double.tryParse(latitudeController.text) ?? 0.0;
      final longitude = double.tryParse(longitudeController.text) ?? 0.0;
      widget.onSalvar!(nome, latitude, longitude);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              TextButton.icon(
                onPressed: () {},
                icon: Image.asset(
                  'assets/Apiary_Icon.png',
                  height: 24,
                ),
                label: const Text(
                  'Apiários',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {},
                icon: Image.asset(
                  'assets/Profile_Icon.png',
                  height: 24,
                ),
                label: const Text(
                  'Perfil',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Informações do Apiário',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _buildLabel('Nome'),
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Color(0xFFFFE49A),
                    hintText: 'Digite o nome do apiário',
                  ),
                ),
                const SizedBox(height: 16),
                _buildLabel('Latitude'),
                TextField(
                  controller: latitudeController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Color(0xFFFFE49A),
                    hintText: 'Digite a latitude',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                _buildLabel('Longitude'),
                TextField(
                  controller: longitudeController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Color(0xFFFFE49A),
                    hintText: 'Digite a longitude',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF9700),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    onPressed: _gerarLocalizacaoAleatoria,
                    child: const Text(
                      'Obter a localização atual',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Colmeias',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 80),
                Column(
                  children: colmeias
                      .map((colmeia) => Colmeia(
                            nome: colmeia['nome'],
                            data: colmeia['data'],
                            peso: colmeia['peso'],
                            produto: colmeia['produto'],
                          ))
                      .toList(),
                )
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.white.withOpacity(0.9),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: SizedBox(
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
                  onPressed: _salvarApiario,
                  child: const Text(
                    'Salvar',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
