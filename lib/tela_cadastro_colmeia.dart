import 'package:flutter/material.dart';

class TelaCadastroColmeia extends StatefulWidget {
  final List<Map<String, dynamic>> apiarios;
  final void Function(Map<String, dynamic> colmeia)? onSalvar;

  const TelaCadastroColmeia({super.key, required this.apiarios, this.onSalvar});

  @override
  State<TelaCadastroColmeia> createState() => _TelaCadastroColmeiaState();
}

class _TelaCadastroColmeiaState extends State<TelaCadastroColmeia> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController dataController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  String produtoSelecionado = 'Mel';
  int? apiarioSelecionado;

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
                  'Informações da Colmeia',
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
                    hintText: 'Digite o nome da colmeia',
                  ),
                ),
                const SizedBox(height: 16),
                _buildLabel('Data'),
                TextField(
                  controller: dataController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Color(0xFFFFE49A),
                    hintText: 'Digite a data',
                  ),
                ),
                const SizedBox(height: 16),
                _buildLabel('Produto'),
                DropdownButtonFormField<String>(
                  value: produtoSelecionado,
                  items: ['Mel', 'Própolis', 'Outro']
                      .map((prod) => DropdownMenuItem(
                            value: prod,
                            child: Text(prod),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      produtoSelecionado = value!;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Color(0xFFFFE49A),
                  ),
                ),
                const SizedBox(height: 16),
                _buildLabel('Peso'),
                TextField(
                  controller: pesoController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Color(0xFFFFE49A),
                    hintText: 'Digite o peso',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                _buildLabel('Apiário'),
                DropdownButtonFormField<int>(
                  value: apiarioSelecionado,
                  items: widget.apiarios
                      .map((apiario) => DropdownMenuItem<int>(
                            value: apiario['number'] as int,
                            child: Text(apiario['nome'] ??
                                'Apiario #${apiario['number']}'),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      apiarioSelecionado = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Color(0xFFFFE49A),
                  ),
                ),
                const SizedBox(height: 80),
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
                  onPressed: () {
                    if (widget.onSalvar != null && apiarioSelecionado != null) {
                      widget.onSalvar!(
                        {
                          'nome': nomeController.text,
                          'data': dataController.text,
                          'produto': produtoSelecionado,
                          'peso': double.tryParse(pesoController.text) ?? 0.0,
                          'apiarioNumber': apiarioSelecionado,
                        },
                      );
                      Navigator.pop(context);
                    }
                  },
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
