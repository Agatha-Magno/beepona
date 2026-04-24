import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nectracker/models/api/entities/lote/lote_create.dart';
import 'package:nectracker/repositories/lote_repository.dart';

class TelaCadastroLote extends StatefulWidget {
  final String colmeiaId;
  final String colmeiaNome;

  const TelaCadastroLote({
    super.key,
    required this.colmeiaId,
    required this.colmeiaNome,
  });

  @override
  State<TelaCadastroLote> createState() => _TelaCadastroLoteState();
}

class _TelaCadastroLoteState extends State<TelaCadastroLote> {
  final TextEditingController qtdController = TextEditingController();
  final TextEditingController coletorController = TextEditingController();
  final TextEditingController dataController = TextEditingController();
  final TextEditingController localController = TextEditingController();
  final TextEditingController tipoProcController = TextEditingController();

  final LoteRepository _loteRepo = LoteRepository();
  bool _isLoading = false;
  DateTime _selectedDate = DateTime.now();

  String _unidade = 'Kg';
  String? _selectedArmazenamento;
  final List<String> _opcoesArmazenamento = [
    'Lata - 18L/25kg',
    'Balde - 20L/28kg',
    'Tambor 300L'
  ];

  @override
  void initState() {
    super.initState();
    dataController.text = DateFormat('dd/MM/yyyy').format(_selectedDate);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFF9700),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        dataController.text = DateFormat('dd/MM/yyyy').format(_selectedDate);
      });
    }
  }

  Future<void> _salvarLote() async {
    final qtdText = qtdController.text.trim();
    if (qtdText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, informe a quantidade.')),
      );
      return;
    }

    final qtd = double.tryParse(qtdText.replaceAll(',', '.')) ?? 0.0;
    if (qtd <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, informe uma quantidade válida.')),
      );
      return;
    }

    if (_selectedArmazenamento == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, selecione o tipo de armazenamento.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final modelo = LoteCreateApiModel(
        idColmeia: widget.colmeiaId,
        qtdColeta: qtd,
        armazenamentoColeta: _selectedArmazenamento,
        coletor: coletorController.text.trim().isNotEmpty
            ? coletorController.text.trim()
            : null,
        dataColeta: _selectedDate.toUtc(),
        localProcessamento: localController.text.trim().isNotEmpty
            ? localController.text.trim()
            : null,
        tipoProcessamento: tipoProcController.text.trim().isNotEmpty
            ? tipoProcController.text.trim()
            : null,
      );

      await _loteRepo.criar(modelo);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lote cadastrado com sucesso!')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        String mensagemErro = e.toString();
        if (mensagemErro.startsWith('Exception: ')) {
          mensagemErro = mensagemErro.substring(11);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar lote: $mensagemErro')),
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
              Expanded(
                child: Text(
                  'Lotes - ${widget.colmeiaNome}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
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
                  'Cadastrar Lote - ${widget.colmeiaNome}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _buildLabel('Quantidade de Coleta'),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: qtdController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Color(0xFFFFE49A),
                          hintText: 'Quantidade',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE49A),
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _unidade,
                            items: ['Kg', 'L'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _unidade = val);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildLabel('Tipo de Armazenamento'),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE49A),
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedArmazenamento,
                      hint: const Text('Selecione o armazenamento'),
                      items: _opcoesArmazenamento.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() => _selectedArmazenamento = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildLabel('Coletor'),
                TextField(
                  controller: coletorController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Color(0xFFFFE49A),
                    hintText: 'Nome do coletor',
                  ),
                ),
                const SizedBox(height: 16),
                _buildLabel('Data da Coleta'),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: dataController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Color(0xFFFFE49A),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildLabel('Local do Processamento'),
                TextField(
                  controller: localController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Color(0xFFFFE49A),
                    hintText: 'Local onde foi processado',
                  ),
                ),
                const SizedBox(height: 16),
                _buildLabel('Tipo de Processamento'),
                TextField(
                  controller: tipoProcController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Color(0xFFFFE49A),
                    hintText: 'Ex: Centrífuga, Manual...',
                  ),
                ),
                const SizedBox(height: 100),
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
                  onPressed: _isLoading ? null : _salvarLote,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Salvar Lote',
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
