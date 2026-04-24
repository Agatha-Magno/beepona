import 'package:flutter/material.dart';
import 'package:nectracker/enums/produto_enum.dart';
import 'package:nectracker/models/api/entities/colmeia/colmeia_read_update.dart';
import 'package:nectracker/models/api/entities/colmeia/colmeia_create.dart';
import 'package:nectracker/repositories/colmeia_repository.dart';

class TelaCadastroColmeia extends StatefulWidget {
  final String apiarioNome;
  final String? apiarioId;
  final ColmeiaReadUpdateApiModel? colmeia;
  final void Function(Map<String, dynamic> colmeia)? onSalvar;

  const TelaCadastroColmeia({
    super.key,
    required this.apiarioNome,
    this.apiarioId,
    this.onSalvar,
    this.colmeia,
  });

  @override
  State<TelaCadastroColmeia> createState() => _TelaCadastroColmeiaState();
}

class _TelaCadastroColmeiaState extends State<TelaCadastroColmeia> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  String produtoSelecionado = 'Mel';
  String? apiarioSelecionado;
  final ColmeiaRepository _colmeiaRepo = ColmeiaRepository();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    apiarioSelecionado = widget.apiarioId;

    if (widget.colmeia != null) {
      nomeController.text = widget.colmeia!.nome;
      pesoController.text = widget.colmeia!.peso.toString();
      produtoSelecionado = ProdutoEnum.toLabel(widget.colmeia!.produto);
      // O apiarioId já deve estar correto se passado pelo widget.apiarioId
    }
  }

  Future<void> _salvarColmeia() async {
    if (apiarioSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione um apiário.')),
      );
      return;
    }

    final nome = nomeController.text.trim();
    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira o nome da colmeia.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final bool isUpdate = widget.colmeia != null;

      if (isUpdate) {
        final modeloUpdate = ColmeiaReadUpdateApiModel(
          id: widget.colmeia!.id,
          nome: nome,
          produto: ProdutoEnum.toEnum(produtoSelecionado),
          peso: double.tryParse(pesoController.text) ?? 0.0,
          ativa: widget.colmeia!.ativa,
        );
        await _colmeiaRepo.atualizar(modeloUpdate);
      } else {
        final modelo = ColmeiaCreateApiModel(
          apiarioId: apiarioSelecionado.toString(),
          nome: nome,
          produto: ProdutoEnum.toEnum(produtoSelecionado),
          peso: double.tryParse(pesoController.text) ?? 0.0,
        );
        await _colmeiaRepo.criar(modelo);
      }

      final result = {
        'nome': nome,
        'produto': produtoSelecionado,
        'peso': double.tryParse(pesoController.text) ?? 0.0,
        'apiarioNumber': apiarioSelecionado,
      };

      if (widget.onSalvar != null) {
        widget.onSalvar!(result);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(isUpdate
                  ? 'Colmeia atualizada com sucesso!'
                  : 'Colmeia cadastrada com sucesso!')),
        );
        Navigator.pop(context, result);
      }
    } catch (e) {
      if (mounted) {
        String mensagemErro = e.toString();
        if (mensagemErro.startsWith('Exception: ')) {
          mensagemErro = mensagemErro.substring(11);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $mensagemErro')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
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
                Text(
                  widget.colmeia != null
                      ? 'Editar Informações'
                      : 'Informações da Colmeia',
                  style: const TextStyle(
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
                _buildLabel('Produto'),
                DropdownButtonFormField<String>(
                  initialValue: produtoSelecionado,
                  items: ['Mel', 'Própolis', 'Outros']
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
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    widget.colmeia != null
                        ? 'Esta colmeia pertence ao apiário: ${widget.apiarioNome}'
                        : 'Esta colmeia será cadastrada no apiário: ${widget.apiarioNome}',
                    style: const TextStyle(fontSize: 16),
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
              color: Colors.white.withValues(alpha: 0.9),
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
                  onPressed: _isLoading ? null : _salvarColmeia,
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Salvar',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
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
