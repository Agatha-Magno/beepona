import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Lote extends StatelessWidget {
  final String id;
  final double qtdColeta;
  final String? armazenamentoColeta;
  final String? coletor;
  final DateTime dataColeta;
  final String? localProcessamento;
  final String? tipoProcessamento;

  const Lote({
    super.key,
    required this.id,
    required this.qtdColeta,
    this.armazenamentoColeta,
    this.coletor,
    required this.dataColeta,
    this.localProcessamento,
    this.tipoProcessamento,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE49A),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.inventory_2_outlined,
                size: 28,
                color: Colors.black,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Lote #${id.length >= 8 ? "${id.substring(0, 4).toUpperCase()}${id.substring(id.length - 4).toUpperCase()}" : id.toUpperCase()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Quantidade:',
              '${qtdColeta.toStringAsFixed(2)} unidades'), // Unit handle later
          _buildInfoRow(
              'Armazenamento:', armazenamentoColeta ?? 'Não informado'),
          _buildInfoRow('Coletor:', coletor ?? 'Não informado'),
          _buildInfoRow('Data:', DateFormat('dd/MM/yyyy').format(dataColeta)),
          _buildInfoRow('Local Proc.:', localProcessamento ?? 'Não informado'),
          _buildInfoRow('Tipo Proc.:', tipoProcessamento ?? 'Não informado'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label ',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
