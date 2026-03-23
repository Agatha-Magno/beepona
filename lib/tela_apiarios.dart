import 'package:flutter/material.dart';
import 'widgets/apiario.dart';
import 'tela_cadastro_apiario.dart';
import 'tela_cadastro_colmeia.dart';
import 'dart:math';

class TelaApiarios extends StatefulWidget {
  const TelaApiarios({super.key});

  @override
  State<TelaApiarios> createState() => _TelaApiariosState();
}

class _TelaApiariosState extends State<TelaApiarios> {
  final List<Map<String, dynamic>> apiarios = [];
  int apiarioCount = 0;
  final Random random = Random();

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Meus Apiários',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEC107),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Image.asset(
                            'assets/Search_Icon.png',
                            height: 24,
                          ),
                        ),
                        const Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Buscar apiário...',
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
            const SizedBox(height: 24),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaCadastroApiario(
                        onSalvar: (nome, latitude, longitude) {
                          setState(() {
                            apiarioCount++;
                            apiarios.add({
                              'number': apiarioCount,
                              'nome': nome,
                              'latitude': latitude,
                              'longitude': longitude,
                            });
                          });
                        },
                      ),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/Apiary_Icon.png',
                      height: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Cadastrar novo apiário',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Image.asset(
                      'assets/Plus_Icon.png',
                      height: 24,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
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
                onPressed: () async {
                  final colmeia = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaCadastroColmeia(
                        apiarios: apiarios,
                      ),
                    ),
                  );
                  if (colmeia != null && colmeia['apiarioNumber'] != null) {
                    setState(() {
                      final idx = apiarios.indexWhere(
                          (a) => a['number'] == colmeia['apiarioNumber']);
                      if (idx != -1) {
                        apiarios[idx]['colmeias'] =
                            (apiarios[idx]['colmeias'] ?? 0) + 1;
                        apiarios[idx]['colmeiasList'] =
                            (apiarios[idx]['colmeiasList'] ?? [])..add(colmeia);
                      }
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/Swarm_Icon.png',
                      height: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Cadastrar Nova Colmeia',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Image.asset(
                      'assets/Plus_Icon.png',
                      height: 24,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: apiarios.length,
                itemBuilder: (context, index) {
                  final apiario = apiarios[index];
                  return Apiario(
                    number: apiario['number'],
                    nome: apiario['nome'] ?? '',
                    latitude: apiario['latitude'],
                    longitude: apiario['longitude'],
                    colmeias: apiario['colmeias'] ?? 0,
                    onDelete: () {
                      setState(() {
                        apiarios.removeAt(index);
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
