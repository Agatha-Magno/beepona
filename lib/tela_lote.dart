import 'package:flutter/material.dart';
import 'package:nectracker/models/api/entities/colmeia/colmeia_read_update.dart';
import 'package:nectracker/models/api/entities/lote/lote_read.dart';
import 'package:nectracker/repositories/lote_repository.dart';
import 'widgets/lote.dart';
import 'tela_cadastro_lote.dart';
import 'tela_perfil.dart';

class TelaLote extends StatefulWidget {
  final ColmeiaReadUpdateApiModel colmeia;

  const TelaLote({super.key, required this.colmeia});

  @override
  State<TelaLote> createState() => _TelaLoteState();
}

class _TelaLoteState extends State<TelaLote> {
  final LoteRepository _loteRepo = LoteRepository();
  List<LoteReadApiModel> lotes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarLotes();
  }

  Future<void> _carregarLotes() async {
    setState(() {
      isLoading = true;
    });
    try {
      final data = await _loteRepo.buscarTodos(colmeiaId: widget.colmeia.id);
      setState(() {
        lotes = data;
      });
    } catch (e) {
      if (mounted) {
        String mensagemErro = e.toString();
        if (mensagemErro.startsWith('Exception: ')) {
          mensagemErro = mensagemErro.substring(11);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar lotes: $mensagemErro')),
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
                  'assets/Swarm_Icon.png',
                  height: 24,
                ),
                label: const Text(
                  'Colmeias',
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
              'Lotes - ${widget.colmeia.nome}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
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
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaCadastroLote(
                        colmeiaId: widget.colmeia.id,
                        colmeiaNome: widget.colmeia.nome,
                      ),
                    ),
                  );
                  if (result == true) {
                    _carregarLotes();
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.inventory_2_outlined, size: 24),
                    const SizedBox(width: 8),
                    const Text(
                      'Cadastrar Lote',
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
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFF9700),
                      ),
                    )
                  : lotes.isEmpty
                      ? const Center(
                          child: Text(
                            'Nenhum lote encontrado para esta colmeia.',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: lotes.length,
                          itemBuilder: (context, index) {
                            final lote = lotes[index];
                            return Lote(
                              id: lote.id,
                              qtdColeta: lote.qtdColeta,
                              armazenamentoColeta: lote.armazenamentoColeta,
                              coletor: lote.coletor,
                              dataColeta: lote.dataColeta,
                              localProcessamento: lote.localProcessamento,
                              tipoProcessamento: lote.tipoProcessamento,
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
