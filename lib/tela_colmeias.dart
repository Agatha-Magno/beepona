import 'package:flutter/material.dart';
import 'package:nectracker/models/api/entities/apiario/apiario_read.dart';
import 'package:nectracker/models/api/entities/colmeia/colmeia_read_update.dart';
import 'package:nectracker/repositories/colmeia_repository.dart';
import 'package:nectracker/enums/produto_enum.dart';
import 'widgets/colmeia.dart';
import 'tela_cadastro_colmeia.dart';
import 'tela_perfil.dart';

class TelaColmeias extends StatefulWidget {
  final ApiarioReadApiModel apiario;

  const TelaColmeias({super.key, required this.apiario});

  @override
  State<TelaColmeias> createState() => _TelaColmeiasState();
}

class _TelaColmeiasState extends State<TelaColmeias> {
  final ColmeiaRepository _colmeiaRepo = ColmeiaRepository();
  List<ColmeiaReadUpdateApiModel> colmeias = [];
  bool isLoading = true;
  bool mostrarAtivas = true;

  @override
  void initState() {
    super.initState();
    _carregarColmeias();
  }

  Future<void> _carregarColmeias() async {
    setState(() {
      isLoading = true;
    });
    try {
      final data = await _colmeiaRepo.buscarTodos(apiarioId: widget.apiario.id);
      setState(() {
        colmeias = data;
      });
    } catch (e) {
      if (mounted) {
        String mensagemErro = e.toString();
        if (mensagemErro.startsWith('Exception: ')) {
          mensagemErro = mensagemErro.substring(11);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar colmeias: $mensagemErro')),
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
                onPressed: () {
                   Navigator.pop(context);
                },
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
            Text(
              'Colmeias - ${widget.apiario.nome}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
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
                        apiarioNome: widget.apiario.nome,
                        apiarioId: widget.apiario.id,
                      ),
                    ),
                  );
                  if (colmeia != null) {
                    _carregarColmeias();
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
            Row(
              children: [
                _buildCategoryButton(
                  label: 'Ativas',
                  isSelected: mostrarAtivas,
                  onTap: () => setState(() => mostrarAtivas = true),
                ),
                const SizedBox(width: 16),
                _buildCategoryButton(
                  label: 'Inativas',
                  isSelected: !mostrarAtivas,
                  onTap: () => setState(() => mostrarAtivas = false),
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
                  : colmeias.where((c) => c.ativa == mostrarAtivas).isEmpty
                      ? Center(
                          child: Text(
                            mostrarAtivas
                                ? 'Nenhuma colmeia ativa neste apiário.'
                                : 'Nenhuma colmeia inativa neste apiário.',
                            style: const TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: colmeias
                              .where((c) => c.ativa == mostrarAtivas)
                              .length,
                          itemBuilder: (context, index) {
                            final filteredColmeias = colmeias
                                .where((c) => c.ativa == mostrarAtivas)
                                .toList();
                            final colmeia = filteredColmeias[index];
                            return Colmeia(
                              id: colmeia.id,
                              nome: colmeia.nome,
                              peso: colmeia.peso,
                              produto: ProdutoEnum.toLabel(colmeia.produto),
                              ativa: colmeia.ativa,
                              onEdit: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TelaCadastroColmeia(
                                      apiarioNome: widget.apiario.nome,
                                      apiarioId: widget.apiario.id,
                                      colmeia: colmeia,
                                    ),
                                  ),
                                );
                                if (result != null) {
                                  _carregarColmeias();
                                }
                              },
                              onDelete: () =>
                                  _alterarStatusColmeia(colmeia, false),
                              onReactivar: () =>
                                  _alterarStatusColmeia(colmeia, true),
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

  Future<void> _alterarStatusColmeia(
      ColmeiaReadUpdateApiModel colmeia, bool status) async {
    try {
      final updateModel = ColmeiaReadUpdateApiModel(
        id: colmeia.id,
        nome: colmeia.nome,
        produto: colmeia.produto,
        peso: colmeia.peso,
        ativa: status,
      );
      await _colmeiaRepo.atualizar(updateModel);
      _carregarColmeias();
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
