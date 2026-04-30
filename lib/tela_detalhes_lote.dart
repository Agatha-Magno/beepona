import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nectracker/models/api/entities/lote/lote_read.dart';
import 'package:nectracker/repositories/lote_repository.dart';
import 'dart:typed_data';
import 'tela_visualizar_pdf.dart';

class TelaDetalhesLote extends StatefulWidget {
  final LoteReadApiModel lote;

  const TelaDetalhesLote({super.key, required this.lote});

  @override
  State<TelaDetalhesLote> createState() => _TelaDetalhesLoteState();
}

class _TelaDetalhesLoteState extends State<TelaDetalhesLote> {
  final LoteRepository _loteRepo = LoteRepository();
  bool _gerandoQrCode = false;

  Future<void> _gerarQrCode() async {
    setState(() {
      _gerandoQrCode = true;
    });

    try {
      final Uint8List pdfBytes = await _loteRepo.gerarQrCode(widget.lote.id);
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TelaVisualizarPdf(
              pdfBytes: pdfBytes,
              titulo:
                  'QR Code - Lote #${widget.lote.id.length >= 8 ? "${widget.lote.id.substring(0, 4).toUpperCase()}${widget.lote.id.substring(widget.lote.id.length - 4).toUpperCase()}" : widget.lote.id.toUpperCase()}',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        String mensagemErro = e.toString();
        if (mensagemErro.startsWith('Exception: ')) {
          mensagemErro = mensagemErro.substring(11);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao gerar QR Code: $mensagemErro')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _gerandoQrCode = false;
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Detalhes do Lote',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.inventory_2,
                    size: 80,
                    color: Color(0xFFFEC107),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Lote #${widget.lote.id.length >= 8 ? "${widget.lote.id.substring(0, 4).toUpperCase()}${widget.lote.id.substring(widget.lote.id.length - 4).toUpperCase()}" : widget.lote.id.toUpperCase()}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildDetailRow('Quantidade:',
                '${widget.lote.qtdColeta.toStringAsFixed(2)} kg'),
            _buildDetailRow('Data da Coleta:',
                DateFormat('dd/MM/yyyy').format(widget.lote.dataColeta)),
            _buildDetailRow('Armazenamento:',
                widget.lote.armazenamentoColeta ?? 'Não informado'),
            _buildDetailRow('Coletor:', widget.lote.coletor ?? 'Não informado'),
            _buildDetailRow('Local Proc.:',
                widget.lote.localProcessamento ?? 'Não informado'),
            _buildDetailRow('Tipo Proc.:',
                widget.lote.tipoProcessamento ?? 'Não informado'),
            if (widget.lote.latitude != null && widget.lote.longitude != null)
              _buildDetailRow('Localização:',
                  '${widget.lote.latitude}, ${widget.lote.longitude}'),
            const SizedBox(height: 48),
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
                onPressed: _gerandoQrCode ? null : _gerarQrCode,
                child: _gerandoQrCode
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.qr_code, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Gerar QR Code',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
