import 'package:flutter/material.dart';
import 'package:nectracker/models/api/entities/apiario/apiario_read.dart';
import 'package:nectracker/repositories/apiario_repository.dart';
import 'package:nectracker/models/api/entities/apiario/apiario_update.dart';
import 'package:nectracker/repositories/colmeia_repository.dart';
import 'widgets/apiario.dart';
import 'tela_cadastro_apiario.dart';

import 'tela_perfil.dart';

import 'tela_colmeias.dart';

class TelaApiarios extends StatefulWidget {
  const TelaApiarios({super.key});

  @override
  State<TelaApiarios> createState() => _TelaApiariosState();
}

class _TelaApiariosState extends State<TelaApiarios> {
  final ApiarioRepository _apiarioRepo = ApiarioRepository();
  final ColmeiaRepository _colmeiaRepo = ColmeiaRepository();
  List<ApiarioReadApiModel> apiarios = [];
  Map<String, int> _activeHivesCount = {};
  bool isLoading = true;
  bool mostrarAtivos = true;

  @override
  void initState() {
    super.initState();
    _carregarApiarios();
  }

  Future<void> _carregarApiarios() async {
    setState(() {
      isLoading = true;
    });
    try {
      final data = await _apiarioRepo.buscarTodos();
      
      final Map<String, int> counts = {};
      await Future.wait(data.map((apiario) async {
        try {
          final hvs = await _colmeiaRepo.buscarTodos(apiarioId: apiario.id);
          counts[apiario.id] = hvs.where((h) => h.ativa).length;
        } catch (e) {
          counts[apiario.id] = 0;
        }
      }));

      setState(() {
        apiarios = data;
        _activeHivesCount = counts;
      });
    } catch (e) {
      if (mounted) {
        String mensagemErro = e.toString();
        if (mensagemErro.startsWith('Exception: ')) {
          mensagemErro =
              mensagemErro.substring(11); // Remove prefixo "Exception: "
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar apiários: $mensagemErro')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TelaPerfil(),
                    ),
                  );
                },
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
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TelaCadastroApiario(),
                    ),
                  );
                  if (result == true) {
                    _carregarApiarios();
                  }
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
            Row(
              children: [
                _buildCategoryButton(
                  label: 'Ativos',
                  isSelected: mostrarAtivos,
                  onTap: () => setState(() => mostrarAtivos = true),
                ),
                const SizedBox(width: 16),
                _buildCategoryButton(
                  label: 'Inativos',
                  isSelected: !mostrarAtivos,
                  onTap: () => setState(() => mostrarAtivos = false),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, size: 18, color: Colors.grey[700]),
                const SizedBox(width: 8),
                Text(
                  'Clique nos apiários para ver e cadastrar colmeias',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFF9700),
                      ),
                    )
                  : apiarios.where((a) => a.ativo == mostrarAtivos).isEmpty
                      ? Center(
                          child: Text(
                            mostrarAtivos
                                ? 'Nenhum apiário ativo encontrado.'
                                : 'Nenhum apiário inativo encontrado.',
                            style: const TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: apiarios
                              .where((a) => a.ativo == mostrarAtivos)
                              .length,
                          itemBuilder: (context, index) {
                            final filteredApiarios = apiarios
                                .where((a) => a.ativo == mostrarAtivos)
                                .toList();
                            final apiario = filteredApiarios[index];
                            return Apiario(
                              id: apiario.id,
                              nome: apiario.nome,
                              latitude: apiario.latitude ?? 0.0,
                              longitude: apiario.longitude ?? 0.0,
                              colmeias: _activeHivesCount[apiario.id] ?? 0,
                              ativo: apiario.ativo,
                              onTap: () async {
                                if (!apiario.ativo) return;
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TelaColmeias(apiario: apiario),
                                  ),
                                );
                                _carregarApiarios();
                              },
                              onEdit: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TelaCadastroApiario(apiario: apiario),
                                  ),
                                );
                                if (result == true) {
                                  _carregarApiarios();
                                }
                              },
                              onDelete: () =>
                                  _alterarStatusApiario(apiario, false),
                              onReactivar: () =>
                                  _alterarStatusApiario(apiario, true),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.black : Colors.grey,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: 40,
              color: const Color(0xFFFF9700),
            ),
        ],
      ),
    );
  }

  Future<void> _alterarStatusApiario(
      ApiarioReadApiModel apiario, bool status) async {
    try {
      final updateModel = ApiarioUpdateApiModel(
        id: apiario.id,
        nome: apiario.nome,
        latitude: apiario.latitude,
        longitude: apiario.longitude,
        ativo: status,
      );
      await _apiarioRepo.atualizar(updateModel);
      _carregarApiarios();
    } catch (e) {
      if (mounted) {
        String mensagemErro = e.toString();
        if (mensagemErro.startsWith('Exception: ')) {
          mensagemErro = mensagemErro.substring(11);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao alterar status: $mensagemErro')),
        );
      }
    }
  }
}
